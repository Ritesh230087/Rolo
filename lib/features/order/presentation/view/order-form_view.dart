// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/animated_form_field.dart';
// import 'package:rolo/core/widgets/autocomplete_field.dart';
// import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
// import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
// import 'package:rolo/features/order/presentation/view/payment_method_view.dart';
// import 'package:rolo/features/order/presentation/view_model/order_form/order_form_event.dart';
// import 'package:rolo/features/order/presentation/view_model/order_form/order_form_state.dart';
// import 'package:rolo/features/order/presentation/view_model/order_form/order_form_viemodel.dart';

// class OrderFormPage extends StatelessWidget {
//   const OrderFormPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => serviceLocator<OrderViewModel>(param1: serviceLocator<CartViewModel>(),)..add(OrderLoadInitialData()),
//       child: const _OrderFormView(),
//     );
//   }
// }

// class _OrderFormView extends StatefulWidget {
//   const _OrderFormView();

//   @override
//   State<_OrderFormView> createState() => _OrderFormViewState();
// }

// class _OrderFormViewState extends State<_OrderFormView> {
//   final Map<String, TextEditingController> _controllers = {
//     'firstName': TextEditingController(),
//     'lastName': TextEditingController(),
//     'email': TextEditingController(),
//     'phone': TextEditingController(),
//     'address': TextEditingController(),
//     'postalCode': TextEditingController(),
//     'notes': TextEditingController(),
//     'country': TextEditingController(text: 'Nepal'),
//   };

//   @override
//   void dispose() {
//     _controllers.values.forEach((c) => c.dispose());
//     super.dispose();
//   }

//   void _onFieldChange() {
//     context.read<OrderViewModel>().add(OrderFormFieldChanged(
//       firstName: _controllers['firstName']!.text,
//       lastName: _controllers['lastName']!.text,
//       email: _controllers['email']!.text,
//       phone: _controllers['phone']!.text,
//       address: _controllers['address']!.text,
//       postalCode: _controllers['postalCode']!.text,
//       notes: _controllers['notes']!.text,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartState = context.watch<CartViewModel>().state;
//     final cart = cartState.cart;

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Shipping Information'),
//         backgroundColor: AppTheme.backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: BlocListener<OrderViewModel, OrderState>(
//         listener: (context, state) {
//           // Show snackbar for action messages
//           if (state.actionMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.actionMessage!),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }

//           // Update form fields when state changes
//           if (state.status != OrderStatus.noNetwork) {
//             _controllers['firstName']!.text = state.shippingAddress.firstName;
//             _controllers['lastName']!.text = state.shippingAddress.lastName;
//             _controllers['email']!.text = state.shippingAddress.email;
//             _controllers['phone']!.text = state.shippingAddress.phone;
//             _controllers['address']!.text = state.shippingAddress.address;
//             _controllers['postalCode']!.text = state.shippingAddress.postalCode;
//             _controllers['notes']!.text = state.shippingAddress.notes;
//           }

//           if (state.status == OrderStatus.readyForPayment) {
//             if (state.userId == null) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                 content: Text('Could not verify user. Please restart.'),
//                 backgroundColor: Colors.red,
//               ));
//               return;
//             }
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => PaymentMethodView(
//                   cart: cart,
//                   address: state.shippingAddress,
//                   deliveryFee: state.shippingFee,
//                   userId: state.userId!,
//                 ),
//               ),
//             );
//           }

//           if (state.status == OrderStatus.error) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(SnackBar(
//                 content: Text(state.errorMessage ?? 'An error occurred'),
//                 backgroundColor: Colors.red,
//               ));
//           }
//         },
//         child: BlocBuilder<OrderViewModel, OrderState>(
//           builder: (context, state) {
//             if (state.status == OrderStatus.loading || state.status == OrderStatus.initial) {
//               return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
//             }

//             // Show offline state with Lottie animation
//             if (state.status == OrderStatus.noNetwork) {
//               return _buildOfflineView(context);
//             }

//             if (state.status == OrderStatus.error) {
//               return Center(child: Text(state.errorMessage ?? 'Failed to load data'));
//             }

//             final total = cart.subtotal + state.shippingFee;

//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth > 700) {
//                   return Row(
//                     children: [
//                       Expanded(flex: 3, child: _buildFormSection(context, state)),
//                       Expanded(flex: 2, child: _buildOrderSummary(context, state, cart, total)),
//                     ],
//                   );
//                 }
//                 return SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildFormSection(context, state),
//                       _buildOrderSummary(context, state, cart, total),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: BlocBuilder<OrderViewModel, OrderState>(
//         builder: (context, state) {
//           // Show retry button when offline
//           if (state.status == OrderStatus.noNetwork) {
//             return FloatingActionButton(
//               onPressed: () {
//                 context.read<OrderViewModel>().add(OrderLoadInitialData());
//               },
//               backgroundColor: AppTheme.primaryColor,
//               child: const Icon(Icons.refresh),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildOfflineView(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Lottie animation for no internet connection
//           Lottie.asset(
//             'assets/animations/no_internet_connection.json',
//             width: 200,
//             height: 200,
//             fit: BoxFit.fill,
//             repeat: true,
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No Internet Connection',
//             style: AppTheme.subheadingStyle.copyWith(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Please check your internet connection to continue with your order.',
//               style: AppTheme.captionStyle.copyWith(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () {
//               context.read<OrderViewModel>().add(OrderLoadInitialData());
//             },
//             icon: const Icon(Icons.refresh),
//             label: const Text('Try Again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFormSection(BuildContext context, OrderState state) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: AnimatedFormField(label: 'First Name', controller: _controllers['firstName']!, isRequired: true, onChanged: (_) => _onFieldChange())),
//               const SizedBox(width: 16),
//               Expanded(child: AnimatedFormField(label: 'Last Name', controller: _controllers['lastName']!, isRequired: true, onChanged: (_) => _onFieldChange())),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(child: AnimatedFormField(label: 'Email', controller: _controllers['email']!, isRequired: true, keyboardType: TextInputType.emailAddress, onChanged: (_) => _onFieldChange())),
//               const SizedBox(width: 16),
//               Expanded(child: AnimatedFormField(label: 'Phone', controller: _controllers['phone']!, isRequired: true, keyboardType: TextInputType.phone, onChanged: (_) => _onFieldChange())),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: AutocompleteField(
//                   label: 'District',
//                   value: state.shippingAddress.district,
//                   suggestions: state.availableDistricts,
//                   isRequired: true,
//                   onSelected: (value) => context.read<OrderViewModel>().add(OrderDistrictSelected(value)),
//                   onChanged: (value) {},
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: AutocompleteField(
//                   label: 'City / Branch',
//                   value: state.shippingAddress.city,
//                   suggestions: state.availableCities,
//                   isRequired: true,
//                   enabled: state.shippingAddress.district.isNotEmpty,
//                   onSelected: (value) => context.read<OrderViewModel>().add(OrderCitySelected(value)),
//                   onChanged: (value) {},
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: AnimatedFormField(
//                   label: 'Country',
//                   controller: _controllers['country']!,
//                   isRequired: true,
//                   enabled: false,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: AnimatedFormField(
//                   label: 'Postal Code (Optional)',
//                   controller: _controllers['postalCode']!,
//                   keyboardType: TextInputType.number,
//                   isRequired: false,
//                   onChanged: (_) => _onFieldChange(),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           AnimatedFormField(label: 'Street Address', controller: _controllers['address']!, isRequired: true, onChanged: (_) => _onFieldChange()),
//           const SizedBox(height: 20),
//           AnimatedFormField(label: 'Order Notes (Optional)', controller: _controllers['notes']!, maxLines: 3, onChanged: (_) => _onFieldChange()),
//           const SizedBox(height: 32),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: (state.shippingFee > 0 && state.status != OrderStatus.proceedingToPayment)
//                   ? () => context.read<OrderViewModel>().add(ProceedToPayment())
//                   : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primaryColor,
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: state.status == OrderStatus.proceedingToPayment
//                   ? const CircularProgressIndicator(color: Colors.black)
//                   : const Text('Continue to Payment'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummary(BuildContext context, OrderState state, CartEntity cart, double total) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             width: double.infinity,
//             child: Text('Order Summary', style: AppTheme.subheadingStyle),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             itemCount: cart.items.length,
//             itemBuilder: (context, index) {
//               final item = cart.items[index];
//               return ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: SizedBox(width: 50, child: Image.network(item.product.imageUrl)),
//                 title: Text(item.product.name),
//                 subtitle: Text('Qty: ${item.quantity}'),
//                 trailing: Text('Rs ${item.product.price * item.quantity}'),
//               );
//             },
//           ),
//           const Divider(thickness: 1),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Column(
//               children: [
//                 _buildSummaryRow(context, 'Subtotal', 'Rs ${cart.subtotal}'),
//                 _buildSummaryRow(context, 'Shipping Fee', 'Rs ${state.shippingFee}'),
//                 const SizedBox(height: 12),
//                 _buildSummaryRow(context, 'Total', 'Rs $total', isTotal: true),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isTotal = false}) {
//     final textStyle = isTotal
//         ? AppTheme.headingStyle
//         : Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 16);

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: textStyle),
//         Text(value, style: textStyle),
//       ],
//     );
//   }
// }








































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/animated_form_field.dart';
import 'package:rolo/core/widgets/autocomplete_field.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/order/presentation/view/payment_method_view.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_event.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_state.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_viemodel.dart';

const double kOrderFormTabletBreakpoint = 700.0;

class OrderFormPage extends StatelessWidget {
  const OrderFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<OrderViewModel>(param1: serviceLocator<CartViewModel>(),)..add(OrderLoadInitialData()),
      child: const _OrderFormView(),
    );
  }
}

class _OrderFormView extends StatefulWidget {
  const _OrderFormView();

  @override
  State<_OrderFormView> createState() => _OrderFormViewState();
}

class _OrderFormViewState extends State<_OrderFormView> {
  final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'postalCode': TextEditingController(),
    'notes': TextEditingController(),
    'country': TextEditingController(text: 'Nepal'),
  };

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void _onFieldChange() {
    context.read<OrderViewModel>().add(OrderFormFieldChanged(
      firstName: _controllers['firstName']!.text,
      lastName: _controllers['lastName']!.text,
      email: _controllers['email']!.text,
      phone: _controllers['phone']!.text,
      address: _controllers['address']!.text,
      postalCode: _controllers['postalCode']!.text,
      notes: _controllers['notes']!.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartViewModel>().state;
    final cart = cartState.cart;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Shipping Information'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<OrderViewModel, OrderState>(
        listener: (context, state) {
          if (state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.actionMessage!), backgroundColor: Colors.orange),
            );
          }
          if (state.status != OrderStatus.noNetwork) {
            _controllers['firstName']!.text = state.shippingAddress.firstName;
            _controllers['lastName']!.text = state.shippingAddress.lastName;
            _controllers['email']!.text = state.shippingAddress.email;
            _controllers['phone']!.text = state.shippingAddress.phone;
            _controllers['address']!.text = state.shippingAddress.address;
            _controllers['postalCode']!.text = state.shippingAddress.postalCode;
            _controllers['notes']!.text = state.shippingAddress.notes;
          }
          if (state.status == OrderStatus.readyForPayment) {
            if (state.userId == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Could not verify user. Please restart.'),
                backgroundColor: Colors.red,
              ));
              return;
            }
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PaymentMethodView(
                  cart: cart,
                  address: state.shippingAddress,
                  deliveryFee: state.shippingFee,
                  userId: state.userId!,
                ),
              ),
            );
          }
          if (state.status == OrderStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ));
          }
        },
        child: BlocBuilder<OrderViewModel, OrderState>(
          builder: (context, state) {
            if (state.status == OrderStatus.loading || state.status == OrderStatus.initial) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
            }
            if (state.status == OrderStatus.noNetwork) {
              return _buildOfflineView(context);
            }
            if (state.status == OrderStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'Failed to load data'));
            }
            final total = cart.subtotal + state.shippingFee;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > kOrderFormTabletBreakpoint) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: SingleChildScrollView(child: _buildFormSection(context, state))),
                      Expanded(flex: 2, child: SingleChildScrollView(child: _buildOrderSummary(context, state, cart, total))),
                    ],
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFormSection(context, state),
                      _buildOrderSummary(context, state, cart, total),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // FIX: Added the 'return' keyword here.
  Widget _buildOfflineView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/no_internet_connection.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
            repeat: true,
          ),
          const SizedBox(height: 24),
          Text(
            'No Internet Connection',
            style: AppTheme.subheadingStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Please check your internet connection to continue with your order.',
              style: AppTheme.captionStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<OrderViewModel>().add(OrderLoadInitialData());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, OrderState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: AnimatedFormField(label: 'First Name', controller: _controllers['firstName']!, isRequired: true, onChanged: (_) => _onFieldChange())),
            const SizedBox(width: 16),
            Expanded(child: AnimatedFormField(label: 'Last Name', controller: _controllers['lastName']!, isRequired: true, onChanged: (_) => _onFieldChange())),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: AnimatedFormField(label: 'Email', controller: _controllers['email']!, isRequired: true, keyboardType: TextInputType.emailAddress, onChanged: (_) => _onFieldChange())),
            const SizedBox(width: 16),
            Expanded(child: AnimatedFormField(label: 'Phone', controller: _controllers['phone']!, isRequired: true, keyboardType: TextInputType.phone, onChanged: (_) => _onFieldChange())),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: AutocompleteField(
                label: 'District',
                value: state.shippingAddress.district,
                suggestions: state.availableDistricts,
                isRequired: true,
                onSelected: (value) => context.read<OrderViewModel>().add(OrderDistrictSelected(value)),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AutocompleteField(
                label: 'City / Branch',
                value: state.shippingAddress.city,
                suggestions: state.availableCities,
                isRequired: true,
                enabled: state.shippingAddress.district.isNotEmpty,
                onSelected: (value) => context.read<OrderViewModel>().add(OrderCitySelected(value)),
                onChanged: (value) {},
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: AnimatedFormField(label: 'Country', controller: _controllers['country']!, isRequired: true, enabled: false),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedFormField(
                label: 'Postal Code (Optional)',
                controller: _controllers['postalCode']!,
                keyboardType: TextInputType.number,
                isRequired: false,
                onChanged: (_) => _onFieldChange(),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          AnimatedFormField(label: 'Street Address', controller: _controllers['address']!, isRequired: true, onChanged: (_) => _onFieldChange()),
          const SizedBox(height: 20),
          AnimatedFormField(label: 'Order Notes (Optional)', controller: _controllers['notes']!, maxLines: 3, onChanged: (_) => _onFieldChange()),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (state.shippingFee > 0 && state.status != OrderStatus.proceedingToPayment)
                  ? () => context.read<OrderViewModel>().add(ProceedToPayment())
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.status == OrderStatus.proceedingToPayment
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Continue to Payment'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderState state, CartEntity cart, double total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Text('Order Summary', style: AppTheme.subheadingStyle),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(width: 50, child: Image.network(item.product.imageUrl)),
                title: Text(item.product.name),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: Text('Rs ${item.product.price * item.quantity}'),
              );
            },
          ),
          const Divider(thickness: 1, indent: 20, endIndent: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                _buildSummaryRow(context, 'Subtotal', 'Rs ${cart.subtotal}'),
                _buildSummaryRow(context, 'Shipping Fee', 'Rs ${state.shippingFee}'),
                const SizedBox(height: 12),
                _buildSummaryRow(context, 'Total', 'Rs $total', isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    final textStyle = isTotal
        ? AppTheme.headingStyle
        : Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}