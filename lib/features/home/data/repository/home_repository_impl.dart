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
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final homeData = await _remoteDataSource.getHomeData();
        await _localDataSource.cacheHomeData(homeData);
        return Right(homeData);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localHomeData = await _localDataSource.getHomeData();
        if (localHomeData != null) {
          return Right(localHomeData);
        } else {
          return Left(CacheFailure(message: "You are offline. Please connect to the internet to load data for the first time."));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
}