// test/features/home/domain/use_case/get_home_data_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/repository/home_repository.dart';
import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';

class MockHomeRepository extends Mock implements IHomeRepository {}

void main() {
  late GetHomeDataUsecase usecase;
  late IHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    usecase = GetHomeDataUsecase(mockRepository);
  });
  
  const tHomeEntity = HomeEntity(categories: [], featuredProducts: [], ribbonSections: []);

  group('GetHomeDataUsecase', () {
    test('should get home data from the repository', () async {
      // Arrange
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) async => const Right(tHomeEntity));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(tHomeEntity));
      verify(() => mockRepository.getHomeData()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when the repository call is unsuccessful', () async {
      // Arrange
      final tFailure = ServerFailure(message: 'Could not fetch data');
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.getHomeData()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}