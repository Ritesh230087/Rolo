// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/features/product/data/data_source/local_datasource/product_local_data_source.dart';
// import 'package:rolo/features/product/data/data_source/remote_data_source/product_remote_datasource.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';
// import 'package:rolo/features/product/domain/repository/product_repository.dart';

// class ProductRepositoryImpl implements ProductRepository {
//   final ProductRemoteDataSource remoteDataSource;
//   final IProductLocalDataSource localDataSource;
//   final Connectivity connectivity;

//   ProductRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.connectivity,
//   });

//   @override
//   Future<Either<Failure, ProductEntity>> getProductById(String productId) async {
//     final connectivityResult = await connectivity.checkConnectivity();
    
//     if (connectivityResult != ConnectivityResult.none) {
//       try {
//         final productApiModel = await remoteDataSource.getProductById(productId);
//         final productEntity = productApiModel.toEntity();
//         await localDataSource.cacheProduct(productEntity);
//         return Right(productEntity);
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       try {
//         final localProduct = await localDataSource.getProductById(productId);
//         if (localProduct != null) {
//           return Right(localProduct);
//         } else {
//           return Left(CacheFailure(message: "You are offline and this item is not cached."));
//         }
//       } catch (e) {
//         return Left(CacheFailure(message: e.toString()));
//       }
//     }
//   }
// }





















import 'dart:async';
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
  Stream<Either<Failure, ProductEntity>> getProductById(String productId) {
    final controller = StreamController<Either<Failure, ProductEntity>>();

    // This function will handle the logic
    _syncProductData(productId, controller);

    return controller.stream;
  }

  void _syncProductData(
      String productId, StreamController<Either<Failure, ProductEntity>> controller) async {
    // 1. Immediately emit cached data if it exists.
    final cachedProduct = await localDataSource.getProductById(productId);
    if (cachedProduct != null) {
      controller.add(Right(cachedProduct));
    }

    // 2. Check for an internet connection.
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // 3. If offline and no cache exists, emit an error.
      if (cachedProduct == null) {
        controller.add(Left(CacheFailure(message: "You are offline and this product is not cached.")));
      }
      await controller.close();
      return;
    }

    // 4. If online, fetch fresh data from the network.
    try {
      final remoteProductModel = await remoteDataSource.getProductById(productId);
      final remoteProductEntity = remoteProductModel.toEntity();
      
      // 5. Cache the fresh data in Hive.
      await localDataSource.cacheProduct(remoteProductEntity);
      
      // 6. Emit the fresh data to the UI.
      controller.add(Right(remoteProductEntity));
    } catch (e) {
      // 7. If network fails but we had cache, the user won't notice.
      //    If we had no cache, emit the server failure.
      if (cachedProduct == null) {
        controller.add(Left(ServerFailure(message: e.toString())));
      }
    } finally {
      await controller.close();
    }
  }
}