import 'package:equatable/equatable.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart'; 
import 'package:rolo/features/order/domain/entity/payment_method_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';

enum PaymentStatus { initial, loading, success, error, navigateToBankTransfer, processing }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final List<PaymentMethodEntity> methods;
  final String? selectedMethodId;
  final bool isCodAvailable;
  final String? error;
  final OrderEntity? createdOrder;

  final CartEntity cart;
  final ShippingAddressEntity shippingAddress;
  final double deliveryFee;
  final String userId;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.methods = const [],
    this.selectedMethodId,
    this.isCodAvailable = false,
    this.error,
    this.createdOrder, 
    required this.cart,
    required this.shippingAddress,
    required this.deliveryFee,
    required this.userId,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    List<PaymentMethodEntity>? methods,
    String? selectedMethodId,
    bool? isCodAvailable,
    String? error,
    OrderEntity? createdOrder, 
    bool clearError = false,
  }) {
    return PaymentState(
      status: status ?? this.status,
      methods: methods ?? this.methods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      isCodAvailable: isCodAvailable ?? this.isCodAvailable,
      error: clearError ? null : error ?? this.error,
      createdOrder: createdOrder ?? this.createdOrder, 
      cart: cart,
      shippingAddress: shippingAddress,
      deliveryFee: deliveryFee,
      userId: userId,
    );
  }

  @override
  List<Object?> get props => [
        status, methods, selectedMethodId, isCodAvailable, error, createdOrder, 
        cart, shippingAddress, deliveryFee, userId,
      ];
}