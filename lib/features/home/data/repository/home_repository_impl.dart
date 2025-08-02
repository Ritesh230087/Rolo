// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/features/home/data/data_source/local_datasource/home_local_data_source.dart';
// import 'package:rolo/features/home/data/data_source/remote_data_source/home_remote_data_source.dart';
// import 'package:rolo/features/home/domain/entity/home_entity.dart';
// import 'package:rolo/features/home/domain/repository/home_repository.dart';

// class HomeRepositoryImpl implements IHomeRepository {
//   final IHomeRemoteDataSource _remoteDataSource;
//   final IHomeLocalDataSource _localDataSource;
//   final Connectivity _connectivity;

//   HomeRepositoryImpl(
//       this._remoteDataSource, this._localDataSource, this._connectivity);

//   @override
//   Future<Either<Failure, HomeEntity>> getHomeData() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       try {
//         final homeData = await _remoteDataSource.getHomeData();
//         await _localDataSource.cacheHomeData(homeData);
//         return Right(homeData);
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       try {
//         final localHomeData = await _localDataSource.getHomeData();
//         if (localHomeData != null) {
//           return Right(localHomeData);
//         } else {
//           return Left(CacheFailure(message: "You are offline. Please connect to the internet to load data for the first time."));
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
import 'package:rolo/features/home/data/data_source/local_datasource/home_local_data_source.dart';
import 'package:rolo/features/home/data/data_source/remote_data_source/home_remote_data_source.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource _remoteDataSource;
  final IHomeLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  HomeRepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._connectivity);

  @override
  Future<Either<Failure, HomeEntity>> getHomeData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // Check if the list of results contains 'none'
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // --- USER IS OFFLINE ---
      try {
        final localHomeData = await _localDataSource.getHomeData();
        if (localHomeData != null) {
          // Return cached data if available
          return Right(localHomeData);
        } else {
          // If no cache, return a user-friendly message
          return Left(const CacheFailure(message: "You are offline. No cached data available."));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    } else {
      // --- USER IS ONLINE ---
      try {
        // Fetch fresh data from the server
        final homeData = await _remoteDataSource.getHomeData();
        // Cache the new data for future offline use
        await _localDataSource.cacheHomeData(homeData);
        return Right(homeData);
      } catch (e) {
        // If the server fails for any reason (e.g., 500 error),
        // try to fall back to the cached data as a last resort.
        try {
          final localHomeData = await _localDataSource.getHomeData();
          if (localHomeData != null) {
            return Right(localHomeData);
          } else {
            // If server fails and there's no cache, return the server error
            return Left(ServerFailure(message: e.toString()));
          }
        } catch (cacheError) {
          // If even the cache fails, return the original server error
          return Left(ServerFailure(message: e.toString()));
        }
      }
    }
  }
}