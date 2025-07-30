import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/explore/domain/repository/explore_repository.dart';

class GetAllCategoriesUsecase implements UsecaseWithoutParams<List<CategoryEntity>> {
  final IExploreRepository _repository;

  GetAllCategoriesUsecase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await _repository.getAllCategories();
  }
}