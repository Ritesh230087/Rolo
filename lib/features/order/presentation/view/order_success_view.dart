import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';
import 'package:rolo/features/dashboard/presentation/view/dashboard_view.dart';

class OrderSuccessView extends StatefulWidget {
  final OrderEntity order;

  const OrderSuccessView({
    super.key,
    required this.order,
  });

  static const String routeName = '/order-success';

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
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
                  child: Lottie.asset('assets/animations/Payment Success.json'),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _startAnimation ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: Column(
                  children: [
                    Text('Order Placed Successfully!', textAlign: TextAlign.center, style: AppTheme.headingStyle.copyWith(color: AppTheme.primaryColor)),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for your purchase. Your order #${widget.order.id.substring(widget.order.id.length - 6).toUpperCase()} is being processed.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyStyle.copyWith(color: Colors.grey.shade400, fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    _buildOrderSummaryCard(),
                    const SizedBox(height: 40),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Number:', style: AppTheme.captionStyle),
              Text('#${widget.order.id.substring(widget.order.id.length - 6).toUpperCase()}', style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount:', style: AppTheme.captionStyle),
              Text('NPR ${widget.order.totalAmount.toStringAsFixed(2)}', style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Continue Shopping'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardView(initialIndex: 1)),
                (route) => false,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Order History'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (_) => const DashboardView(initialIndex: 3)),
                 (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}