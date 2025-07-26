import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/data/data_source/local_datasource/user_local_data_source.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({
    required UserLocalDataSource userLocalDataSource,
  }) : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async {
    try {
      final result = await _userLocalDataSource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  // --- ADD THIS FULL FUNCTION TO FIX THE ERROR ---
  // The 'IUserRepository' interface requires this function.
  // Since the local repository doesn't handle online tokens,
  // we provide an implementation that successfully does nothing.
  @override
  Future<Either<Failure, void>> registerFCMToken(String token) async {
    // No action needed for local repository, so we return a success state.
    return const Right(null);
  }
  // ----------------------------------------------
}