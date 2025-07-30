import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase implements UsecaseWithoutParams<ProfileEntity> {
  final IProfileRepository _repository;
  GetProfileUsecase(this._repository);

  @override
  Future<Either<Failure, ProfileEntity>> call() async {
    return await _repository.getUserProfile();
  }
}