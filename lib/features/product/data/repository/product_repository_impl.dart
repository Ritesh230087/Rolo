import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/product/data/data_source/local_datasource/product_local_data_source.dart';
import 'package:rolo/features/product/data/data_source/remote_data_source/product_remote_datasource.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final IProductLocalDataSource localDataSource;
  final Connectivity connectivity;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String productId) async {
    final connectivityResult = await connectivity.checkConnectivity();
    
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final productApiModel = await remoteDataSource.getProductById(productId);
        final productEntity = productApiModel.toEntity();
        await localDataSource.cacheProduct(productEntity);
        return Right(productEntity);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localProduct = await localDataSource.getProductById(productId);
        if (localProduct != null) {
          return Right(localProduct);
        } else {
          return Left(CacheFailure(message: "You are offline and this item is not cached."));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
}