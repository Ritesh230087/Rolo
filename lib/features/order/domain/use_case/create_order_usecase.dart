import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class CreateOrderUseCase implements UsecaseWithParams<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(
      cart: params.cart,
      shippingAddress: params.shippingAddress,
      paymentMethod: params.paymentMethod,
      deliveryFee: params.deliveryFee,
      userId: params.userId,
    );
  }
}

class CreateOrderParams extends Equatable {
  final CartEntity cart;
  final ShippingAddressEntity shippingAddress;
  final String paymentMethod;
  final double deliveryFee;
  final String userId;

  const CreateOrderParams({
    required this.cart,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.deliveryFee,
    required this.userId,
  });

  @override
  List<Object?> get props => [cart, shippingAddress, paymentMethod, deliveryFee, userId];
}