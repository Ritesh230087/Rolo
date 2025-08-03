import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';

class GetCartUsecase implements UsecaseWithoutParams<CartEntity> {
  final ICartRepository _repository;
  GetCartUsecase(this._repository);

  @override
  Future<Either<Failure, CartEntity>> call() async {
    return await _repository.getCart();
  }
}