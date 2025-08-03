import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/cart/presentation/view/cart_view.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/presentation/view/payment_method_view.dart';

class OrderFailView extends StatefulWidget {
  final CartEntity cart;
  final ShippingAddressEntity shippingAddress;
  final double deliveryFee;
  final String userId;
  final String? errorMessage;

  const OrderFailView({
    super.key,
    required this.cart,
    required this.shippingAddress,
    required this.deliveryFee,
    required this.userId,
    this.errorMessage,
  });

  static const String routeName = '/order-fail';

  @override
  State<OrderFailView> createState() => _OrderFailViewState();
}

class _OrderFailViewState extends State<OrderFailView> {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _startAnimation = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              AnimatedScale(
                scale: _startAnimation ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/Payment Failed.json',
                    repeat: false,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _startAnimation ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: Column(
                  children: [
                    Text(
                      'Payment Failed',
                      style: AppTheme.headingStyle.copyWith(color: AppTheme.errorColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.errorMessage ?? 'We couldn\'t process your payment. Please review the details or try another method.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyStyle.copyWith(color: Colors.grey.shade400, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    _buildActionButtons(context),
                    const SizedBox(height: 40),
                    _buildCommonIssuesCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => PaymentMethodView(
                    cart: widget.cart,
                    address: widget.shippingAddress,
                    deliveryFee: widget.deliveryFee,
                    userId: widget.userId,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.shopping_cart_outlined), 
            label: const Text('Back to Cart'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const CartView()),
                (route) => route.isFirst,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommonIssuesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Common Reasons for Failure', style: AppTheme.subheadingStyle),
          const SizedBox(height: 16),
          _buildIssueRow(Icons.credit_card_off, 'Incorrect card details or insufficient funds.'),
          const Divider(height: 24),
          _buildIssueRow(Icons.wifi_off, 'Poor internet connection during the transaction.'),
          const Divider(height: 24),
          _buildIssueRow(Icons.gpp_bad_outlined, 'The transaction was declined by your bank.'),
        ],
      ),
    );
  }

  Widget _buildIssueRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryColor.withOpacity(0.8), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTheme.captionStyle)),
      ],
    );
  }
}