import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart'; 

enum BankTransferStatus { initial, loading, success, error, imagePicked }

class BankTransferState extends Equatable {
  final BankTransferStatus status;
  final File? pickedImage;
  final String? error;
  final OrderEntity? createdOrder;

  const BankTransferState({
    this.status = BankTransferStatus.initial,
    this.pickedImage,
    this.error,
    this.createdOrder,
  });

  BankTransferState copyWith({
    BankTransferStatus? status,
    File? pickedImage,
    String? error,
    OrderEntity? createdOrder, 
  }) {
    return BankTransferState(
      status: status ?? this.status,
      pickedImage: pickedImage ?? this.pickedImage,
      error: error ?? this.error,
      createdOrder: createdOrder ?? this.createdOrder, 
    );
  }

  @override
  List<Object?> get props => [status, pickedImage, error, createdOrder]; 
}