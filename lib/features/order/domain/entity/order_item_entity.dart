import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, name, imageUrl, quantity, price];
}
