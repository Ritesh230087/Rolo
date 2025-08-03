import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/use_case/create_order_with_slip_usecase.dart';
import 'bank_transfer_event.dart';
import 'bank_transfer_state.dart';

class BankTransferViewModel extends Bloc<BankTransferEvent, BankTransferState> {
  final CreateOrderWithSlipUseCase _createOrderWithSlipUseCase;
  final CartEntity cart;
  final ShippingAddressEntity shippingAddress;
  final double deliveryFee;
  final String userId;
  final ImagePicker _picker = ImagePicker();

  BankTransferViewModel({
    required CreateOrderWithSlipUseCase createOrderWithSlipUseCase,
    required this.cart,
    required this.shippingAddress,
    required this.deliveryFee,
    required this.userId,
  }) : _createOrderWithSlipUseCase = createOrderWithSlipUseCase,
       super(const BankTransferState()) {
    on<PickImage>(_onPickImage);
    on<SubmitReceipt>(_onSubmitReceipt);
  }

  Future<void> _onPickImage(PickImage event, Emitter<BankTransferState> emit) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        emit(state.copyWith(
          pickedImage: File(image.path),
          status: BankTransferStatus.imagePicked,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: BankTransferStatus.error, error: "Failed to pick image. Please check permissions."));
    }
  }

  Future<void> _onSubmitReceipt(SubmitReceipt event, Emitter<BankTransferState> emit) async {
    if (state.pickedImage == null) {
      emit(state.copyWith(status: BankTransferStatus.error, error: "Please upload a receipt before submitting."));
      return;
    }
    
    emit(state.copyWith(status: BankTransferStatus.loading));

    final params = CreateOrderWithSlipParams(
      cart: cart,
      shippingAddress: shippingAddress,
      deliveryFee: deliveryFee,
      userId: userId,
      slipImage: state.pickedImage!,
    );
    
    final result = await _createOrderWithSlipUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: BankTransferStatus.error, error: failure.message)),
      (order) => emit(state.copyWith(
        status: BankTransferStatus.success,
        createdOrder: order,
      )),
    );
  }
}