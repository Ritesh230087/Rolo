import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';

abstract class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}