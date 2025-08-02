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

// --- MOCK AND FAKE CLASSES ---
class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}
class FakeBuildContext extends Fake implements BuildContext {}
class FakeRegisterUserParams extends Fake implements RegisterUserParams {}

void main() {
  // This MUST be run once before all tests.
  setUpAll(() {
    // This tells mocktail how to handle the `any()` matcher for your custom class.
    registerFallbackValue(FakeRegisterUserParams());
  });

  late UserRegisterUsecase mockUsecase;
  late RegisterViewModel viewModel;
  
  // Use a single FakeBuildContext for the tests that don't need a real UI tree.
  final fakeContext = FakeBuildContext();

  setUp(() {
    mockUsecase = MockUserRegisterUsecase();
    viewModel = RegisterViewModel(mockUsecase);
  });

  tearDown(() {
    viewModel.close();
  });
  
  group('RegisterViewModel', () {
    final eventWithFakeContext = RegisterUserEvent(context: fakeContext, fName: 'a', lName: 'b', email: 'c', password: 'd');

    // TEST 1: SUCCESSFUL REGISTRATION
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when registration is successful',
      setUp: () {
        when(() => mockUsecase(any())).thenAnswer((_) async => const Right('valid_token'));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(eventWithFakeContext),
      expect: () => const <RegisterState>[
        RegisterState(isLoading: true, isSuccess: false),
        RegisterState(isLoading: false, isSuccess: true),
      ],
    );

    // TEST 2 (REPLACEMENT TEST): SUCCESSFUL REGISTRATION WITH EMPTY TOKEN
    // This test replaces the one that was causing UI-related errors.
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] even when use case returns an empty token',
      setUp: () {
        when(() => mockUsecase(any())).thenAnswer((_) async => const Right('')); // Return empty string token
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(eventWithFakeContext),
      expect: () => const <RegisterState>[
        RegisterState(isLoading: true, isSuccess: false),
        // Your current ViewModel code considers any `Right` value a success.
        RegisterState(isLoading: false, isSuccess: true),
      ],
    );
    
    // TEST 3: FAILED REGISTRATION (Using testWidgets)
    // This test MUST be a `testWidgets` test to provide a real context for ScaffoldMessenger.
testWidgets('emits [loading, failure] when registration use case fails', (WidgetTester tester) async {
  // Arrange
  when(() => mockUsecase(any())).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Registration Failed')));

  final states = <RegisterState>[];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            final viewModel = RegisterViewModel(mockUsecase);
            viewModel.stream.listen(states.add);

            return ElevatedButton(
              onPressed: () => viewModel.add(
                RegisterUserEvent(context: context, fName: 'a', lName: 'b', email: 'c', password: 'd'),
              ),
              child: const Text('Register'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump(); // let BLoC process the event
  await tester.pump(); // let SnackBar show

  // Assert
  expect(states, [
    const RegisterState(isLoading: true, isSuccess: false),
    const RegisterState(isLoading: false, isSuccess: false),
  ]);
});

  });
}