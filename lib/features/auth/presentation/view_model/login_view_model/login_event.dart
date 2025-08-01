import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}
class LoginResetEvent extends LoginEvent {}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class LoginWithGoogleEvent extends LoginEvent {
  final BuildContext context;
  LoginWithGoogleEvent({required this.context});
}

class LoginWithBiometricsEvent extends LoginEvent {
  final BuildContext context;
  LoginWithBiometricsEvent({required this.context});
}

class CheckForSavedCredentialsEvent extends LoginEvent {}