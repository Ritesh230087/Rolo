// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/features/category/domain/entity/category_entity.dart';
// import 'package:rolo/features/explore/data/data_source/local_datasource/explore_local_data_source.dart';
// import 'package:rolo/features/explore/data/data_source/remote_data_source/explore_remote_data_source.dart';
// import 'package:rolo/features/explore/domain/repository/explore_repository.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';
// import 'package:rolo/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';

// class ExploreRepositoryImpl implements IExploreRepository {
//   final IExploreRemoteDataSource _remoteDataSource;
//   final ICategoryRemoteDataSource _categoryRemoteDataSource;
//   final IExploreLocalDataSource _localDataSource;
//   final Connectivity _connectivity;

//   ExploreRepositoryImpl({
//     required IExploreRemoteDataSource remoteDataSource,
//     required ICategoryRemoteDataSource categoryRemoteDataSource,
//     required IExploreLocalDataSource localDataSource,
//     required Connectivity connectivity,
//   })  : _remoteDataSource = remoteDataSource,
//         _categoryRemoteDataSource = categoryRemoteDataSource,
//         _localDataSource = localDataSource,
//         _connectivity = connectivity;

//   @override
//   Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       try {
//         final productModels = await _remoteDataSource.getAllProducts();
//         final productEntities = productModels.map((model) => model.toEntity()).toList();
//         return Right(productEntities);
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       try {
//         final (localProducts, _) = await _localDataSource.getExploreData();
//         if (localProducts != null) {
//           return Right(localProducts);
//         } else {
//           return Left(CacheFailure(message: "You are offline. Products are not cached."));
//         }
//       } catch (e) {
//         return Left(CacheFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
//      final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//        try {
//         final categoryModels = await _categoryRemoteDataSource.getAllCategories();
//         final categoryEntities = categoryModels.map((model) => model.toEntity()).toList();
//         return Right(categoryEntities);
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       try {
//         final (_, localCategories) = await _localDataSource.getExploreData();
//         if (localCategories != null) {
//           return Right(localCategories);
//         } else {
//           return Left(CacheFailure(message: "You are offline. Categories are not cached."));
//         }
//       } catch (e) {
//         return Left(CacheFailure(message: e.toString()));
//       }
//     }
//   }
// }











































import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/category/data/model/category_api_model.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/explore/data/data_source/local_datasource/explore_local_data_source.dart';
import 'package:rolo/features/explore/data/data_source/remote_data_source/explore_remote_data_source.dart';
import 'package:rolo/features/explore/domain/repository/explore_repository.dart';
import 'package:rolo/features/product/data/model/product_api_model.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';

class ExploreRepositoryImpl implements IExploreRepository {
  final IExploreRemoteDataSource _remoteDataSource;
  final ICategoryRemoteDataSource _categoryRemoteDataSource;
  final IExploreLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  ExploreRepositoryImpl({
    required IExploreRemoteDataSource remoteDataSource,
    required ICategoryRemoteDataSource categoryRemoteDataSource,
    required IExploreLocalDataSource localDataSource,
    required Connectivity connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _categoryRemoteDataSource = categoryRemoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, (List<ProductEntity>, List<CategoryEntity>)>> getExploreData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        // Fetch fresh data from the network in parallel
        final results = await Future.wait([
          _remoteDataSource.getAllProducts(),
          _categoryRemoteDataSource.getAllCategories(),
        ]);

        // **THE FIX IS HERE**
        // We explicitly cast the results from 'List<dynamic>' to the specific types we expect.
        // This satisfies Dart's type safety and resolves the error.
        final productModels = results[0] as List<ProductApiModel>;
        final categoryModels = results[1] as List<CategoryApiModel>;

        final products = productModels.map((model) => model.toEntity()).toList();
        final categories = categoryModels.map((model) => model.toEntity()).toList();

        // Cache the fresh data for offline use
        await _localDataSource.cacheExploreData(products, categories);
        
        return Right((products, categories));
      } catch (e) {
        // If the server fails, try to fall back to the cache
        return _getLocalData(fallbackError: ServerFailure(message: e.toString()));
      }
    } 
    else {
      // User is offline
      return _getLocalData();
    }
  }
  
  Future<Either<Failure, (List<ProductEntity>, List<CategoryEntity>)>> _getLocalData({Failure? fallbackError}) async {
    try {
      final (localProducts, localCategories) = await _localDataSource.getExploreData();
      
      if (localProducts != null && localCategories != null) {
        return Right((localProducts, localCategories));
      } else {
        return Left(fallbackError ?? const CacheFailure(message: "You are offline. No data has been cached yet."));
      }
    } catch (e) {
      return Left(CacheFailure(message: "Could not read cached data: ${e.toString()}"));
    }
  }
}