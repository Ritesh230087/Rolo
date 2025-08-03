import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/core/widgets/animated_button.dart';

// --- Mock Classes ---
class MockLoginViewModel extends Mock implements LoginViewModel {}

// --- Fake Classes for Events ---
class FakeLoginResetEvent extends Fake implements LoginResetEvent {}
class FakeCheckForSavedCredentialsEvent extends Fake implements CheckForSavedCredentialsEvent {}
class FakeLoginWithEmailAndPasswordEvent extends Fake implements LoginWithEmailAndPasswordEvent {}
class FakeLoginWithBiometricsEvent extends Fake implements LoginWithBiometricsEvent {}
class FakeLoginWithGoogleEvent extends Fake implements LoginWithGoogleEvent {}

void main() {
  late LoginViewModel mockLoginViewModel;

  setUpAll(() {
    // Register fallback values for all event types
    registerFallbackValue(FakeLoginResetEvent());
    registerFallbackValue(FakeCheckForSavedCredentialsEvent());
    registerFallbackValue(FakeLoginWithEmailAndPasswordEvent());
    registerFallbackValue(FakeLoginWithBiometricsEvent());
    registerFallbackValue(FakeLoginWithGoogleEvent());
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
  });

  Widget createWidgetUnderTest({bool showLogoutSuccessSnackbar = false}) {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: LoginScreen(showLogoutSuccessSnackbar: showLogoutSuccessSnackbar),
      ),
    );
  }

  group('LoginScreen Tests', () {

    // --- TEST 2: Check the loading state ---
    testWidgets('shows loading indicators when in loading state', (WidgetTester tester) async {
      // ARRANGE:
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(
        isLoading: true,
        isSuccess: false,
        canUseBiometrics: false,
      ));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false)
      ]));
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // ACT:
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // ASSERT:
      // Should find CircularProgressIndicator in both AnimatedButton and Google button
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
      
      // Verify the AnimatedButton shows loading state
      final animatedButton = tester.widget<AnimatedButton>(find.byType(AnimatedButton));
      expect(animatedButton.isLoading, isTrue);
    });

    testWidgets('shows logout success snackbar when showLogoutSuccessSnackbar is true', (WidgetTester tester) async {
      // ARRANGE:
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(
        isLoading: false,
        isSuccess: false,
        canUseBiometrics: false,
      ));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false)
      ]));
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // ACT:
      await tester.pumpWidget(createWidgetUnderTest(showLogoutSuccessSnackbar: true));
      await tester.pump(); // Initial build
      await tester.pump(); // Post-frame callback execution
      await tester.pump(const Duration(milliseconds: 100)); // Animation completion

      // ASSERT:
      expect(find.text('You have been logged out successfully.'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    // --- BONUS TEST: Password visibility toggle ---
    testWidgets('toggles password visibility when eye icon is tapped', (WidgetTester tester) async {
      // ARRANGE:
      when(() => mockLoginViewModel.state).thenReturn(const LoginState(
        isLoading: false,
        isSuccess: false,
        canUseBiometrics: false,
      ));
      when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.fromIterable([
        const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false)
      ]));
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // ACT:
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find password field and visibility toggle
      final visibilityToggle = find.byIcon(Icons.visibility_off);

      // Initially visibility_off icon should be present (password is obscured)
      expect(visibilityToggle, findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap visibility toggle
      await tester.tap(visibilityToggle);
      await tester.pump();

      // After tap, icon should change to visibility (password is now visible)
      expect(find.byIcon(Icons.visibility_off), findsNothing);
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to toggle back
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Should be back to visibility_off (password obscured again)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });
  });
}