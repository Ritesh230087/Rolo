import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/core/common/snackbar/my_snack_bar.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:rolo/features/auth/presentation/view/signup_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:rolo/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:rolo/features/auth/domain/use_case/register_fcm_token_usecase.dart'; 
// -----------------------

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;
  final RegisterFCMTokenUseCase _registerFCMTokenUseCase;

  LoginViewModel({
    required UserLoginUsecase userLoginUsecase,
    required RegisterFCMTokenUseCase registerFCMTokenUseCase,
  })  : _userLoginUsecase = userLoginUsecase,
        _registerFCMTokenUseCase = registerFCMTokenUseCase,
        super(LoginState.initial()) {
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: 'Login Successful',
        );

        _registerDeviceToken();

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (event.context.mounted) {
            Navigator.pushReplacement(
              event.context,
              MaterialPageRoute(builder: (_) => const DashboardView()),
            );
          }
        });
      },
    );
  }

  Future<void> _registerDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        print("🚀 Sending FCM token to backend...");
        await _registerFCMTokenUseCase(fcmToken);
      } else {
        print("⚠️ Could not get FCM token. Device might not support it.");
      }
    } catch (e) {
      print("🔥 An error occurred during FCM token registration: $e");
    }
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
              ),
            ],
            child: SignUpScreen(),
          ),
        ),
      );
    }
  }
}