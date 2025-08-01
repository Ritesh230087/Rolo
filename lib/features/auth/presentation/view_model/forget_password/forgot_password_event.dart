import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

class SendResetLink extends ForgotPasswordEvent {
  final String email;
  const SendResetLink(this.email);
}