import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  );
  Future<Either<Failure, void>> registerFCMToken(String token);
  Future<Either<Failure, String>> loginWithGoogle(String idToken);
  Future<Either<Failure, void>> sendPasswordResetLink(String email);
  Future<Either<Failure, void>> resetPassword(String token, String password);
}