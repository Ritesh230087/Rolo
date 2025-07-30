import 'package:equatable/equatable.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final ProductEntity product;
  final int quantity; 

  const AddItemToCart(this.product, {this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveItemFromCart extends CartEvent {
  final String cartItemId;
  const RemoveItemFromCart(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}

class UpdateItemQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;
  const UpdateItemQuantity(this.cartItemId, this.newQuantity);
  @override
  List<Object> get props => [cartItemId, newQuantity];
}