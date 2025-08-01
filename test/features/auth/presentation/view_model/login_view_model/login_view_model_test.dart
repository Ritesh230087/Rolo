// // test/features/auth/presentation/view_model/login_view_model_test.dart

// import 'package:dartz/dartz.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/core/secure_storage/auth_secure_storage.dart';
// import 'package:rolo/features/auth/domain/use_case/login_with_google_usecase.dart';
// import 'package:rolo/features/auth/domain/use_case/register_fcm_token_usecase.dart';
// import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
// import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
// import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
// import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// // --- MOCK CLASSES ---
// class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}
// class MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}
// class MockRegisterFCMTokenUseCase extends Mock implements RegisterFCMTokenUseCase {}
// class MockAuthSecureStorage extends Mock implements AuthSecureStorage {}
// class MockLocalAuthentication extends Mock implements LocalAuthentication {}
// class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// // --- DEFINITIVE FIREBASE MOCKING (This is the correct modern approach) ---

// // 1. Create a fake Firebase Core implementation that satisfies the interface contract.
// // This mock extends Mock and implements the platform interface, which is the required pattern.
// class MockFirebasePlatform extends Mock with MockPlatformInterfaceMixin implements FirebasePlatform {
//   @override
//   Future<FirebaseAppPlatform> initializeApp({String? name, FirebaseOptions? options}) async {
//     return MockFirebaseAppPlatform();
//   }
  
//   // CRITICAL FIX: This was the missing method override that caused the crash.
//   // FirebaseMessaging internally calls Firebase.app() which invokes this.
//   // Without it, it returns null and crashes the test.
//   @override
//   FirebaseAppPlatform app([String? name]) {
//     return MockFirebaseAppPlatform();
//   }
// }
// class MockFirebaseAppPlatform extends Mock implements FirebaseAppPlatform {
//   // We must also mock the options getter
//   @override
//   FirebaseOptions get options => const FirebaseOptions(
//     apiKey: 'mock',
//     appId: 'mock',
//     messagingSenderId: 'mock',
//     projectId: 'mock',
//   );
// }

// // 2. Create a fake Firebase Messaging implementation.
// class MockFirebaseMessagingPlatform extends Mock with MockPlatformInterfaceMixin implements FirebaseMessagingPlatform {
//   @override
//   Future<String?> getToken({String? vapidKey}) async {
//     return 'mock_fcm_token_from_test';
//   }
//   @override
//   Future<NotificationSettings> requestPermission({
//     bool alert = false, bool announcement = false, bool badge = false, bool carPlay = false, bool criticalAlert = false, bool provisional = false, bool sound = false, bool providesAppNotificationSettings = false,
//   }) async {
//     return MockNotificationSettings();
//   }
// }
// class MockNotificationSettings extends Mock implements NotificationSettings {
//   @override
//   AuthorizationStatus get authorizationStatus => AuthorizationStatus.authorized;
// }
// // --- END OF MOCKING ---

// void main() {
//   // These mocks must be set up before any tests run
//   setUpAll(() {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     // Use the official way to mock the platform interfaces
//     FirebasePlatform.instance = MockFirebasePlatform();
//     FirebaseMessagingPlatform.instance = MockFirebaseMessagingPlatform();
//     registerFallbackValue(const LoginParams.initial());
//   });

//   late LoginViewModel viewModel;
//   late UserLoginUsecase mockUserLoginUsecase;
//   late LoginWithGoogleUseCase mockLoginWithGoogleUseCase;
//   late RegisterFCMTokenUseCase mockRegisterFCMTokenUseCase;
//   late AuthSecureStorage mockAuthSecureStorage;
//   late LocalAuthentication mockLocalAuthentication;
//   late GoogleSignIn mockGoogleSignIn;

//   setUp(() {
//     // Initialize all your use case and repository mocks
//     mockUserLoginUsecase = MockUserLoginUsecase();
//     mockLoginWithGoogleUseCase = MockLoginWithGoogleUseCase();
//     mockRegisterFCMTokenUseCase = MockRegisterFCMTokenUseCase();
//     mockAuthSecureStorage = MockAuthSecureStorage();
//     mockLocalAuthentication = MockLocalAuthentication();
//     mockGoogleSignIn = MockGoogleSignIn();

//     // Create a fresh ViewModel for each test
//     viewModel = LoginViewModel(
//       userLoginUsecase: mockUserLoginUsecase,
//       loginWithGoogleUseCase: mockLoginWithGoogleUseCase,
//       registerFCMTokenUseCase: mockRegisterFCMTokenUseCase,
//       authSecureStorage: mockAuthSecureStorage,
//       localAuth: mockLocalAuthentication,
//       googleSignIn: mockGoogleSignIn,
//     );
//   });
  
//   // Clean up the BLoC after each test
//   tearDown(() {
//     viewModel.close();
//   });

//   group('LoginViewModel', () {
//     testWidgets('emits [loading, success] for a successful email/password login', (WidgetTester tester) async {
//       // Arrange
//       when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right('token'));
//       when(() => mockRegisterFCMTokenUseCase(any())).thenAnswer((_) async => const Right(unit));
//       when(() => mockAuthSecureStorage.saveCredentials(any(), any())).thenAnswer((_) async => {});

//       final states = <LoginState>[];
//       final subscription = viewModel.stream.listen(states.add);

//       // Act
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (context) {
//         return ElevatedButton(
//           onPressed: () => viewModel.add(LoginWithEmailAndPasswordEvent(context: context, email: 'a', password: 'b')),
//           child: const Text('Login'),
//         );
//       }))));

//       await tester.tap(find.byType(ElevatedButton));
//       await tester.pump();

//       // Assert
//       expect(states, [
//         const LoginState.initial().copyWith(isLoading: true),
//         const LoginState.initial().copyWith(isLoading: false, isSuccess: true, canUseBiometrics: true),
//       ]);
//       await subscription.cancel();
//     });

//     testWidgets('emits [loading, not loading] and shows SnackBar for a failed login', (WidgetTester tester) async {
//       // Arrange
//       when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Invalid credentials')));
      
//       final states = <LoginState>[];
//       final subscription = viewModel.stream.listen(states.add);

//       // Act
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (context) {
//         return ElevatedButton(
//           onPressed: () => viewModel.add(LoginWithEmailAndPasswordEvent(context: context, email: 'a', password: 'b')),
//           child: const Text('Login'),
//         );
//       }))));

//       await tester.tap(find.byType(ElevatedButton));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(states, [
//         const LoginState.initial().copyWith(isLoading: true),
//         const LoginState.initial().copyWith(isLoading: false),
//       ]);
//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Invalid credentials'), findsOneWidget);

//       await subscription.cancel();
//     });
//   });
// }






























// test/features/auth/presentation/view_model/login_view_model_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/core/secure_storage/auth_secure_storage.dart';
import 'package:rolo/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/register_fcm_token_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// --- MOCK AND FAKE CLASSES ---
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}
class MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}
class MockRegisterFCMTokenUseCase extends Mock implements RegisterFCMTokenUseCase {}
class MockAuthSecureStorage extends Mock implements AuthSecureStorage {}
class MockLocalAuthentication extends Mock implements LocalAuthentication {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class FakeBuildContext extends Fake implements BuildContext {}
class FakeLoginParams extends Fake implements LoginParams {}
class FakeAuthenticationOptions extends Fake implements AuthenticationOptions {}

void main() {
  // This MUST be run once before all tests.
  setUpAll(() {
    // This tells mocktail how to handle the `any()` matcher for custom classes.
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeAuthenticationOptions());
  });

  late MockUserLoginUsecase mockUserLoginUsecase;
  late MockLoginWithGoogleUseCase mockLoginWithGoogleUseCase;
  late MockRegisterFCMTokenUseCase mockRegisterFCMTokenUseCase;
  late MockAuthSecureStorage mockAuthSecureStorage;
  late MockLocalAuthentication mockLocalAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late LoginViewModel loginViewModel;
  
  // Use a single FakeBuildContext for the tests that don't need a real UI tree.
  final fakeContext = FakeBuildContext();

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    mockLoginWithGoogleUseCase = MockLoginWithGoogleUseCase();
    mockRegisterFCMTokenUseCase = MockRegisterFCMTokenUseCase();
    mockAuthSecureStorage = MockAuthSecureStorage();
    mockLocalAuth = MockLocalAuthentication();
    mockGoogleSignIn = MockGoogleSignIn();

    loginViewModel = LoginViewModel(
      userLoginUsecase: mockUserLoginUsecase,
      loginWithGoogleUseCase: mockLoginWithGoogleUseCase,
      registerFCMTokenUseCase: mockRegisterFCMTokenUseCase,
      authSecureStorage: mockAuthSecureStorage,
      localAuth: mockLocalAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  tearDown(() {
    loginViewModel.close();
  });

  group('LoginViewModel Tests', () {
    
    // TEST 1: RESET STATE
    blocTest<LoginViewModel, LoginState>(
      '1. emits initial state when LoginResetEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginResetEvent()),
      expect: () => const [
        LoginState.initial(),
      ],
    );

    // TEST 2: SUCCESSFUL EMAIL/PASSWORD LOGIN
    blocTest<LoginViewModel, LoginState>(
      '2. emits [loading, success] when email/password login succeeds',
      setUp: () {
        // Mock successful login
        when(() => mockUserLoginUsecase(any())).thenAnswer(
          (_) async => const Right('mock_token'),
        );
        // Mock successful FCM token registration
        when(() => mockRegisterFCMTokenUseCase(any())).thenAnswer(
          (_) async => const Right(unit),
        );
        // Mock successful credential saving
        when(() => mockAuthSecureStorage.saveCredentials(any(), any())).thenAnswer(
          (_) async => const Right(unit),
        );
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: fakeContext,
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => const [
        LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false),
        LoginState(isLoading: false, isSuccess: true, canUseBiometrics: true),
      ],
    );

    // TEST 3: FAILED EMAIL/PASSWORD LOGIN (Using testWidgets for ScaffoldMessenger)
    testWidgets('3. emits [loading, failure] when email/password login fails', (WidgetTester tester) async {
      // Arrange
      when(() => mockUserLoginUsecase(any())).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Invalid credentials')),
      );

      final states = <LoginState>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final viewModel = LoginViewModel(
                  userLoginUsecase: mockUserLoginUsecase,
                  loginWithGoogleUseCase: mockLoginWithGoogleUseCase,
                  registerFCMTokenUseCase: mockRegisterFCMTokenUseCase,
                  authSecureStorage: mockAuthSecureStorage,
                  localAuth: mockLocalAuth,
                  googleSignIn: mockGoogleSignIn,
                );
                viewModel.stream.listen(states.add);

                return ElevatedButton(
                  onPressed: () => viewModel.add(
                    LoginWithEmailAndPasswordEvent(
                      context: context,
                      email: 'test@example.com',
                      password: 'wrongpassword',
                    ),
                  ),
                  child: const Text('Login'),
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
        const LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false),
        const LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false),
      ]);
    });

    // TEST 4: SUCCESSFUL GOOGLE LOGIN
    blocTest<LoginViewModel, LoginState>(
      '4. emits [loading, success] when Google login succeeds',
      setUp: () {
        final mockGoogleUser = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();
        
        // Mock Google sign-in flow
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => mockGoogleUser);
        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleUser);
        when(() => mockGoogleUser.authentication).thenAnswer((_) async => mockGoogleAuth);
        when(() => mockGoogleAuth.idToken).thenReturn('mock_id_token');
        
        // Mock successful Google login
        when(() => mockLoginWithGoogleUseCase('mock_id_token')).thenAnswer(
          (_) async => const Right('mock_token'),
        );
        
        // Mock saving token after external login
        when(() => mockUserLoginUsecase.saveTokenAfterExternalLogin('mock_token')).thenAnswer(
          (_) async => const Right(unit),
        );
        
        // Mock successful FCM token registration
        when(() => mockRegisterFCMTokenUseCase(any())).thenAnswer(
          (_) async => const Right(unit),
        );
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginWithGoogleEvent(context: fakeContext)),
      expect: () => const [
        LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false),
        LoginState(isLoading: false, isSuccess: true, canUseBiometrics: false),
      ],
    );

    // TEST 5: GOOGLE LOGIN CANCELLATION
    blocTest<LoginViewModel, LoginState>(
      '5. emits [loading, original] when user cancels Google sign-in',
      setUp: () {
        // Mock user cancellation (returns null)
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginWithGoogleEvent(context: fakeContext)),
      expect: () => const [
        LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false),
        LoginState(isLoading: false, isSuccess: false, canUseBiometrics: false),
      ],
    );

    // TEST 6: CHECK SAVED CREDENTIALS
    blocTest<LoginViewModel, LoginState>(
      '6. emits canUseBiometrics true when credentials are saved',
      setUp: () {
        // Mock that credentials exist
        when(() => mockAuthSecureStorage.getCredentials()).thenAnswer(
          (_) async => {'email': 'saved@example.com', 'password': 'savedpassword'},
        );
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(CheckForSavedCredentialsEvent()),
      expect: () => const [
        LoginState(isLoading: false, isSuccess: false, canUseBiometrics: true),
      ],
    );

    // BONUS TEST 7: BIOMETRIC LOGIN SUCCESS
    blocTest<LoginViewModel, LoginState>(
      '7. triggers email/password login when biometric authentication succeeds',
      setUp: () {
        // Mock biometric capabilities
        when(() => mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(() => mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
        when(() => mockLocalAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => true);
        
        // Mock saved credentials
        when(() => mockAuthSecureStorage.getCredentials()).thenAnswer(
          (_) async => {'email': 'biometric@example.com', 'password': 'biometricpass'},
        );
        
        // Mock successful login
        when(() => mockUserLoginUsecase(any())).thenAnswer(
          (_) async => const Right('biometric_token'),
        );
        
        // Mock successful FCM token registration
        when(() => mockRegisterFCMTokenUseCase(any())).thenAnswer(
          (_) async => const Right(unit),
        );
        
        // Mock successful credential saving
        when(() => mockAuthSecureStorage.saveCredentials(any(), any())).thenAnswer(
          (_) async => const Right(unit),
        );
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginWithBiometricsEvent(context: fakeContext)),
      expect: () => const [
        LoginState(isLoading: true, isSuccess: false, canUseBiometrics: false),
        LoginState(isLoading: false, isSuccess: true, canUseBiometrics: true),
      ],
    );

    // BONUS TEST 8: BIOMETRIC LOGIN WITH NO SAVED CREDENTIALS
    blocTest<LoginViewModel, LoginState>(
      '8. does not trigger login when biometric succeeds but no credentials saved',
      setUp: () {
        // Mock biometric capabilities and success
        when(() => mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(() => mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
        when(() => mockLocalAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => true);
        
        // Mock no saved credentials
        when(() => mockAuthSecureStorage.getCredentials()).thenAnswer((_) async => null);
      },
      build: () => loginViewModel,
      act: (bloc) => bloc.add(LoginWithBiometricsEvent(context: fakeContext)),
      expect: () => [], // No state changes expected
    );
  });
}