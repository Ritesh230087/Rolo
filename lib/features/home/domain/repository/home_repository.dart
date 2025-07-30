import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';

abstract class IHomeRepository {
  Future<Either<Failure, HomeEntity>> getHomeData();
}