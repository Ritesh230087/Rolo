// import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
// import 'package:rolo/features/cart/domain/entity/cart_item_entity.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';
// import 'package:uuid/uuid.dart';

// abstract class ICartDataSource {
//   Future<CartEntity> getCart();
//   Future<void> addProductToCart(ProductEntity product, {int quantity = 1});
//   Future<void> removeProductFromCart(String cartItemId);
//   Future<void> updateItemQuantity(String cartItemId, int newQuantity);
// }

// class CartLocalDataSource implements ICartDataSource {
//   final List<CartItemEntity> _items = [];
//   final Uuid _uuid = const Uuid();

//   @override
//   Future<void> addProductToCart(ProductEntity product, {int quantity = 1}) async {
//   final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

//   if (existingIndex != -1) {
//     final existingItem = _items[existingIndex];
//     _items[existingIndex] = existingItem.copyWith(
//       quantity: existingItem.quantity + quantity, 
//     );
//   } else {
//     _items.add(
//       CartItemEntity(
//         id: _uuid.v4(), 
//         product: product,
//         quantity: quantity, 
//       ),
//     );
//   }
// }


//   @override
//   Future<CartEntity> getCart() async {
//     final double subtotal = _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
//     final double shipping = subtotal > 0 ? 9.99 : 0; 
//     final double total = subtotal + shipping;

//     return CartEntity(
//       items: List.from(_items),
//       subtotal: subtotal,
//       shipping: shipping,
//       total: total,
//     );
//   }

//   @override
//   Future<void> removeProductFromCart(String cartItemId) async {
//     _items.removeWhere((item) => item.id == cartItemId);
//   }

//   @override
//   Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
//     final index = _items.indexWhere((item) => item.id == cartItemId);

//     if (index != -1) {
//       if (newQuantity > 0) {
//         final item = _items[index];
//         _items[index] = item.copyWith(quantity: newQuantity);
//       } else {
//         _items.removeAt(index);
//       }
//     }
//   }
// }

































import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:uuid/uuid.dart';

abstract class ICartDataSource {
  Future<CartEntity> getCart();
  Future<void> addProductToCart(ProductEntity product, {int quantity = 1});
  Future<void> removeProductFromCart(String cartItemId);
  Future<void> updateItemQuantity(String cartItemId, int newQuantity);
  // FIX: Add the new clearCart method to the interface.
  Future<void> clearCart();
}

class CartLocalDataSource implements ICartDataSource {
  final List<CartItemEntity> _items = [];
  final Uuid _uuid = const Uuid();

  @override
  Future<void> addProductToCart(ProductEntity product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity, 
      );
    } else {
      _items.add(
        CartItemEntity(
          id: _uuid.v4(), 
          product: product,
          quantity: quantity, 
        ),
      );
    }
  }


  @override
  Future<CartEntity> getCart() async {
    final double subtotal = _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    final double shipping = subtotal > 0 ? 9.99 : 0; 
    final double total = subtotal + shipping;

    return CartEntity(
      items: List.from(_items),
      subtotal: subtotal,
      shipping: shipping,
      total: total,
    );
  }

  @override
  Future<void> removeProductFromCart(String cartItemId) async {
    _items.removeWhere((item) => item.id == cartItemId);
  }

  @override
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    final index = _items.indexWhere((item) => item.id == cartItemId);

    if (index != -1) {
      if (newQuantity > 0) {
        final item = _items[index];
        _items[index] = item.copyWith(quantity: newQuantity);
      } else {
        _items.removeAt(index);
      }
    }
  }

  // FIX: Implement the clearCart method by clearing the in-memory list.
  @override
  Future<void> clearCart() async {
    _items.clear();
  }
}