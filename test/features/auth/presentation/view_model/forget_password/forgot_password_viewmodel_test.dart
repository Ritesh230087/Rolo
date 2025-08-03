// test/features/auth/presentation/view_model/forgot_password_view_model_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_state.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_viewmodel.dart';

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  late ForgotPasswordUseCase mockUseCase;
  
  setUp(() => mockUseCase = MockForgotPasswordUseCase());

  group('ForgotPasswordViewModel', () {
    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, success] when sending reset link is successful',
      setUp: () => when(() => mockUseCase(any())).thenAnswer((_) async => const Right(unit)),
      build: () => ForgotPasswordViewModel(mockUseCase),
      act: (bloc) => bloc.add(const SendResetLink('test@example.com')),
      expect: () => const <ForgotPasswordState>[
        ForgotPasswordState(status: ForgotPasswordStatus.loading),
        ForgotPasswordState(status: ForgotPasswordStatus.success),
      ],
    );
    
    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, failure] with error message when sending reset link fails',
      setUp: () => when(() => mockUseCase(any())).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'User not found'))),
      build: () => ForgotPasswordViewModel(mockUseCase),
      act: (bloc) => bloc.add(const SendResetLink('test@example.com')),
      expect: () => <ForgotPasswordState>[
        const ForgotPasswordState(status: ForgotPasswordStatus.loading),
        const ForgotPasswordState(status: ForgotPasswordStatus.failure, errorMessage: 'User not found'),
      ],
    );
  });
}