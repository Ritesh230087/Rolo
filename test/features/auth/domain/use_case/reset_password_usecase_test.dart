// test/features/auth/domain/use_case/reset_password_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/reset_password_usecase.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  group('ResetPasswordUseCase', () {
    late IUserRepository mockRepository;
    late ResetPasswordUseCase useCase;

    setUp(() {
      mockRepository = MockUserRepository();
      useCase = ResetPasswordUseCase(mockRepository);
    });

    const params = ResetPasswordParams(token: 'valid-token', password: 'new-password');
    final failure = RemoteDatabaseFailure(message: 'Token expired');

    test('should call resetPassword on the repository with correct params', () async {
      // Arrange
      when(() => mockRepository.resetPassword(any(), any()))
          .thenAnswer((_) async => const Right(unit));
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result, const Right(unit));
      verify(() => mockRepository.resetPassword(params.token, params.password)).called(1);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange
      when(() => mockRepository.resetPassword(any(), any()))
          .thenAnswer((_) async => Left(failure));
          
      // Act
      final result = await useCase(params);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.resetPassword(params.token, params.password)).called(1);
    });
  });
}