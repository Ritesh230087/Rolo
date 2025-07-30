import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart'; 
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class GetOrderHistoryUseCase implements UsecaseWithParams<List<OrderEntity>, String> {
  final OrderRepository orderRepository;
  GetOrderHistoryUseCase(this.orderRepository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String params) async {
    return await orderRepository.getOrderHistory(params);
  }
}