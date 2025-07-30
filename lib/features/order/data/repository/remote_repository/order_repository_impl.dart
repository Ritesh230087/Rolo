import 'dart:io'; 
import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/data/data_source/remote_data_source/order_remote_data_source.dart';
import 'package:rolo/features/order/data/model/order_api_model.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required CartEntity cart,
    required ShippingAddressEntity shippingAddress,
    required String paymentMethod,
    required double deliveryFee,
    required String userId,
  }) async {
    try {
      final orderToCreate = OrderApiModel.fromEntityAndCart(
        cart: cart,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        deliveryFee: deliveryFee,
      );
      final createdOrderModel = await remoteDataSource.createOrder(orderToCreate.toJsonForCreation(userId));
      return right(createdOrderModel.toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrderWithSlip({
    required CartEntity cart,
    required ShippingAddressEntity shippingAddress,
    required double deliveryFee,
    required String userId,
    required File slipImage,
  }) async {
    try {
      final orderToCreate = OrderApiModel.fromEntityAndCart(
        cart: cart,
        shippingAddress: shippingAddress,
        paymentMethod: 'bank', 
        deliveryFee: deliveryFee,
      );
      final orderData = orderToCreate.toJsonForCreation(userId);
      final createdOrderModel = await remoteDataSource.createOrderWithSlip(orderData, slipImage);
      return right(createdOrderModel.toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

   @override
  Future<Either<Failure, ShippingAddressEntity>> getLastShippingAddress() async {
    try {
      final addressModel = await remoteDataSource.getLastShippingAddress();
      return right(addressModel.toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(String userId) async { 
    try {
      final orderApiModels = await remoteDataSource.getOrderHistory(userId); 
      final orderEntities = orderApiModels.map((model) => model.toEntity()).toList();
      return right(orderEntities);
    } on Exception catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DeliveryLocationEntity>>> getShippingLocations() async {
    try {
      final locationModels = await remoteDataSource.getShippingLocations();
      final locationEntities = locationModels.map((model) => model.toEntity()).toList();
      return right(locationEntities);
    } on Exception catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
  
}