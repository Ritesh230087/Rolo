// test/features/auth/domain/use_case/register_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';

class MockUserRepository extends Mock implements IUserRepository {}
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

void main() {
  late IUserRepository mockUserRepository;
  late UserLoginUsecase mockUserLoginUsecase;
  late UserRegisterUsecase userRegisterUsecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockUserLoginUsecase = MockUserLoginUsecase();
    userRegisterUsecase = UserRegisterUsecase(
      userRepository: mockUserRepository,
      userLoginUsecase: mockUserLoginUsecase,
    );
    registerFallbackValue(const LoginParams.initial());
    registerFallbackValue(const UserEntity(fName: '', lName: '', email: ''));
  });

  const registerParams = RegisterUserParams(fname: 'a', lname: 'b', email: 'c', password: 'd');
  
  group('UserRegisterUsecase', () {
    test('should register and then login the user, returning a token', () async {
      // Arrange
      when(() => mockUserRepository.registerUser(any())).thenAnswer((_) async => const Right(unit));
      when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right('new_token'));

      // Act
      final result = await userRegisterUsecase(registerParams);

      // Assert
      expect(result, const Right('new_token'));
      verify(() => mockUserRepository.registerUser(any())).called(1);
      verify(() => mockUserLoginUsecase(any())).called(1);
    });

    test('should return failure if registration fails and not attempt to login', () async {
      // Arrange
      final failure = RemoteDatabaseFailure(message: 'Email already exists');
      when(() => mockUserRepository.registerUser(any())).thenAnswer((_) async => Left(failure));

      // Act
      final result = await userRegisterUsecase(registerParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockUserRepository.registerUser(any())).called(1);
      verifyNever(() => mockUserLoginUsecase(any()));
    });
  });
}