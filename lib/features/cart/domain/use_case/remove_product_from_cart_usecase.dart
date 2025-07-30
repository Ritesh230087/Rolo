import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';

class RemoveProductFromCartUsecase implements UsecaseWithParams<Unit, String> {
  final ICartRepository _repository;

  RemoveProductFromCartUsecase(this._repository);
  @override
  Future<Either<Failure, Unit>> call(String cartItemId) async {
    return await _repository.removeProductFromCart(cartItemId);
  }
}