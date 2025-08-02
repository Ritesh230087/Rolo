// import 'package:flutter/material.dart';
// import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';

// @immutable
// sealed class ProductDetailEvent {}

// final class ProductDetailFetchData extends ProductDetailEvent {
//   final String productId;
//   ProductDetailFetchData(this.productId);
// }

// final class ProductDetailQuantityChanged extends ProductDetailEvent {
//   final int newQuantity;
//   ProductDetailQuantityChanged(this.newQuantity);
// }

// final class ProductDetailFavoriteToggled extends ProductDetailEvent {}

// final class ProductDetailAddToCart extends ProductDetailEvent {}

// final class ProductDetailBuyNow extends ProductDetailEvent {}

// final class ProductDetailImageChanged extends ProductDetailEvent {
//   final int newImageIndex;
//   ProductDetailImageChanged(this.newImageIndex);
// }

// final class ProductDetailUpdateAvailableQuantity extends ProductDetailEvent {
//   final int quantityAdded;
//   ProductDetailUpdateAvailableQuantity(this.quantityAdded);
// }

// final class ProductDetailSyncWithCart extends ProductDetailEvent {
//   final CartState cartState;
//   ProductDetailSyncWithCart(this.cartState);
// }













import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

@immutable
sealed class ProductDetailEvent {}

/// Dispatched by the UI to start loading data or to refresh it.
final class ProductDetailFetchData extends ProductDetailEvent {
  final String productId;
  ProductDetailFetchData(this.productId);
}

/// Internal event used by the ViewModel to process data
/// received from the repository's stream.
final class ProductDetailDataReceived extends ProductDetailEvent {
  final Either<Failure, ProductEntity> result;
  ProductDetailDataReceived(this.result);
}

/// Dispatched by the UI when the user changes the quantity selector.
final class ProductDetailQuantityChanged extends ProductDetailEvent {
  final int newQuantity;
  ProductDetailQuantityChanged(this.newQuantity);
}

/// Dispatched by the UI when the user swipes the image gallery.
final class ProductDetailImageChanged extends ProductDetailEvent {
  final int newImageIndex;
  ProductDetailImageChanged(this.newImageIndex);
}

/// Dispatched internally to adjust available quantity after adding to cart.
final class ProductDetailUpdateAvailableQuantity extends ProductDetailEvent {
  final int quantityAdded;
  ProductDetailUpdateAvailableQuantity(this.quantityAdded);
}

/// Dispatched internally when the cart state changes to keep the UI in sync.
final class ProductDetailSyncWithCart extends ProductDetailEvent {
  final CartState cartState;
  ProductDetailSyncWithCart(this.cartState);
}