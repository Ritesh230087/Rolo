import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/order/presentation/view/order-form_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartViewModel>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: BlocConsumer<CartViewModel, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.failure && state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading && state.cart.items.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          } else if (state.status == CartStatus.failure && state.cart.items.isEmpty) {
            return Center(child: Text(state.errorMessage, style: AppTheme.bodyStyle));
          } else if (state.cart.items.isEmpty) {
            return _buildEmptyCart();
          } else {
            return _buildCartWithItems(context, state);
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<CartViewModel, CartState>(
        builder: (context, state) {
          return state.cart.items.isEmpty ? const SizedBox.shrink() : _buildCheckoutBar(context, state);
        },
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(top: BorderSide(color: Color(0xFF2C2C2C), width: 1)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subtotal', style: TextStyle(color: Colors.grey)),
              Text('NPR ${state.cart.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const OrderFormPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          const Text('Your cart is empty', style: AppTheme.subheadingStyle),
          const SizedBox(height: 8),
          const Text('Add items to get started', style: AppTheme.captionStyle),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(BuildContext context, CartState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              final item = state.cart.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCartItem(context, item),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildOrderSummary(context, state),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemEntity item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<CartViewModel>().add(RemoveItemFromCart(item.id));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('NPR ${item.product.price.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${item.product.quantity} available',
                      style: AppTheme.captionStyle.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityController(context, item),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<CartViewModel>().add(RemoveItemFromCart(item.id)),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityController(BuildContext context, CartItemEntity item) {
    final bool canIncrease = item.quantity < item.product.quantity;
    final bool canDecrease = item.quantity > 1;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 16, color: canDecrease ? Colors.white : Colors.grey),
            onPressed: canDecrease
                ? () => context.read<CartViewModel>().add(UpdateItemQuantity(item.id, item.quantity - 1))
                : null,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 16, color: canIncrease ? Colors.white : Colors.grey),
            onPressed: canIncrease
                ? () => context.read<CartViewModel>().add(UpdateItemQuantity(item.id, item.quantity + 1))
                : null,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', 'NPR ${state.cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', 'Calculated at next step', isPrice: false),
          const Divider(height: 24),
          _buildSummaryRow('Total', 'NPR ${state.cart.subtotal.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Row _buildSummaryRow(String label, String value, {bool isTotal = false, bool isPrice = true}) {
    final defaultStyle = AppTheme.bodyStyle;
    final nonPriceStyle = AppTheme.captionStyle.copyWith(fontStyle: FontStyle.italic);
    final totalLabelStyle = defaultStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16);
    final totalValueStyle = totalLabelStyle.copyWith(color: AppTheme.primaryColor);

    final labelStyle = isTotal ? totalLabelStyle : defaultStyle;
    final valueStyle = isTotal ? totalValueStyle : (isPrice ? defaultStyle : nonPriceStyle);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}