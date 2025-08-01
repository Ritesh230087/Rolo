// test/features/home/data/repository/home_repository_impl_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/home/data/data_source/local_datasource/home_local_data_source.dart';
import 'package:rolo/features/home/data/data_source/remote_data_source/home_remote_data_source.dart';
import 'package:rolo/features/home/data/repository/home_repository_impl.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';

// --- MOCK CLASSES ---
class MockHomeRemoteDataSource extends Mock implements IHomeRemoteDataSource {}
class MockHomeLocalDataSource extends Mock implements IHomeLocalDataSource {}
class MockConnectivity extends Mock implements Connectivity {}

// --- FAKE CLASS for mocktail's registerFallbackValue ---
class FakeHomeEntity extends Fake implements HomeEntity {}

void main() {
  late HomeRepositoryImpl repository;
  late IHomeRemoteDataSource mockRemoteDataSource;
  late IHomeLocalDataSource mockLocalDataSource;
  late MockConnectivity mockConnectivity;

  // This MUST be run once before all tests.
  setUpAll(() {
    // CRITICAL FIX: This tells mocktail how to handle the `any()` matcher for HomeEntity,
    // which was causing the "Bad state" error.
    registerFallbackValue(FakeHomeEntity());
  });

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    mockLocalDataSource = MockHomeLocalDataSource();
    mockConnectivity = MockConnectivity();
    repository = HomeRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockConnectivity,
    );
  });

  const tHomeEntity = HomeEntity(categories: [], featuredProducts: [], ribbonSections: []);

  group('getHomeData', () {
    // This test simulates the only path your current code can take: the "online" path.
    test('should fetch from remote source because the connectivity check always passes', () async {
      // Arrange
      // It doesn't matter if we simulate online or offline; your code will enter the 'if' block.
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      
      // We MUST stub the remote data source call, as it will always be called.
      when(() => mockRemoteDataSource.getHomeData())
          .thenAnswer((_) async => tHomeEntity);
      
      when(() => mockLocalDataSource.cacheHomeData(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getHomeData();

      // Assert
      expect(result, const Right(tHomeEntity));
      verify(() => mockRemoteDataSource.getHomeData()).called(1);
      verify(() => mockLocalDataSource.cacheHomeData(tHomeEntity)).called(1);
    });

    test('should return ServerFailure when remote source throws an exception', () async {
        // Arrange
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);
        when(() => mockRemoteDataSource.getHomeData())
            .thenThrow(Exception('Server is down'));

        // Act
        final result = await repository.getHomeData();

        // Assert
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Server is down'));
          },
          (data) => fail('should not have returned data'),
        );
        verify(() => mockRemoteDataSource.getHomeData()).called(1);
        verifyZeroInteractions(mockLocalDataSource); // Should not cache on failure
    });
  });
}