import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class GetShippingLocationsUseCase implements UsecaseWithoutParams<List<DeliveryLocationEntity>> {
  final OrderRepository repository;

  GetShippingLocationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DeliveryLocationEntity>>> call() async {
    return await repository.getShippingLocations();
  }
}