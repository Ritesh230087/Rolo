// test/features/auth/domain/use_case/forgot_password_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/forgot_password_usecase.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository mockRepository;
  late ForgotPasswordUseCase useCase;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = ForgotPasswordUseCase(mockRepository);
  });

  const email = 'user@example.com';
  
  group('ForgotPasswordUseCase', () {
    test('should call sendPasswordResetLink on the repository and succeed', () async {
      // Arrange
      when(() => mockRepository.sendPasswordResetLink(any())).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(email);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRepository.sendPasswordResetLink(email)).called(1);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange
      final failure = RemoteDatabaseFailure(message: 'User not found');
      when(() => mockRepository.sendPasswordResetLink(any())).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(email);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.sendPasswordResetLink(email)).called(1);
    });
  });
}