import 'package:equatable/equatable.dart';
import 'package:rolo/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final double subtotal;
  final double shipping;
  final double total;

  const CartEntity({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  factory CartEntity.empty() {
    return const CartEntity(items: [], subtotal: 0, shipping: 0, total: 0);
  }

  @override
  List<Object?> get props => [items, subtotal, shipping, total];
}
