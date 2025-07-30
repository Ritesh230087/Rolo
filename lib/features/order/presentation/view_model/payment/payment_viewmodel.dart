import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/payment_method_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/use_case/check_cod_availability_usecase.dart';
import 'package:rolo/features/order/domain/use_case/create_order_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentViewModel extends Bloc<PaymentEvent, PaymentState> {
  final CheckCodAvailabilityUseCase _checkCod;
  final CreateOrderUseCase _createOrderUseCase;

  static const String ESEWA_CLIENT_ID = "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  static const String ESEWA_SECRET_KEY = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";

  PaymentViewModel({
    required CheckCodAvailabilityUseCase checkCod,
    required CreateOrderUseCase createOrderUseCase,
    required CartEntity cart,
    required ShippingAddressEntity address,
    required double deliveryFee,
    required String userId,
  })  : _checkCod = checkCod,
        _createOrderUseCase = createOrderUseCase,
        super(PaymentState(
          cart: cart,
          shippingAddress: address,
          deliveryFee: deliveryFee,
          userId: userId,
        )) {
    on<LoadPaymentMethods>(_onLoad);
    on<PaymentMethodSelected>(_onSelect);
    on<ProceedToPayment>(_onSubmit);
    on<EsewaPaymentSucceeded>(_onEsewaPaymentSucceeded);
    on<EsewaPaymentFailed>(_onEsewaPaymentFailed);
    
    // Add logging for debugging
    print('PaymentViewModel initialized with cart: ${cart.items.length} items, total: ${cart.subtotal + deliveryFee}');
  }

  void _onLoad(LoadPaymentMethods event, Emitter<PaymentState> emit) {
    final codAvailable = _checkCod(event.district);
    emit(state.copyWith(
      methods: const [
        PaymentMethodEntity(id: 'esewa', name: 'eSewa', icon: '💳', description: 'Pay via eSewa'),
        PaymentMethodEntity(id: 'bank', name: 'Bank Transfer', icon: '🏦', description: 'Transfer directly from your bank account.'),
        PaymentMethodEntity(id: 'cod', name: 'Cash on Delivery', icon: '💵', description: 'Pay when you receive your order.'),
      ],
      isCodAvailable: codAvailable,
      status: PaymentStatus.initial,
    ));
  }

  void _onSelect(PaymentMethodSelected event, Emitter<PaymentState> emit) {
    emit(state.copyWith(selectedMethodId: event.methodId));
  }

  Future<void> _onSubmit(ProceedToPayment event, Emitter<PaymentState> emit) async {
    if (state.selectedMethodId == null) {
      emit(state.copyWith(error: 'Please select a payment method', status: PaymentStatus.error));
      return;
    }

    if (state.selectedMethodId == 'bank') {
      emit(state.copyWith(status: PaymentStatus.navigateToBankTransfer));
      return;
    }

    if (state.selectedMethodId == 'esewa') {
      await _handleEsewaPayment(emit);
      return;
    }
    
    emit(state.copyWith(status: PaymentStatus.processing));

    try {
      final params = CreateOrderParams(
        cart: state.cart,
        shippingAddress: state.shippingAddress,
        paymentMethod: state.selectedMethodId!,
        deliveryFee: state.deliveryFee,
        userId: state.userId,
      );
      final result = await _createOrderUseCase(params);

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(state.copyWith(status: PaymentStatus.error, error: failure.message)),
          (order) => emit(state.copyWith(
            status: PaymentStatus.success,
            createdOrder: order,
          )),
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(state.copyWith(
          status: PaymentStatus.error,
          error: 'Order creation failed: ${e.toString()}',
        ));
      }
    }
  }
  Future<void> _handleEsewaPayment(Emitter<PaymentState> emit) async {
    if (!emit.isDone) {
      emit(state.copyWith(status: PaymentStatus.processing));
    }

    try {
      final total = state.cart.subtotal + state.deliveryFee;
      
      final productId = "rolo_order_${DateTime.now().millisecondsSinceEpoch}";
      
      await _initEsewaPayment(productId, total, emit);
      
    } catch (e) {
      if (!emit.isDone) {
        emit(state.copyWith(
          status: PaymentStatus.error,
          error: 'eSewa payment error: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _initEsewaPayment(String productId, double total, Emitter<PaymentState> emit) async {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test, 
          clientId: ESEWA_CLIENT_ID,
          secretId: ESEWA_SECRET_KEY,
        ),
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: "Rolo Order - ${state.cart.items.length} items",
          productPrice: total.toStringAsFixed(0), 
          callbackUrl: "https://your-app.com/payment-callback", 
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          _handleEsewaPaymentSuccess(result);
        },
        onPaymentFailure: (data) {
          _handleEsewaPaymentFailure('eSewa payment failed. Please try again.');
        },
        onPaymentCancellation: (data) {
          _handleEsewaPaymentFailure('Payment was cancelled');
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(state.copyWith(
          status: PaymentStatus.error,
          error: 'eSewa initialization error: ${e.toString()}',
        ));
      }
    }
  }

  void _handleEsewaPaymentSuccess(EsewaPaymentSuccessResult result) {
    print('eSewa Payment Success Callback Triggered');
    print('RefID: ${result.refId}');
    print('Product ID: ${result.productId}');
    print('Total Amount: ${result.totalAmount}');
    
    add(EsewaPaymentSucceeded(result));
  }
  void _handleEsewaPaymentFailure(String errorMessage) {
    print('eSewa Payment Failed: $errorMessage');
    
    add(EsewaPaymentFailed(errorMessage));
  }
  Future<void> _onEsewaPaymentSucceeded(
    EsewaPaymentSucceeded event, 
    Emitter<PaymentState> emit,
  ) async {
    print('Processing eSewa Payment Success Event');
    
    try {
      final params = CreateOrderParams(
        cart: state.cart,
        shippingAddress: state.shippingAddress,
        paymentMethod: 'esewa',
        deliveryFee: state.deliveryFee,
        userId: state.userId,
      );
      
      print('Creating order with eSewa payment...');
      final result = await _createOrderUseCase(params);
      
      if (!emit.isDone) {
        result.fold(
          (failure) {
            print('Order creation failed: ${failure.message}');
            emit(state.copyWith(
              status: PaymentStatus.error,
              error: 'Order creation failed after payment: ${failure.message}',
            ));
          },
          (order) {
            print('Order created successfully: ${order.id}');
            
            print('eSewa Payment Details:');
            print('- RefID: ${event.result.refId}');
            print('- Product ID: ${event.result.productId}');
            print('- Total Amount: ${event.result.totalAmount}');
            print('- Transaction Date: ${event.result.date}');
            emit(state.copyWith(
              status: PaymentStatus.success,
              createdOrder: order,
            ));
          },
        );
      }
    } catch (e) {
      print('Exception in eSewa payment success handler: $e');
      if (!emit.isDone) {
        emit(state.copyWith(
          status: PaymentStatus.error,
          error: 'Failed to create order after payment: ${e.toString()}',
        ));
      }
    }
  }

  void _onEsewaPaymentFailed(EsewaPaymentFailed event, Emitter<PaymentState> emit) {
    print('Processing eSewa Payment Failed Event: ${event.errorMessage}');
    
    if (!emit.isDone) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        error: event.errorMessage,
      ));
    }
  }

  @override
  void onChange(Change<PaymentState> change) {
    super.onChange(change);
    print('PaymentState changed from ${change.currentState.status} to ${change.nextState.status}');
    if (change.nextState.error != null) {
      print('Error: ${change.nextState.error}');
    }
    if (change.nextState.createdOrder != null) {
      print('Order created: ${change.nextState.createdOrder!.id}');
    }
  }
}