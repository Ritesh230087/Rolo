import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  );

  // --- ADD THIS LINE ---
  // This is the contract for the repository layer.
  Future<Either<Failure, void>> registerFCMToken(String token);
  // -----------------------
}