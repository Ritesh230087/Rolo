import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/app/shared_pref/token_shared_pref.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';

/// Mock classes
class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

/// Dummy failure class for Left case
class MockFailure extends Failure {
  const MockFailure({required super.message});
}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late UserLoginUsecase usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const tEmail = 'john@example.com';
  const tPassword = '123456';
  const tToken = 'token123';

  test('should return Right(token) when login is successful', () async {
    // Arrange
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tToken));

    // ✅ Correct mock for Future<void>
    when(() => mockTokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => Future.value());

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Right(tToken));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
  });

  test('should return Left(Failure) when login fails', () async {
    // Arrange
    const failure = MockFailure(message: 'Login failed');
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Left(failure));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verifyZeroInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
