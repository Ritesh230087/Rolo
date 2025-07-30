import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/presentation/view/bank_transfer_view.dart';
import 'package:rolo/features/order/presentation/view/order_fail_view.dart';
import 'package:rolo/features/order/presentation/view/order_success_view.dart';
import 'package:rolo/features/order/presentation/view_model/payment/payment_event.dart';
import 'package:rolo/features/order/presentation/view_model/payment/payment_state.dart';
import 'package:rolo/features/order/presentation/view_model/payment/payment_viewmodel.dart';

class PaymentMethodView extends StatelessWidget {
  final CartEntity cart;
  final ShippingAddressEntity address;
  final double deliveryFee;
  final String userId;

  const PaymentMethodView({
    super.key,
    required this.cart,
    required this.address,
    required this.deliveryFee,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentViewModel(
        checkCod: serviceLocator(),
        createOrderUseCase: serviceLocator(),
        cart: cart,
        address: address,
        deliveryFee: deliveryFee,
        userId: userId,
      )..add(LoadPaymentMethods(address.district)),
      child: BlocListener<PaymentViewModel, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.error) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderFailView(
                  cart: state.cart,
                  shippingAddress: state.shippingAddress,
                  deliveryFee: state.deliveryFee,
                  userId: state.userId,
                  errorMessage: state.error,
                ),
              ),
            );
          }
          
          if (state.status == PaymentStatus.success && state.createdOrder != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => OrderSuccessView(order: state.createdOrder!),
              ),
              (route) => false,
            );
          }
          
          if (state.status == PaymentStatus.navigateToBankTransfer) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BankTransferView(
                  cart: state.cart,
                  address: state.shippingAddress,
                  deliveryFee: state.deliveryFee,
                  userId: state.userId,
                ),
              ),
            );
          }
        },
        child: const PaymentMethodScreenContent(),
      ),
    );
  }
}

class PaymentMethodScreenContent extends StatelessWidget {
  const PaymentMethodScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentViewModel, PaymentState>(
      builder: (context, state) {
        final total = state.cart.subtotal + state.deliveryFee;
        
        final String buttonText = state.selectedMethodId == 'bank'
            ? 'Continue to Bank Details'
            : state.selectedMethodId == 'esewa'
                ? 'Pay with eSewa - NPR ${total.toStringAsFixed(0)}'
                : state.selectedMethodId == 'cod'
                    ? 'Place Order (COD) - NPR ${total.toStringAsFixed(0)}'
                    : 'Place Order - NPR ${total.toStringAsFixed(0)}';

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Select Payment Method'),
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.methods.length,
                  itemBuilder: (_, i) {
                    final method = state.methods[i];
                    final isBlocked = method.id == 'cod' && !state.isCodAvailable;
                    final isSelected = state.selectedMethodId == method.id;

                    return Card(
                      elevation: isSelected ? 4 : 1,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        enabled: !isBlocked,
                        leading: method.id == 'esewa'
                          ? SizedBox(
                              width: 50,
                              height: 40,
                              child: Image.asset(
                                'assets/images/esewa.jpg',
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(method.icon, style: const TextStyle(fontSize: 36)),
                        title: Text(method.name, style: AppTheme.subheadingStyle.copyWith(fontSize: 18)),
                        subtitle: Text(
                          isBlocked ? 'Not available in your district' : method.description,
                          style: AppTheme.captionStyle.copyWith(color: isBlocked ? Colors.red.shade300 : null),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 28)
                            : const Icon(Icons.circle_outlined, color: Colors.grey, size: 28),
                        onTap: isBlocked
                            ? null
                            : () {
                                context.read<PaymentViewModel>().add(PaymentMethodSelected(method.id));
                              },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.status == PaymentStatus.processing || state.selectedMethodId == null
                        ? null
                        : () {
                            context.read<PaymentViewModel>().add(ProceedToPayment());
                          },
                    child: state.status == PaymentStatus.processing
                        ? const SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          )
                        : Text(buttonText),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}