import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'shipping_address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final ShippingAddressEntity shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryStatus;
  final double deliveryFee;
  final double totalAmount;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.deliveryFee,
    required this.totalAmount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, deliveryStatus, totalAmount, createdAt];
}