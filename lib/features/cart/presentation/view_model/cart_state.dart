import 'package:equatable/equatable.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity cart;
  final String errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    required this.cart,
    this.errorMessage = '',
  });

  factory CartState.initial() {
    return CartState(cart: CartEntity.empty());
  }

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}