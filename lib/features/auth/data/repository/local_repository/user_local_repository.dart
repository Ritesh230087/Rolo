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
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerFCMToken(String token) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, String>> loginWithGoogle(String idToken) async {
    return Left(LocalDatabaseFailure(message: 'Google login is not available in offline mode.'));
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetLink(String email) async {
    return Left(LocalDatabaseFailure(message: 'Forgot Password is not available in offline mode.'));
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String password) async {
    return Left(LocalDatabaseFailure(message: 'Password Reset is not available in offline mode.'));
  }
}