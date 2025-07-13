import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Mock Classes
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late MockUserLoginUsecase mockUserLoginUsecase;
  late LoginViewModel loginViewModel;
  late MockBuildContext mockContext;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'dummy_token';

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    mockContext = MockBuildContext();
    loginViewModel = LoginViewModel(mockUserLoginUsecase);

    // Mock the context.mounted property to return true
    when(() => mockContext.mounted).thenReturn(true);
  });

  tearDown(() {
    loginViewModel.close();
  });

  test('initial state is LoginState.initial()', () {
    expect(loginViewModel.state, LoginState.initial());
  });

  group('LoginWithEmailAndPasswordEvent', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [loading true, success true] when login succeeds',
      build: () {
        when(() => mockUserLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            )).thenAnswer((_) async => Right(testToken));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        email: testEmail,
        password: testPassword,
        context: mockContext,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => mockUserLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            )).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading true, success false] when login fails',
      build: () {
        when(() => mockUserLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            )).thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'Login failed')));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        email: testEmail,
        password: testPassword,
        context: mockContext,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
      verify: (_) {
        verify(() => mockUserLoginUsecase.call(
              LoginParams(email: testEmail, password: testPassword),
            )).called(1);
      },
    );
  });
}
