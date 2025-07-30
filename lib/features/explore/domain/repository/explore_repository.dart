import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

abstract class IExploreRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}