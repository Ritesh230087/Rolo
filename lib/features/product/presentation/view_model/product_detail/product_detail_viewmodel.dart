import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/product/domain/use_case/get_product_by_id.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_event.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_state.dart';

class ProductDetailViewModel extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductById _getProductById;
  final CartViewModel _cartViewModel; 
  late final StreamSubscription _cartSubscription;

  ProductDetailViewModel({
    required GetProductById getProductById,
    required CartViewModel cartViewModel,
  })  : _getProductById = getProductById,
        _cartViewModel = cartViewModel, 
        super(const ProductDetailState()) {
    on<ProductDetailFetchData>(_onFetchData);
    on<ProductDetailQuantityChanged>(_onQuantityChanged);
    on<ProductDetailFavoriteToggled>(_onFavoriteToggled);
    on<ProductDetailAddToCart>(_onAddToCart);
    on<ProductDetailBuyNow>(_onBuyNow);
    on<ProductDetailImageChanged>(_onImageChanged);
    on<ProductDetailUpdateAvailableQuantity>(_onUpdateAvailableQuantity);
    on<ProductDetailSyncWithCart>(_onSyncWithCart);

    _cartSubscription = _cartViewModel.stream.listen((cartState) {
      if (state.product != null && cartState.status == CartStatus.success) {
        add(ProductDetailSyncWithCart(cartState));
      }
    });
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetchData(
    ProductDetailFetchData event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await _getProductById(event.productId);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: failure.message,
      )),
      (product) {
        final remainingQuantity = _calculateRemainingQuantity(product);
        final updatedProduct = product.copyWith(quantity: remainingQuantity);
        
        emit(state.copyWith(
          status: ProductDetailStatus.success,
          product: updatedProduct,
          quantity: remainingQuantity > 0 ? 1 : 0,
        ));
      },
    );
  }

  void _onQuantityChanged(
    ProductDetailQuantityChanged event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state.product != null &&
        event.newQuantity >= 1 &&
        event.newQuantity <= state.product!.quantity) {
      emit(state.copyWith(quantity: event.newQuantity));
    }
  }
  
  void _onImageChanged(
    ProductDetailImageChanged event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(selectedImageIndex: event.newImageIndex));
  }

  void _onFavoriteToggled(
    ProductDetailFavoriteToggled event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onUpdateAvailableQuantity(
    ProductDetailUpdateAvailableQuantity event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state.product != null) {
      final updatedProduct = state.product!.copyWith(
        quantity: state.product!.quantity - event.quantityAdded,
      );
      emit(state.copyWith(product: updatedProduct, quantity: 1));
    }
  }

  void _onSyncWithCart(
    ProductDetailSyncWithCart event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state.product != null) {
      final remainingQuantity = _calculateRemainingQuantity(state.product!);
      final updatedProduct = state.product!.copyWith(quantity: remainingQuantity);
      
      final newQuantity = state.quantity > remainingQuantity ? 
          (remainingQuantity > 0 ? 1 : 0) : state.quantity;
      
      emit(state.copyWith(
        product: updatedProduct,
        quantity: newQuantity,
      ));
    }
  }

  int _calculateRemainingQuantity(ProductEntity product) {
    final cartState = _cartViewModel.state;
    if (cartState.status != CartStatus.success) {
      return product.quantity;
    }

    final cartItem = cartState.cart.items.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );

    if (cartItem != null) {
      return product.quantity - cartItem.quantity;
    }

    return product.quantity;
  }

  void _onAddToCart(
    ProductDetailAddToCart event,
    Emitter<ProductDetailState> emit,
  ) {
    print('Added ${state.quantity} of ${state.product?.name} to cart.');
  }

  void _onBuyNow(
    ProductDetailBuyNow event,
    Emitter<ProductDetailState> emit,
  ) {
    print('Buying ${state.quantity} of ${state.product?.name}.');
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}