// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:rolo/features/auth/presentation/view/signup_page_view.dart';
// import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
// import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_event.dart';
// import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
// import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_state.dart';

// class MockRegisterViewModel extends Mock implements RegisterViewModel {}
// class MockLoginViewModel extends Mock implements LoginViewModel {}
// class MockBuildContext extends Mock implements BuildContext {}

// void main() {
//   late RegisterViewModel mockRegisterViewModel;
//   late LoginViewModel mockLoginViewModel;

//   setUpAll(() {
//      registerFallbackValue(RegisterUserEvent(context: MockBuildContext(), fName: '', lName: '', email: '', password: ''));
//   });

//   setUp(() {
//     mockRegisterViewModel = MockRegisterViewModel();
//     mockLoginViewModel = MockLoginViewModel();
//     when(() => mockRegisterViewModel.state).thenReturn(const RegisterState.initial());
//     when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.value(const RegisterState.initial()));
//     when(() => mockLoginViewModel.state).thenReturn(const LoginState.initial());
//     when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.value(const LoginState.initial()));
//   });

//   Widget createWidgetUnderTest() {
//     return MaterialApp(
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider<RegisterViewModel>.value(value: mockRegisterViewModel),
//           BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
//         ],
//         child: SignUpScreen(),
//       ),
//     );
//   }

//   group('SignUpScreen', () {
//     testWidgets('tapping Sign Up button dispatches RegisterUserEvent', (tester) async {
//       // Arrange
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();

//       // Act
//       await tester.enterText(find.widgetWithText(TextFormField, 'First Name'), 'John');
//       await tester.enterText(find.widgetWithText(TextFormField, 'Last Name'), 'Doe');
//       await tester.enterText(find.widgetWithText(TextFormField, 'Your email address'), 'john.doe@test.com');
//       await tester.enterText(find.widgetWithText(TextFormField, 'Create a password'), 'password123');
//       await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
//       await tester.pump();

//       // Assert
//       final captured = verify(() => mockRegisterViewModel.add(captureAny())).captured;
//       expect(captured.whereType<RegisterUserEvent>().length, 1);
//     });

//     testWidgets('shows loading indicator when RegisterState is loading', (tester) async {
//       // Arrange
//       when(() => mockRegisterViewModel.state).thenReturn(const RegisterState(isLoading: true, isSuccess: false));
//       when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.value(const RegisterState(isLoading: true, isSuccess: false)));
      
//       // Act
//       await tester.pumpWidget(createWidgetUnderTest());

//       // Assert
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });
//   });
// }











































// test/features/auth/presentation/view/signup_page_view_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/widgets/animated_button.dart';
import 'package:rolo/features/auth/presentation/view/signup_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// --- Mock Classes ---
class MockRegisterViewModel extends Mock implements RegisterViewModel {}
class MockLoginViewModel extends Mock implements LoginViewModel {}
class MockNavigator extends Mock implements NavigatorObserver {}

// --- Fake Classes for Events ---
class FakeRegisterUserEvent extends Fake implements RegisterUserEvent {}
class FakeLoginWithGoogleEvent extends Fake implements LoginWithGoogleEvent {}

void main() {
  late RegisterViewModel mockRegisterViewModel;
  late LoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(FakeRegisterUserEvent());
    registerFallbackValue(FakeLoginWithGoogleEvent());
  });

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
    mockLoginViewModel = MockLoginViewModel();
  });

  Widget createWidgetUnderTest({NavigatorObserver? navigatorObserver}) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RegisterViewModel>.value(value: mockRegisterViewModel),
          BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
        ],
        child: const SignUpScreen(),
      ),
      navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
    );
  }

  group('SignUpScreen', () {
    // Reusable setup for initial state
    void arrangeInitialState() {
      when(() => mockRegisterViewModel.state).thenReturn(const RegisterState(isLoading: false, isSuccess: false));
      when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.fromIterable([const RegisterState(isLoading: false, isSuccess: false)]));
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false)]));
    }

    // Test 2: Back button is present
    testWidgets('app bar back button is present', (tester) async {
      arrangeInitialState();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });
    
    // Test 3: Loading state from RegisterViewModel
    testWidgets('shows loading indicator when RegisterViewModel is loading', (tester) async {
      when(() => mockRegisterViewModel.state).thenReturn(const RegisterState(isLoading: true, isSuccess: false));
      when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.fromIterable([const RegisterState(isLoading: true, isSuccess: false)]));
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false)]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 4: Loading state from LoginViewModel
    testWidgets('shows loading indicator when LoginViewModel is loading', (tester) async {
      when(() => mockRegisterViewModel.state).thenReturn(const RegisterState(isLoading: false, isSuccess: false));
      when(() => mockRegisterViewModel.stream).thenAnswer((_) => Stream.fromIterable([const RegisterState(isLoading: false, isSuccess: false)]));
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([const LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false)]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 5: Form validation for empty fields
    testWidgets('shows validation errors when form is submitted empty', (tester) async {
      arrangeInitialState();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));
      
      await tester.tap(find.widgetWithText(AnimatedButton, 'Sign Up'));
      await tester.pump(); // a single pump is enough to show validation errors

      expect(find.text('Enter first name'), findsOneWidget);
      expect(find.text('Enter last name'), findsOneWidget);
      expect(find.text('Enter email'), findsOneWidget);
      expect(find.text('Enter password'), findsOneWidget);
    });

    // Test 6: Form validation for invalid email
    testWidgets('shows invalid email validation error', (tester) async {
      arrangeInitialState();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));
      
      await tester.enterText(find.byType(TextFormField).at(2), 'invalid-email');
      await tester.tap(find.widgetWithText(AnimatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Enter valid email'), findsOneWidget);
    });

    // Test 7: Successfully dispatches RegisterUserEvent
    testWidgets('dispatches RegisterUserEvent when form is valid and submitted', (tester) async {
      arrangeInitialState();
      when(() => mockRegisterViewModel.add(any())).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2));
      
      await tester.enterText(find.byType(TextFormField).at(0), 'Test');
      await tester.enterText(find.byType(TextFormField).at(1), 'User');
      await tester.enterText(find.byType(TextFormField).at(2), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      
      await tester.tap(find.widgetWithText(AnimatedButton, 'Sign Up'));
      await tester.pump();

      final captured = verify(() => mockRegisterViewModel.add(captureAny())).captured;
      expect(captured.last, isA<RegisterUserEvent>());
    });
  });
}