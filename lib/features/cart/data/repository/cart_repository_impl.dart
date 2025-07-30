import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/data/data_source/local_datasource/cart_local_data_source.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> addProductToCart(ProductEntity product, {int quantity = 1}) async {
    try {
      await _localDataSource.addProductToCart(product, quantity: quantity);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await _localDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeProductFromCart(String cartItemId) async {
    try {
      await _localDataSource.removeProductFromCart(cartItemId);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemQuantity(String cartItemId, int newQuantity) async {
    try {
      await _localDataSource.updateItemQuantity(cartItemId, newQuantity);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}


























