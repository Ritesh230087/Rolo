import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';

enum OrderStatus { initial, loading, success, error, proceedingToPayment, readyForPayment }

class OrderState extends Equatable {
  final OrderStatus status;
  final ShippingAddressEntity shippingAddress;
  final List<DeliveryLocationEntity> allLocations;
  final List<String> availableDistricts;
  final List<String> availableCities;
  final double shippingFee;
  final String? errorMessage;
  final OrderEntity? createdOrder;
  final String? userId;

  const OrderState({
    this.status = OrderStatus.initial,
    required this.shippingAddress,
    this.allLocations = const [],
    this.availableDistricts = const [],
    this.availableCities = const [],
    this.shippingFee = 0.0,
    this.errorMessage,
    this.createdOrder,
    this.userId, 
  });

  factory OrderState.initial() {
    return const OrderState(
      shippingAddress: ShippingAddressEntity(
        firstName: '', lastName: '', email: '', phone: '',
        address: '', city: '', district: '', country: 'Nepal',
      ),
    );
  }

  OrderState copyWith({
    OrderStatus? status,
    ShippingAddressEntity? shippingAddress,
    List<DeliveryLocationEntity>? allLocations,
    List<String>? availableDistricts,
    List<String>? availableCities,
    double? shippingFee,
    ValueGetter<String?>? errorMessage,
    ValueGetter<OrderEntity?>? createdOrder,
    String? userId, // ADDED
  }) {
    return OrderState(
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      allLocations: allLocations ?? this.allLocations,
      availableDistricts: availableDistricts ?? this.availableDistricts,
      availableCities: availableCities ?? this.availableCities,
      shippingFee: shippingFee ?? this.shippingFee,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      createdOrder: createdOrder != null ? createdOrder() : this.createdOrder,
      userId: userId ?? this.userId, 
    );
  }

  @override
  List<Object?> get props => [
    status, shippingAddress, allLocations, availableDistricts,
    availableCities, shippingFee, errorMessage, createdOrder, userId 
  ];
}