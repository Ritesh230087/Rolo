import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';

class ClearCartUseCase implements UsecaseWithoutParams<Unit> {
  final ICartRepository _repository;

  ClearCartUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call() async {
    return await _repository.clearCart();
  }
}