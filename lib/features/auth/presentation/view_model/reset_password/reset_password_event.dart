import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
  @override
  List<Object> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String token;
  final String password;
  const ResetPasswordSubmitted({required this.token, required this.password});
}