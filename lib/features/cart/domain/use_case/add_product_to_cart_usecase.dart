import 'package:rolo/features/cart/domain/repository/cart_repository.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class AddProductToCartUsecase {
  final ICartRepository _repository;

  AddProductToCartUsecase(this._repository);

  Future<void> call(ProductEntity product, {int quantity = 1}) {
    return _repository.addProductToCart(product, quantity: quantity);
  }
}
