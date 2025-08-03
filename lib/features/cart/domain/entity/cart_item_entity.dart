import 'package:equatable/equatable.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class CartItemEntity extends Equatable {
  final String id; 
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity];
}