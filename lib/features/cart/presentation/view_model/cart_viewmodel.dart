import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/cart/domain/use_case/add_product_to_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/remove_product_from_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/update_item_quantity_usecase.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';

class CartViewModel extends Bloc<CartEvent, CartState> {
  final GetCartUsecase _getCartUsecase;
  final AddProductToCartUsecase _addProductToCartUsecase;
  final RemoveProductFromCartUsecase _removeProductFromCartUsecase;
  final UpdateItemQuantityUsecase _updateItemQuantityUsecase;

  CartViewModel({
    required GetCartUsecase getCartUsecase,
    required AddProductToCartUsecase addProductToCartUsecase,
    required RemoveProductFromCartUsecase removeProductFromCartUsecase,
    required UpdateItemQuantityUsecase updateItemQuantityUsecase,
  })  : _getCartUsecase = getCartUsecase,
        _addProductToCartUsecase = addProductToCartUsecase,
        _removeProductFromCartUsecase = removeProductFromCartUsecase,
        _updateItemQuantityUsecase = updateItemQuantityUsecase,
        super(CartState.initial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCartUsecase();
    result.fold(
      (failure) => emit(state.copyWith(status: CartStatus.failure, errorMessage: failure.message)),
      (cart) => emit(state.copyWith(status: CartStatus.success, cart: cart)),
    );
  }

  Future<void> _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
  await _addProductToCartUsecase(event.product, quantity: event.quantity); 
  add(LoadCart());
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) async {
    await _removeProductFromCartUsecase(event.cartItemId);
    add(LoadCart());
  }

  Future<void> _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<CartState> emit) async {
  final cartItem = state.cart.items.firstWhere(
    (item) => item.id == event.cartItemId,
    orElse: () => throw Exception('Cart item not found'),
  );
  if (event.newQuantity > cartItem.product.quantity) {
    emit(state.copyWith(
      status: CartStatus.failure, 
      errorMessage: 'Cannot add more items. Only ${cartItem.product.quantity} items available.'
    ));
    return;
  }
  await _updateItemQuantityUsecase(
    UpdateQuantityParams(cartItemId: event.cartItemId, newQuantity: event.newQuantity),
  );
  add(LoadCart());
}
}