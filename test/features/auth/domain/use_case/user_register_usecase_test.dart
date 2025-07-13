import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';

/// ✅ Mock class for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

/// ✅ Concrete Failure class for testing
class MockFailure extends Failure {
  const MockFailure({required super.message});
}

void main() {
  late MockUserRepository mockUserRepository;
  late UserRegisterUsecase usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UserRegisterUsecase(userRepository: mockUserRepository);

    // Register fallback value for UserEntity
    registerFallbackValue(const UserEntity(
      fName: '',
      lName: '',
      email: '',
      password: '',
    ));
  });

  test(
    'should call registerUser on IUserRepository and return Right(null)',
    () async {
      const params = RegisterUserParams(
        fname: 'John',
        lname: 'Doe',
        email: 'john@example.com',
        password: '123456',
      );

      final expectedUser = UserEntity(
        fName: 'John',
        lName: 'Doe',
        email: 'john@example.com',
        password: '123456',
      );

      // Arrange
      when(() => mockUserRepository.registerUser(expectedUser))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Right(null));
      verify(() => mockUserRepository.registerUser(expectedUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    },
  );

  test(
    'should return Left(Failure) when repository fails',
    () async {
      const params = RegisterUserParams(
        fname: 'John',
        lname: 'Doe',
        email: 'john@example.com',
        password: '123456',
      );

      final expectedUser = UserEntity(
        fName: 'John',
        lName: 'Doe',
        email: 'john@example.com',
        password: '123456',
      );

      const failure = MockFailure(message: "Registration failed");

      // Arrange
      when(() => mockUserRepository.registerUser(expectedUser))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockUserRepository.registerUser(expectedUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    },
  );

  tearDown(() {
    reset(mockUserRepository);
  });
}
