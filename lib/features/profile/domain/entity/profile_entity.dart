import 'package:equatable/equatable.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart'; 

class ProfileEntity extends Equatable {
  final UserEntity user;
  final List<OrderEntity> orders;
  final ShippingAddressEntity? lastShippingAddress;

  const ProfileEntity({
    required this.user,
    required this.orders,
    this.lastShippingAddress,
  });

  @override
  List<Object?> get props => [user, orders, lastShippingAddress];
}