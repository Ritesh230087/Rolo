import 'package:equatable/equatable.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaymentMethods extends PaymentEvent {
  final String district;
  const LoadPaymentMethods(this.district);
  
  @override
  List<Object?> get props => [district];
}

class PaymentMethodSelected extends PaymentEvent {
  final String methodId;
  const PaymentMethodSelected(this.methodId);
  
  @override
  List<Object?> get props => [methodId];
}

class ProceedToPayment extends PaymentEvent {}

class EsewaPaymentSucceeded extends PaymentEvent {
  final EsewaPaymentSuccessResult result;
  
  const EsewaPaymentSucceeded(this.result);
  
  @override
  List<Object?> get props => [result];
}

class EsewaPaymentFailed extends PaymentEvent {
  final String errorMessage;
  
  const EsewaPaymentFailed(this.errorMessage);
  
  @override
  List<Object?> get props => [errorMessage];
}