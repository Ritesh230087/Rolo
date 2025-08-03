import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/repository/home_repository.dart';

class GetHomeDataUsecase implements UsecaseWithoutParams<HomeEntity> {
  final IHomeRepository _repository;

  GetHomeDataUsecase(this._repository);
  @override
  Future<Either<Failure, HomeEntity>> call() async {
    return await _repository.getHomeData();
  }
}