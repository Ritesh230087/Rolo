import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SplashState {
  initial,
  navigateToHome,
  navigateToLogin,
}

class SplashViewModel extends Cubit<SplashState> {
  SplashViewModel() : super(SplashState.initial);

  Future<void> decideNavigation() async {
    await Future.delayed(const Duration(seconds: 10));

    final prefs = await SharedPreferences.getInstance();
    
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      emit(SplashState.navigateToHome);
    } else {
      emit(SplashState.navigateToLogin);
    }
  }
}