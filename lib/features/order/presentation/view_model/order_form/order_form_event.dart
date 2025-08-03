import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

final class OrderLoadInitialData extends OrderEvent {}

final class OrderFormFieldChanged extends OrderEvent {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? postalCode;
  final String? notes;

  const OrderFormFieldChanged({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.postalCode,
    this.notes,
  });
}

final class OrderDistrictSelected extends OrderEvent {
  final String district;
  const OrderDistrictSelected(this.district);
}

final class OrderCitySelected extends OrderEvent {
  final String city;
  const OrderCitySelected(this.city);
}
final class ProceedToPayment extends OrderEvent {}