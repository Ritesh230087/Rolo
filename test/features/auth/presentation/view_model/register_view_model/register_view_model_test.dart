import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// === Mock and Fake Classes ===
class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

class FakeRegisterUserParams extends Fake implements RegisterUserParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRegisterUserParams());
    registerFallbackValue(FakeBuildContext());
  });

  late MockUserRegisterUsecase mockUserRegisterUsecase;
  late RegisterViewModel registerViewModel;

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();

    registerViewModel = RegisterViewModel(
      mockUserRegisterUsecase,
      // Inject no-op snackbar to avoid widget context error in tests
      showSnackBar: (_, __) {},
    );
  });

  tearDown(() {
    registerViewModel.close();
  });

  group('RegisterViewModel', () {
    final fakeContext = FakeBuildContext();

    final validEvent = RegisterUserEvent(
      context: fakeContext,
      fName: 'John',
      lName: 'Doe',
      email: 'john@example.com',
      password: 'password123',
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when registration succeeds',
      build: () {
        when(() => mockUserRegisterUsecase(any())).thenAnswer(
          (_) async => right(null),
        );
        return registerViewModel;
      },
      act: (bloc) => bloc.add(validEvent),
      expect: () => [
        const RegisterState(isLoading: true, isSuccess: false),
        const RegisterState(isLoading: false, isSuccess: true),
      ],
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, failure] when registration fails',
      build: () {
        when(() => mockUserRegisterUsecase(any())).thenAnswer(
          (_) async => left(RemoteDatabaseFailure(message: 'Registration failed')),
        );
        return registerViewModel;
      },
      act: (bloc) => bloc.add(validEvent),
      expect: () => [
        const RegisterState(isLoading: true, isSuccess: false),
        const RegisterState(isLoading: false, isSuccess: false),
      ],
    );
  });
}
