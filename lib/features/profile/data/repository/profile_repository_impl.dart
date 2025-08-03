// import 'package:dartz/dartz.dart';
// import 'package:rolo/app/shared_pref/token_shared_pref.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/features/auth/domain/entity/user_entity.dart';
// import 'package:rolo/features/order/data/model/shipping_address_api_model.dart';
// import 'package:rolo/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
// import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
// import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

// class ProfileRepositoryImpl implements IProfileRepository {
//   final IProfileRemoteDataSource _remoteDataSource;
//   final TokenSharedPrefs _tokenSharedPrefs;

//   ProfileRepositoryImpl({
//     required IProfileRemoteDataSource remoteDataSource,
//     required TokenSharedPrefs tokenSharedPrefs,
//   })  : _remoteDataSource = remoteDataSource,
//         _tokenSharedPrefs = tokenSharedPrefs;

//   @override
//   Future<Either<Failure, ProfileEntity>> getUserProfile() async {
//     try {
//       final results = await Future.wait([
//         _remoteDataSource.getUserProfile(),
//         _remoteDataSource.getLastShippingAddress(),
//       ]);

//       final profileResponse = results[0] as ProfileApiResponse;
//       final lastAddressModel = results[1] as ShippingAddressApiModel?;

//       final profileEntity = ProfileEntity(
//         user: profileResponse.user.toEntity(),
//         orders: profileResponse.orders.map((o) => o.toEntity()).toList(),
//         lastShippingAddress: lastAddressModel?.toEntity(),
//       );
//       return Right(profileEntity);
//     } catch (e) {
//       return Left(RemoteDatabaseFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> logout() async {
//     try {
//       await _tokenSharedPrefs.deleteToken();
//       return const Right(unit);
//     } catch (e) {
//       return Left(SharedPreferencesFailure(message: 'Failed to log out: $e'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserEntity>> updateUserProfile({
//     required String firstName,
//     required String lastName,
//   }) async {
//     try {
//       final userProfileModel = await _remoteDataSource.updateUserProfile(
//         firstName: firstName,
//         lastName: lastName,
//       );
//       return Right(userProfileModel.toEntity());
//     } catch (e) {
//       return Left(RemoteDatabaseFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> changePassword({
//     required String oldPassword,
//     required String newPassword,
//   }) async {
//     try {
//       await _remoteDataSource.changePassword(
//         currentPassword: oldPassword,
//         newPassword: newPassword,
//       );
//       return const Right(unit);
//     } catch (e) {
//       return Left(RemoteDatabaseFailure(message: e.toString()));
//     }
//   }
// }




















import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:rolo/app/shared_pref/token_shared_pref.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/profile/data/data_source/local_datasource/profile_local_data_source.dart';
import 'package:rolo/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final IProfileLocalDataSource _localDataSource;
  final TokenSharedPrefs _tokenSharedPrefs;
  final Connectivity _connectivity;

  ProfileRepositoryImpl({
    required IProfileRemoteDataSource remoteDataSource,
    required IProfileLocalDataSource localDataSource,
    required TokenSharedPrefs tokenSharedPrefs,
    required Connectivity connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _tokenSharedPrefs = tokenSharedPrefs,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // --- USER IS OFFLINE ---
      try {
        final localProfile = await _localDataSource.getProfileData();
        if (localProfile != null) {
          // The localProfile will have user data but empty orders/null address, as per the Hive model.
          return Right(localProfile);
        } else {
          // If no user data is cached, inform the user.
          return Left(const CacheFailure(message: "You are offline. No profile data has been cached."));
        }
      } catch (e) {
        return Left(CacheFailure(message: "Failed to read cached profile: ${e.toString()}"));
      }
    } else {
      // --- USER IS ONLINE ---
      try {
        // Fetch fresh data from the network
        final profileApiResponse = await _remoteDataSource.getUserProfile();
        final lastAddressModel = await _remoteDataSource.getLastShippingAddress();
        
        final profileEntity = ProfileEntity(
          user: profileApiResponse.user.toEntity(),
          orders: profileApiResponse.orders.map((o) => o.toEntity()).toList(),
          lastShippingAddress: lastAddressModel?.toEntity(),
        );

        // Cache the fetched user data for future offline use.
        // The ProfileHiveModel will correctly only save the user part.
        await _localDataSource.cacheProfileData(profileEntity);
        
        return Right(profileEntity);
      } catch (e) {
        // If the server fails, try to fall back to the cached user data.
        try {
           final localProfile = await _localDataSource.getProfileData();
           if (localProfile != null) {
             return Right(localProfile);
           }
        } catch (_) {
          // Ignore any errors from the cache during fallback.
        }
        // If server fails and there's no cache, return the server error.
        return Left(RemoteDatabaseFailure(message: "Failed to fetch user profile data."));
      }
    }
  }
  
  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _tokenSharedPrefs.deleteToken();
      // Optionally, you could also clear the profile cache on logout
      // final box = await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileCacheBox);
      // await box.clear();
      return const Right(unit);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to log out: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return Left(const CacheFailure(message: "You are offline. Cannot update profile."));
    }
    try {
      final userProfileModel = await _remoteDataSource.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
      );
      return Right(userProfileModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return Left(const CacheFailure(message: "You are offline. Cannot change password."));
    }
    try {
      await _remoteDataSource.changePassword(
        currentPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}