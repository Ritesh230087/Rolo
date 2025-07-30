import 'dart:io'; 
import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';

abstract interface class OrderRepository {
  Future<Either<Failure, List<DeliveryLocationEntity>>> getShippingLocations();

  Future<Either<Failure, ShippingAddressEntity>> getLastShippingAddress();

  Future<Either<Failure, OrderEntity>> createOrder({
    required CartEntity cart,
    required ShippingAddressEntity shippingAddress,
    required String paymentMethod,
    required double deliveryFee,
    required String userId,
  });

  Future<Either<Failure, OrderEntity>> createOrderWithSlip({
    required CartEntity cart,
    required ShippingAddressEntity shippingAddress,
    required double deliveryFee,
    required String userId,
    required File slipImage,
  });

  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(String userId);
}