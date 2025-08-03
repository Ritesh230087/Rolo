import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileUseCase implements UsecaseWithParams<UserEntity, UpdateProfileParams> {
  final IProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateUserProfile(
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;

  const UpdateProfileParams({required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];
}