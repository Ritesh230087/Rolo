import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';

class OrderHistoryView extends StatefulWidget {
  final List<OrderEntity> orders;
  const OrderHistoryView({super.key, required this.orders});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _ordersController;
  late Animation<double> _headerAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Delivered', 'In Transit', 'Processing', 'Cancelled'];

  late List<Map<String, dynamic>> _allOrders;

  @override
  void initState() {
    super.initState();
    
    _allOrders = widget.orders.map((order) {
      Color statusColor;
      switch (order.deliveryStatus.toLowerCase()) {
        case 'delivered':
          statusColor = Colors.green;
          break;
        case 'in transit':
          statusColor = Colors.orange;
          break;
        case 'processing':
          statusColor = Colors.blue;
          break;
        case 'cancelled':
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.grey;
      }
      return {
        'id': '#${order.id.substring(order.id.length - 8).toUpperCase()}',
        'date': DateFormat('yyyy-MM-dd').format(order.createdAt),
        'status': order.deliveryStatus,
        'total': 'NPR. ${order.totalAmount.toStringAsFixed(2)}',
        'items': order.items.length,
        'color': statusColor,
      };
    }).toList();

    _headerController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _ordersController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _headerAnimation = CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic);

    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _ordersController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _ordersController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    if (_selectedFilter == 'All') {
      return _allOrders;
    }
    return _allOrders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final orders = _getFilteredOrders();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order History'),
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
      ),
      body: Column(
        children: [
          FadeTransition(
            opacity: _headerAnimation,
            child: _buildFilterBar(),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _ordersController,
              builder: (context, child) {
                return orders.isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(orders);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)])
                    : null,
                color: isSelected ? null : AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + index * 100),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: _buildOrderCard(order),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: (order['color'] as Color).withOpacity(0.2),
              child: Icon(Icons.shopping_bag_outlined, color: order['color']),
            ),
            title: Text(order['id'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(order['date']),
            trailing: Chip(
              label: Text(order['status']),
              backgroundColor: (order['color'] as Color).withOpacity(0.2),
              labelStyle: TextStyle(color: order['color'], fontSize: 12, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order['items']} items', style: const TextStyle(color: Colors.grey)),
                Text(order['total'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showOrderDetails(order),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _trackOrder(order),
                    icon: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: const Text('Track'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inbox, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Orders Found', style: AppTheme.subheadingStyle),
          SizedBox(height: 8),
          Text('There are no orders with the selected filter.', style: AppTheme.captionStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order: ${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Date: ${order['date']}'),
            Text('Status: ${order['status']}'),
            Text('Items: ${order['items']}'),
            Text('Total: ${order['total']}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tracking ${order['id']}...'),
      backgroundColor: AppTheme.primaryColor,
    ));
  }
}