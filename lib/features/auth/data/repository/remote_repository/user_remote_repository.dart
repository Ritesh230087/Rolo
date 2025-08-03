import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

  @override
  Future<Either<Failure, void>> registerFCMToken(String token) async {
    try {
      await _userRemoteDataSource.registerFCMToken(token);
      return const Right(null); 
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginWithGoogle(String idToken) async {
    try {
      final token = await _userRemoteDataSource.loginWithGoogle(idToken);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
   @override
  Future<Either<Failure, void>> sendPasswordResetLink(String email) async {
    try {
      await _userRemoteDataSource.sendPasswordResetLink(email);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(RemoteDatabaseFailure(message: e.response?.data['message'] ?? 'Failed to send reset link.'));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String password) async {
    try {
      await _userRemoteDataSource.resetPassword(token, password);
      return const Right(unit);
    } on DioException catch (e) {
       return Left(RemoteDatabaseFailure(message: e.response?.data['message'] ?? 'Failed to reset password.'));
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}