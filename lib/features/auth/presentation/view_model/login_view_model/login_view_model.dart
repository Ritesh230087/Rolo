import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rolo/core/secure_storage/auth_secure_storage.dart';
import 'package:rolo/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rolo/features/auth/domain/use_case/register_fcm_token_usecase.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final RegisterFCMTokenUseCase _registerFCMTokenUseCase; 
  final AuthSecureStorage _authSecureStorage;
  final LocalAuthentication _localAuth;
  final GoogleSignIn _googleSignIn;

  LoginViewModel({
    required UserLoginUsecase userLoginUsecase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required RegisterFCMTokenUseCase registerFCMTokenUseCase,
    required AuthSecureStorage authSecureStorage,
    required LocalAuthentication localAuth,
    required GoogleSignIn googleSignIn,
  })  : _userLoginUsecase = userLoginUsecase,
        _loginWithGoogleUseCase = loginWithGoogleUseCase,
        _registerFCMTokenUseCase = registerFCMTokenUseCase, 
        _authSecureStorage = authSecureStorage,
        _localAuth = localAuth,
        _googleSignIn = googleSignIn,
        super(const LoginState.initial()) {
    on<LoginResetEvent>((event, emit) {
      emit(const LoginState.initial());
    });
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithBiometricsEvent>(_onLoginWithBiometrics);
    on<CheckForSavedCredentialsEvent>(_onCheckForSavedCredentials);
  }

  Future<void> _registerDeviceForNotifications() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        await _registerFCMTokenUseCase(fcmToken);
        debugPrint('FCM Token registered successfully: $fcmToken');
      }
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  Future<void> _onCheckForSavedCredentials(
    CheckForSavedCredentialsEvent event,
    Emitter<LoginState> emit,
  ) async {
    final credentials = await _authSecureStorage.getCredentials();
    if (emit.isDone) return;
    emit(state.copyWith(canUseBiometrics: credentials != null));
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (emit.isDone) return;
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUsecase(LoginParams(email: event.email, password: event.password));

    await result.fold(
      (failure) async {
        if (emit.isDone) return;
        ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(content: Text(failure.message)));
        emit(state.copyWith(isLoading: false));
      },
      (token) async {
        await _registerDeviceForNotifications();

        await _authSecureStorage.saveCredentials(event.email, event.password);
        if (emit.isDone) return;
        emit(state.copyWith(isLoading: false, isSuccess: true, canUseBiometrics: true));
      },
    );
  }

  Future<void> _onLoginWithBiometrics(
    LoginWithBiometricsEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final bool canAuth = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!canAuth) return;

      final bool didAuth = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (didAuth) {
        final creds = await _authSecureStorage.getCredentials();
        if (creds != null) {
          add(LoginWithEmailAndPasswordEvent(context: event.context, email: creds['email']!, password: creds['password']!));
        }
      }
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (emit.isDone) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (emit.isDone) return;
        emit(state.copyWith(isLoading: false));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Could not get Google ID token.');
      }

      final result = await _loginWithGoogleUseCase(idToken);

      await result.fold(
        (failure) async {
          if (emit.isDone) return;
          ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(content: Text(failure.message)));
          emit(state.copyWith(isLoading: false));
        },
        (token) async {
          await _userLoginUsecase.saveTokenAfterExternalLogin(token);
          await _registerDeviceForNotifications();
          
          if (emit.isDone) return;
          emit(state.copyWith(isLoading: false, isSuccess: true));
        },
      );
    } catch (error) {
      if (emit.isDone) return;
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $error')));
      emit(state.copyWith(isLoading: false));
      debugPrint('Google Sign-In error: $error');
    }
  }
}