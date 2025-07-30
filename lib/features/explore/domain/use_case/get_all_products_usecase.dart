import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/explore/domain/repository/explore_repository.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class GetAllProductsUsecase implements UsecaseWithoutParams<List<ProductEntity>> {
  final IExploreRepository _repository;

  GetAllProductsUsecase(this._repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await _repository.getAllProducts();
  }
}