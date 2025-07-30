import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class CreateOrderWithSlipUseCase implements UsecaseWithParams<OrderEntity, CreateOrderWithSlipParams> {
  final OrderRepository repository;

  CreateOrderWithSlipUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderWithSlipParams params) async {
    return await repository.createOrderWithSlip(
      cart: params.cart,
      shippingAddress: params.shippingAddress,
      deliveryFee: params.deliveryFee,
      userId: params.userId,
      slipImage: params.slipImage,
    );
  }
}

class CreateOrderWithSlipParams extends Equatable {
  final CartEntity cart;
  final ShippingAddressEntity shippingAddress;
  final double deliveryFee;
  final String userId;
  final File slipImage;

  const CreateOrderWithSlipParams({
    required this.cart,
    required this.shippingAddress,
    required this.deliveryFee,
    required this.userId,
    required this.slipImage,
  });

  @override
  List<Object?> get props => [cart, shippingAddress, deliveryFee, userId, slipImage];
}