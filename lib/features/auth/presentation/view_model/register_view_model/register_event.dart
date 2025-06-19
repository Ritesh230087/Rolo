import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fName;
  final String lName;
  final String email;
  final String password;

  RegisterUserEvent({
    required this.context,
    required this.fName,
    required this.lName,
    required this.email,
    required this.password,
  });
}
