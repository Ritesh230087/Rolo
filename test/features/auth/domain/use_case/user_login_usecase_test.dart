// test/features/auth/domain/use_case/login_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/app/shared_pref/token_shared_pref.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';

class MockUserRepository extends Mock implements IUserRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late IUserRepository mockUserRepository;
  late TokenSharedPrefs mockTokenSharedPrefs;
  late UserLoginUsecase userLoginUsecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    userLoginUsecase = UserLoginUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const loginParams = LoginParams(email: 'test@test.com', password: 'password');
  const token = 'test_token';
  
  group('UserLoginUsecase', () {
    test('should return token when login and saveToken are successful', () async {
      // Arrange
      when(() => mockUserRepository.loginUser(any(), any())).thenAnswer((_) async => const Right(token));
      when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, const Right(token));
      verify(() => mockUserRepository.loginUser(loginParams.email, loginParams.password)).called(1);
      verify(() => mockTokenSharedPrefs.saveToken(token)).called(1);
    });

    test('should return failure when repository login fails', () async {
      // Arrange
      final failure = RemoteDatabaseFailure(message: 'Invalid credentials');
      when(() => mockUserRepository.loginUser(any(), any())).thenAnswer((_) async => Left(failure));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockUserRepository.loginUser(loginParams.email, loginParams.password)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });
  });
}