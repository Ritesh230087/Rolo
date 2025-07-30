import 'package:equatable/equatable.dart';

abstract class BankTransferEvent extends Equatable {
  const BankTransferEvent();
  @override
  List<Object> get props => [];
}

class PickImage extends BankTransferEvent {}

class SubmitReceipt extends BankTransferEvent {}