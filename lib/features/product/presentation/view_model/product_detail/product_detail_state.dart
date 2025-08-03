// import 'package:equatable/equatable.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';

// enum ProductDetailStatus { initial, loading, success, error }

// class ProductDetailState extends Equatable {
//   final ProductDetailStatus status;
//   final ProductEntity? product;
//   final String? errorMessage;
//   final int quantity;
//   final bool isFavorite;
//   final int selectedImageIndex;

//   const ProductDetailState({
//     this.status = ProductDetailStatus.initial,
//     this.product,
//     this.errorMessage,
//     this.quantity = 1,
//     this.isFavorite = false,
//     this.selectedImageIndex = 0,
//   });
//   bool get isOutOfStock => product?.quantity == 0;
//   List<String> get allImages => product != null ? [product!.imageUrl, ...product!.extraImages] : [];
//   double get totalPrice => product != null ? product!.price * quantity : 0.0;
//   bool get canBuyNow => product != null && !isOutOfStock;
  

//   ProductDetailState copyWith({
//     ProductDetailStatus? status,
//     ProductEntity? product,
//     String? errorMessage,
//     int? quantity,
//     bool? isFavorite,
//     int? selectedImageIndex,
//   }) {
//     return ProductDetailState(
//       status: status ?? this.status,
//       product: product ?? this.product,
//       errorMessage: errorMessage ?? this.errorMessage,
//       quantity: quantity ?? this.quantity,
//       isFavorite: isFavorite ?? this.isFavorite,
//       selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
//     );
//   }
  
//   @override
//   List<Object?> get props => [status, product, errorMessage, quantity, isFavorite, selectedImageIndex];
// }































import 'package:equatable/equatable.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

enum ProductDetailStatus { initial, loading, success, error }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  // This is the product to be displayed in the UI, with quantity adjusted for what's in the cart.
  final ProductEntity? product;
  // This is the original product data from the repository, with the absolute total stock.
  final ProductEntity? originalProduct;
  final String? errorMessage;
  final int quantity;
  final bool isFavorite;
  final int selectedImageIndex;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.originalProduct,
    this.errorMessage,
    this.quantity = 1,
    this.isFavorite = false,
    this.selectedImageIndex = 0,
  });

  bool get isOutOfStock => product?.quantity == 0;
  List<String> get allImages => product != null ? [product!.imageUrl, ...product!.extraImages] : [];
  double get totalPrice => product != null ? product!.price * quantity : 0.0;
  bool get canBuyNow => product != null && !isOutOfStock;
  

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductEntity? product,
    ProductEntity? originalProduct,
    String? errorMessage,
    int? quantity,
    bool? isFavorite,
    int? selectedImageIndex,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      originalProduct: originalProduct ?? this.originalProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
  
  @override
  List<Object?> get props => [status, product, originalProduct, errorMessage, quantity, isFavorite, selectedImageIndex];
}