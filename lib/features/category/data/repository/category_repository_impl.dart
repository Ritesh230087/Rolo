import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryRemoteDataSource _remoteDataSource;
  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categoryModels = await _remoteDataSource.getAllCategories();
      final categoryEntities = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categoryEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}