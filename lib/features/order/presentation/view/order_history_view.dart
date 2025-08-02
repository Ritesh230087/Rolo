// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/order/domain/entity/order_entity.dart';

// class OrderHistoryView extends StatefulWidget {
//   final List<OrderEntity> orders;
//   const OrderHistoryView({super.key, required this.orders});

//   @override
//   State<OrderHistoryView> createState() => _OrderHistoryViewState();
// }

// class _OrderHistoryViewState extends State<OrderHistoryView> with TickerProviderStateMixin {
//   late AnimationController _headerController;
//   late AnimationController _ordersController;
//   late Animation<double> _headerAnimation;

//   String _selectedFilter = 'All';
//   final List<String> _filters = ['All', 'Processing', 'In Transit', 'Shipped', 'Delivered'];

//   @override
//   void initState() {
//     super.initState();
//     _headerController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
//     _ordersController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
//     _headerAnimation = CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic);
//     _startAnimations();
//   }

//   void _startAnimations() async {
//     _headerController.forward();
//     await Future.delayed(const Duration(milliseconds: 300));
//     _ordersController.forward();
//   }

//   @override
//   void dispose() {
//     _headerController.dispose();
//     _ordersController.dispose();
//     super.dispose();
//   }

//   List<OrderEntity> _getFilteredOrders() {
//     if (_selectedFilter == 'All') {
//       return widget.orders;
//     }
//     return widget.orders.where((order) {
//       String normalizedStatus = _normalizeStatus(order.deliveryStatus);
//       String normalizedFilter = _normalizeStatus(_selectedFilter);
//       return normalizedStatus == normalizedFilter;
//     }).toList();
//   }

//   String _normalizeStatus(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return 'processing';
//       case 'processing':
//         return 'processing';
//       case 'in transit':
//       case 'intransit':
//         return 'in transit';
//       case 'shipped':
//         return 'shipped';
//       case 'delivered':
//         return 'delivered';
//       default:
//         return status.toLowerCase();
//     }
//   }

//   Color _getStatusColor(String status) {
//     String normalizedStatus = _normalizeStatus(status);
//     switch (normalizedStatus) {
//       case 'processing':
//         return Colors.blue;
//       case 'in transit':
//         return Colors.orange;
//       case 'shipped':
//         return Colors.purple;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     String normalizedStatus = _normalizeStatus(status);
//     switch (normalizedStatus) {
//       case 'processing':
//         return Icons.hourglass_empty;
//       case 'in transit':
//         return Icons.local_shipping;
//       case 'shipped':
//         return Icons.flight_takeoff;
//       case 'delivered':
//         return Icons.check_circle;
//       case 'cancelled':
//         return Icons.cancel;
//       default:
//         return Icons.shopping_bag;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orders = _getFilteredOrders();

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Order History'),
//         iconTheme: const IconThemeData(color: AppTheme.accentColor),
//         backgroundColor: AppTheme.backgroundColor,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           FadeTransition(
//             opacity: _headerAnimation,
//             child: _buildFilterBar(),
//           ),
//           Expanded(
//             child: AnimatedBuilder(
//               animation: _ordersController,
//               builder: (context, child) {
//                 return orders.isEmpty
//                     ? _buildEmptyState()
//                     : _buildOrdersList(orders);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       height: 60,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: _filters.map((filter) {
//           final isSelected = _selectedFilter == filter;
//           final statusColor = filter == 'All' ? AppTheme.primaryColor : _getStatusColor(filter);
          
//           return GestureDetector(
//             onTap: () => setState(() => _selectedFilter = filter),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.only(right: 12),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 gradient: isSelected
//                     ? LinearGradient(
//                         colors: [statusColor, statusColor.withOpacity(0.8)]
//                       )
//                     : null,
//                 color: isSelected ? null : AppTheme.cardColor,
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(
//                   color: isSelected ? statusColor : statusColor.withOpacity(0.3),
//                   width: 1.5,
//                 ),
//                 boxShadow: isSelected ? [
//                   BoxShadow(
//                     color: statusColor.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   )
//                 ] : null,
//               ),
//               child: Text(
//                 filter,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : statusColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildOrdersList(List<OrderEntity> orders) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         final order = orders[index];
//         return TweenAnimationBuilder<double>(
//           duration: Duration(milliseconds: 500 + index * 100),
//           tween: Tween(begin: 0.0, end: 1.0),
//           builder: (context, value, child) {
//             return Opacity(
//               opacity: value,
//               child: Transform.translate(
//                 offset: Offset(50 * (1 - value), 0),
//                 child: _buildOrderCard(order),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildOrderCard(OrderEntity order) {
//     final statusColor = _getStatusColor(order.deliveryStatus);
//     final statusIcon = _getStatusIcon(order.deliveryStatus);
//     final normalizedStatus = _normalizeStatus(order.deliveryStatus);
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: statusColor,
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: statusColor.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Order Header with Status Color Background
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(14),
//                 topRight: Radius.circular(14),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(statusIcon, color: statusColor, size: 24),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order #${order.id.substring(order.id.length - 8).toUpperCase()}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     normalizedStatus.toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Order Details
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Products Section Header
//                 Row(
//                   children: [
//                     Icon(Icons.shopping_basket, size: 18, color: statusColor),
//                     const SizedBox(width: 6),
//                     const Text(
//                       'Products',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
//                         style: TextStyle(
//                           color: statusColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
                
//                 // Product List with detailed info
//                 ...order.items.map((item) => _buildProductItem(item, statusColor)),
                
//                 const SizedBox(height: 16),
                
//                 // Order Summary Section
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: statusColor.withOpacity(0.2)),
//                   ),
//                   child: Column(
//                     children: [
//                       // Subtotal
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Subtotal:', style: TextStyle(fontSize: 13)),
//                           Text(
//                             'NPR ${(order.totalAmount - order.deliveryFee).toStringAsFixed(2)}',
//                             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
                      
//                       // Delivery Fee
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Delivery Fee:', style: TextStyle(fontSize: 13)),
//                           Text(
//                             'NPR ${order.deliveryFee.toStringAsFixed(2)}',
//                             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
                      
//                       Divider(color: statusColor.withOpacity(0.3), height: 16),
                      
//                       // Total Amount
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Total Amount:',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: statusColor,
//                             ),
//                           ),
//                           Text(
//                             'NPR ${order.totalAmount.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 12),
                
//                 // Payment & Shipping Info Row
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildInfoCard(
//                         'Payment',
//                         order.paymentMethod.toUpperCase(),
//                         Icons.payment,
//                         statusColor,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _buildInfoCard(
//                         'Status',
//                         order.paymentStatus.toUpperCase(),
//                         Icons.account_balance_wallet,
//                         statusColor,
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 12),
                
//                 // Shipping Address
//                 _buildShippingAddressCard(order.shippingAddress, statusColor),
                
//                 const SizedBox(height: 16),
                
//                 // Action Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () => _showOrderDetails(order),
//                     icon: const Icon(Icons.visibility_outlined, size: 18),
//                     label: const Text('View Full Details'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: statusColor,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductItem(dynamic item, Color statusColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           // Product Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               item.imageUrl,
//               width: 55,
//               height: 55,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 width: 55,
//                 height: 55,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.image, color: statusColor.withOpacity(0.5)),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
          
//           // Product Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       'Qty: ',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '${item.quantity}',
//                         style: TextStyle(
//                           color: statusColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Unit Price: NPR ${item.price.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Price Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: statusColor,
//                 ),
//               ),
//               Text(
//                 '${item.quantity} × ${item.price.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(String title, String value, IconData icon, Color statusColor) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 16, color: statusColor),
//               const SizedBox(width: 4),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//               color: statusColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShippingAddressCard(dynamic shippingAddress, Color statusColor) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.location_on, size: 16, color: statusColor),
//               const SizedBox(width: 4),
//               Text(
//                 'Shipping Address',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             shippingAddress.fullName,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: statusColor,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             '${shippingAddress.address}, ${shippingAddress.city}',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey[700],
//             ),
//           ),
//           Text(
//             '${shippingAddress.district}, ${shippingAddress.country}',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey[700],
//             ),
//           ),
//           if (shippingAddress.phone.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 4),
//               child: Row(
//                 children: [
//                   Icon(Icons.phone, size: 14, color: statusColor),
//                   const SizedBox(width: 4),
//                   Text(
//                     shippingAddress.phone,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_bag_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No Orders Found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _selectedFilter == 'All' 
//                 ? 'You haven\'t placed any orders yet'
//                 : 'No orders found with status: $_selectedFilter',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _selectedFilter = 'All';
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               foregroundColor: Colors.black,
//             ),
//             child: const Text('Show All Orders'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showOrderDetails(OrderEntity order) {
//     final statusColor = _getStatusColor(order.deliveryStatus);
    
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.9,
//         maxChildSize: 0.95,
//         minChildSize: 0.5,
//         builder: (context, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: AppTheme.cardColor,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             children: [
//               // Handle
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
              
//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Order Details',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: statusColor,
//                             ),
//                           ),
//                           Text(
//                             'Order #${order.id.substring(order.id.length - 8).toUpperCase()}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Icon(Icons.close, color: statusColor),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Scrollable Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Order Status Timeline
//                       _buildStatusTimeline(order.deliveryStatus),
                      
//                       const SizedBox(height: 24),
                      
//                       // All Products with Details
//                       Text(
//                         'Order Items (${order.items.length})',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       ...order.items.map((item) => _buildDetailedProductCard(item, statusColor)),
                      
//                       const SizedBox(height: 24),
                      
//                       // Order Summary
//                       _buildOrderSummary(order, statusColor),
                      
//                       const SizedBox(height: 24),
                      
//                       // Shipping Details
//                       _buildDetailedShippingCard(order.shippingAddress, statusColor),
                      
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusTimeline(String currentStatus) {
//     final statuses = ['Processing', 'In Transit', 'Shipped', 'Delivered'];
//     final normalizedCurrent = _normalizeStatus(currentStatus);
//     final currentIndex = statuses.indexWhere(
//       (status) => _normalizeStatus(status) == normalizedCurrent
//     );
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _getStatusColor(currentStatus).withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Status Timeline',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: _getStatusColor(currentStatus),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: statuses.asMap().entries.map((entry) {
//               final index = entry.key;
//               final status = entry.value;
//               final isActive = index <= currentIndex;
//               final isCompleted = index < currentIndex;
//               final statusColor = _getStatusColor(status);
              
//               return Expanded(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: isActive ? statusColor : Colors.grey[300],
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         isCompleted ? Icons.check : _getStatusIcon(status),
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                     if (index < statuses.length - 1)
//                       Expanded(
//                         child: Container(
//                           height: 2,
//                           color: isCompleted ? statusColor : Colors.grey[300],
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: statuses.map((status) => Expanded(
//               child: Text(
//                 status,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: currentIndex >= statuses.indexOf(status) 
//                       ? _getStatusColor(status) 
//                       : Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             )).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailedProductCard(dynamic item, Color statusColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               item.imageUrl,
//               width: 70,
//               height: 70,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.image, color: statusColor.withOpacity(0.5)),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Product ID: ${item.productId}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       'Unit Price: ',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                       ),
//                     ),
//                     Text(
//                       'NPR ${item.price.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         color: statusColor,
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   'Qty: ${item.quantity}',
//                   style: TextStyle(
//                     color: statusColor,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                   color: statusColor,
//                 ),
//               ),
//               Text(
//                 '${item.quantity} × ${item.price.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummary(OrderEntity order, Color statusColor) {
//     final subtotal = order.totalAmount - order.deliveryFee;
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Summary',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: statusColor,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Subtotal'),
//               Text('NPR ${subtotal.toStringAsFixed(2)}'),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Delivery Fee'),
//               Text('NPR ${order.deliveryFee.toStringAsFixed(2)}'),
//             ],
//           ),
//           Divider(height: 24, color: statusColor.withOpacity(0.3)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Amount',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold, 
//                   fontSize: 16,
//                   color: statusColor,
//                 ),
//               ),
//               Text(
//                 'NPR ${order.totalAmount.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: statusColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Payment Method'),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   order.paymentMethod.toUpperCase(),
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Payment Status'),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: order.paymentStatus.toLowerCase() == 'paid' 
//                       ? Colors.green.withOpacity(0.1)
//                       : Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   order.paymentStatus.toUpperCase(),
//                   style: TextStyle(
//                     color: order.paymentStatus.toLowerCase() == 'paid' 
//                         ? Colors.green 
//                         : Colors.orange,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailedShippingCard(dynamic shippingAddress, Color statusColor) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.location_on, color: statusColor),
//               const SizedBox(width: 8),
//               Text(
//                 'Shipping Address',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: statusColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             shippingAddress.fullName,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(shippingAddress.address),
//           Text('${shippingAddress.city}, ${shippingAddress.district}'),
//           Text(shippingAddress.country),
//           if (shippingAddress.postalCode.isNotEmpty)
//             Text('Postal Code: ${shippingAddress.postalCode}'),
//           const SizedBox(height: 8),
//           if (shippingAddress.phone.isNotEmpty)
//             Row(
//               children: [
//                 Icon(Icons.phone, size: 16, color: statusColor),
//                 const SizedBox(width: 4),
//                 Text(shippingAddress.phone),
//               ],
//             ),
//           if (shippingAddress.notes.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             const Text(
//               'Notes:',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             Text(shippingAddress.notes),
//           ],
//         ],
//       ),
//     );
//   }
// }



































































import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/order/domain/entity/order_entity.dart';

class OrderHistoryView extends StatefulWidget {
  final List<OrderEntity> orders;
  final VoidCallback? onRefresh;
  const OrderHistoryView({super.key, required this.orders, this.onRefresh});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _ordersController;
  late Animation<double> _headerAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Processing', 'In Transit', 'Shipped', 'Delivered'];

  @override
  void initState() {
    super.initState();
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

  List<OrderEntity> _getFilteredOrders() {
    if (_selectedFilter == 'All') {
      return widget.orders;
    }
    return widget.orders.where((order) {
      String normalizedStatus = _normalizeStatus(order.deliveryStatus);
      String normalizedFilter = _normalizeStatus(_selectedFilter);
      return normalizedStatus == normalizedFilter;
    }).toList();
  }

  String _normalizeStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'processing';
      case 'processing':
        return 'processing';
      case 'in transit':
      case 'intransit':
        return 'in transit';
      case 'shipped':
        return 'shipped';
      case 'delivered':
        return 'delivered';
      default:
        return status.toLowerCase();
    }
  }

  Color _getStatusColor(String status) {
    String normalizedStatus = _normalizeStatus(status);
    switch (normalizedStatus) {
      case 'processing':
        return Colors.blue;
      case 'in transit':
        return Colors.orange;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    String normalizedStatus = _normalizeStatus(status);
    switch (normalizedStatus) {
      case 'processing':
        return Icons.hourglass_empty;
      case 'in transit':
        return Icons.local_shipping;
      case 'shipped':
        return Icons.flight_takeoff;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = _getFilteredOrders();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order History'),
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.onRefresh != null) {
            widget.onRefresh!();
          }
        },
        child: Column(
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
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          final statusColor = filter == 'All' ? AppTheme.primaryColor : _getStatusColor(filter);
          
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [statusColor, statusColor.withOpacity(0.8)]
                      )
                    : null,
                color: isSelected ? null : AppTheme.cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? statusColor : statusColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderEntity> orders) {
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

  Widget _buildOrderCard(OrderEntity order) {
    final statusColor = _getStatusColor(order.deliveryStatus);
    final statusIcon = _getStatusIcon(order.deliveryStatus);
    final normalizedStatus = _normalizeStatus(order.deliveryStatus);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header with Status Color Background
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.substring(order.id.length - 8).toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    normalizedStatus.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Order Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Products Section Header
                Row(
                  children: [
                    Icon(Icons.shopping_basket, size: 18, color: statusColor),
                    const SizedBox(width: 6),
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Product List with detailed info
                ...order.items.map((item) => _buildProductItem(item, statusColor)),
                
                const SizedBox(height: 16),
                
                // Order Summary Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      // Subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:', style: TextStyle(fontSize: 13)),
                          Text(
                            'NPR ${(order.totalAmount - order.deliveryFee).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Delivery Fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Fee:', style: TextStyle(fontSize: 13)),
                          Text(
                            'NPR ${order.deliveryFee.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      
                      Divider(color: statusColor.withOpacity(0.3), height: 16),
                      
                      // Total Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          Text(
                            'NPR ${order.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Payment & Shipping Info Row
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Payment',
                        order.paymentMethod.toUpperCase(),
                        Icons.payment,
                        statusColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoCard(
                        'Status',
                        order.paymentStatus.toUpperCase(),
                        Icons.account_balance_wallet,
                        statusColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Shipping Address
                _buildShippingAddressCard(order.shippingAddress, statusColor),
                
                const SizedBox(height: 16),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showOrderDetails(order),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View Full Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: statusColor.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Unit Price: NPR ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Price Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: statusColor,
                ),
              ),
              Text(
                '${item.quantity} × ${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressCard(dynamic shippingAddress, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            shippingAddress.fullName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${shippingAddress.address}, ${shippingAddress.city}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          Text(
            '${shippingAddress.district}, ${shippingAddress.country}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          if (shippingAddress.phone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.phone, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    shippingAddress.phone,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
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
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All' 
                ? 'You haven\'t placed any orders yet'
                : 'No orders found with status: $_selectedFilter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text('Show All Orders'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(OrderEntity order) {
    final statusColor = _getStatusColor(order.deliveryStatus);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          Text(
                            'Order #${order.id.substring(order.id.length - 8).toUpperCase()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: statusColor),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Status Timeline
                      _buildStatusTimeline(order.deliveryStatus),
                      
                      const SizedBox(height: 24),
                      
                      // All Products with Details
                      Text(
                        'Order Items (${order.items.length})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order.items.map((item) => _buildDetailedProductCard(item, statusColor)),
                      
                      const SizedBox(height: 24),
                      
                      // Order Summary
                      _buildOrderSummary(order, statusColor),
                      
                      const SizedBox(height: 24),
                      
                      // Shipping Details
                      _buildDetailedShippingCard(order.shippingAddress, statusColor),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = ['Processing', 'In Transit', 'Shipped', 'Delivered'];
    final normalizedCurrent = _normalizeStatus(currentStatus);
    final currentIndex = statuses.indexWhere(
      (status) => _normalizeStatus(status) == normalizedCurrent
    );
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(currentStatus).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(currentStatus),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: statuses.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isActive = index <= currentIndex;
              final isCompleted = index < currentIndex;
              final statusColor = _getStatusColor(status);
              
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isActive ? statusColor : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : _getStatusIcon(status),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    if (index < statuses.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted ? statusColor : Colors.grey[300],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: statuses.map((status) => Expanded(
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: currentIndex >= statuses.indexOf(status) 
                      ? _getStatusColor(status) 
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedProductCard(dynamic item, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: statusColor.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Product ID: ${item.productId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Unit Price: ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'NPR ${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'NPR ${(item.price * item.quantity).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: statusColor,
                ),
              ),
              Text(
                '${item.quantity} × ${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(OrderEntity order, Color statusColor) {
    final subtotal = order.totalAmount - order.deliveryFee;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('NPR ${subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee'),
              Text('NPR ${order.deliveryFee.toStringAsFixed(2)}'),
            ],
          ),
          Divider(height: 24, color: statusColor.withOpacity(0.3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: statusColor,
                ),
              ),
              Text(
                'NPR ${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment Method'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.paymentMethod.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment Status'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.paymentStatus.toLowerCase() == 'paid' 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.paymentStatus.toUpperCase(),
                  style: TextStyle(
                    color: order.paymentStatus.toLowerCase() == 'paid' 
                        ? Colors.green 
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedShippingCard(dynamic shippingAddress, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: statusColor),
              const SizedBox(width: 8),
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            shippingAddress.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(shippingAddress.address),
          Text('${shippingAddress.city}, ${shippingAddress.district}'),
          Text(shippingAddress.country),
          if (shippingAddress.postalCode.isNotEmpty)
            Text('Postal Code: ${shippingAddress.postalCode}'),
          const SizedBox(height: 8),
          if (shippingAddress.phone.isNotEmpty)
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: statusColor),
                const SizedBox(width: 4),
                Text(shippingAddress.phone),
              ],
            ),
          if (shippingAddress.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Notes:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(shippingAddress.notes),
          ],
        ],
      ),
    );
  }
}