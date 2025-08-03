import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool canUseBiometrics; 

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    required this.canUseBiometrics,
  });

  const LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        canUseBiometrics = false;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? canUseBiometrics,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, canUseBiometrics];
}