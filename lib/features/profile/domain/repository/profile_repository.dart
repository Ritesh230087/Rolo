import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getUserProfile();
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
