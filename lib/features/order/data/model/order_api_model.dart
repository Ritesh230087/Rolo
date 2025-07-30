import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'shipping_address_api_model.dart';

part 'order_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderApiModel {
  @JsonKey(name: '_id')
  final String id;
  final List<Map<String, dynamic>> items; 
  final ShippingAddressApiModel shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryStatus;
  final double deliveryFee;
  final double totalAmount;
  final DateTime createdAt;
  
  OrderApiModel({
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

  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      items: [], 
      shippingAddress: shippingAddress.toEntity(),
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      deliveryStatus: deliveryStatus,
      deliveryFee: deliveryFee,
      totalAmount: totalAmount,
      createdAt: createdAt,
    );
  }

  factory OrderApiModel.fromEntityAndCart({
    required CartEntity cart,
    required ShippingAddressEntity shippingAddress,
    required String paymentMethod,
    required double deliveryFee,
  }) {
    final total = cart.subtotal + deliveryFee;
    return OrderApiModel(
      id: '', 
      items: cart.items.map((item) => {
        'productId': item.product.id,
        'name': item.product.name,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList(),
      shippingAddress: ShippingAddressApiModel.fromEntity(shippingAddress),
      paymentMethod: paymentMethod,
      deliveryFee: deliveryFee,
      totalAmount: total,
      paymentStatus: 'pending', 
      deliveryStatus: 'pending',
      createdAt: DateTime.now(),
    );
  }
  Map<String, dynamic> toJsonForCreation(String userId) {
  return {
    'userId': userId, 
    'items': items,
    'shippingAddress': shippingAddress.toJson(),
    'paymentMethod': paymentMethod,
    'deliveryFee': deliveryFee,
    'totalAmount': totalAmount,
    'deliveryType': 'domestic',
  };
}
}