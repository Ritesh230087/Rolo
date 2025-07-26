import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository({
    required UserRemoteDataSource userRemoteDataSource,
  }) : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async {
    try {
      final token = await _userRemoteDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  // --- ADD THIS FULL FUNCTION ---
  // This implements the new function required by the IUserRepository interface.
  // Its job is to call the remote data source to send the FCM token.
  @override
  Future<Either<Failure, void>> registerFCMToken(String token) async {
    try {
      await _userRemoteDataSource.registerFCMToken(token);
      return const Right(null); // Return Right(null) for a successful void Future
    } catch (e) {
      // We return a failure, but our ViewModel can choose to ignore it
      // so it doesn't interrupt the user's login flow.
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  // ---------------------------
}