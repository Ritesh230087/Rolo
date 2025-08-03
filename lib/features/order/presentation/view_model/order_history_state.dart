import 'package:equatable/equatable.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderEntity> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}