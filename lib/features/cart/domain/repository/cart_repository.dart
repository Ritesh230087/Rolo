import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

abstract class ICartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, Unit>> addProductToCart(ProductEntity product, {int quantity = 1});
  Future<Either<Failure, Unit>> removeProductFromCart(String cartItemId);
  Future<Either<Failure, Unit>> updateItemQuantity(String cartItemId, int newQuantity);
}