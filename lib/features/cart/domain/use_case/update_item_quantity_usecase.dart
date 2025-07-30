import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';

class UpdateQuantityParams extends Equatable {
  final String cartItemId;
  final int newQuantity;

  const UpdateQuantityParams({required this.cartItemId, required this.newQuantity});

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}


class UpdateItemQuantityUsecase implements UsecaseWithParams<Unit, UpdateQuantityParams> {
  final ICartRepository _repository;

  UpdateItemQuantityUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateQuantityParams params) async {
    return await _repository.updateItemQuantity(params.cartItemId, params.newQuantity);
  }
}