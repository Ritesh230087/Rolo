// test/features/auth/presentation/view/forgot_password_view_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/features/auth/presentation/view/forgot_password_view.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_state.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_viewmodel.dart';

final serviceLocator = GetIt.instance;

// Your mock class must also implement the .close() method correctly
class MockForgotPasswordViewModel extends Mock implements ForgotPasswordViewModel {}

void main() {
  late MockForgotPasswordViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(const SendResetLink(''));
  });

  setUp(() {
    mockViewModel = MockForgotPasswordViewModel();

    // CRITICAL FIX #1: Stub the .close() method.
    // The BlocProvider will call this when the test ends. It must return a Future.
    when(() => mockViewModel.close()).thenAnswer((_) async {});
    
    // CRITICAL FIX #2: Register the mock with GetIt for the widget to find.
    if (serviceLocator.isRegistered<ForgotPasswordViewModel>()) {
      serviceLocator.unregister<ForgotPasswordViewModel>();
    }
    serviceLocator.registerSingleton<ForgotPasswordViewModel>(mockViewModel);
  });

  tearDown(() {
    // Clean up GetIt after each test
    serviceLocator.unregister<ForgotPasswordViewModel>();
  });
  
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ForgotPasswordScreen(),
    );
  }

  group('ForgotPasswordScreen', () {
    testWidgets('tapping button dispatches SendResetLink event with correct email', (tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(const ForgotPasswordState());
      when(() => mockViewModel.stream).thenAnswer((_) => Stream.value(const ForgotPasswordState()));
      
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.enterText(find.byType(TextFormField), 'user@test.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
      await tester.pump();

      // Assert
      final captured = verify(() => mockViewModel.add(captureAny())).captured.last as SendResetLink;
      expect(captured.email, 'user@test.com');
    });

    testWidgets('shows SnackBar on failure state', (tester) async {
      // Arrange
      whenListen(
        mockViewModel,
        Stream.fromIterable([
          const ForgotPasswordState(status: ForgotPasswordStatus.failure, errorMessage: 'User not found!'),
        ]),
        initialState: const ForgotPasswordState(),
      );
      
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.pumpAndSettle(); 

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('User not found!'), findsOneWidget);
    });
  });
}