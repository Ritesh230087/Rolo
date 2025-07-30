import 'package:flutter/material.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';

@immutable
sealed class ProductDetailEvent {}

final class ProductDetailFetchData extends ProductDetailEvent {
  final String productId;
  ProductDetailFetchData(this.productId);
}

final class ProductDetailQuantityChanged extends ProductDetailEvent {
  final int newQuantity;
  ProductDetailQuantityChanged(this.newQuantity);
}

final class ProductDetailFavoriteToggled extends ProductDetailEvent {}

final class ProductDetailAddToCart extends ProductDetailEvent {}

final class ProductDetailBuyNow extends ProductDetailEvent {}

final class ProductDetailImageChanged extends ProductDetailEvent {
  final int newImageIndex;
  ProductDetailImageChanged(this.newImageIndex);
}

final class ProductDetailUpdateAvailableQuantity extends ProductDetailEvent {
  final int quantityAdded;
  ProductDetailUpdateAvailableQuantity(this.quantityAdded);
}

final class ProductDetailSyncWithCart extends ProductDetailEvent {
  final CartState cartState;
  ProductDetailSyncWithCart(this.cartState);
}