import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class GetLastShippingAddressUseCase implements UsecaseWithoutParams<ShippingAddressEntity> {
  final OrderRepository repository;

  GetLastShippingAddressUseCase(this.repository);

  @override
  Future<Either<Failure, ShippingAddressEntity>> call() async {
    return await repository.getLastShippingAddress();
  }
}