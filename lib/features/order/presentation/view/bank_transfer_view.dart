// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
// import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
// import 'package:rolo/features/order/presentation/view/order_fail_view.dart';   
// import 'package:rolo/features/order/presentation/view/order_success_view.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_event.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_state.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_viewmodel.dart';

// class BankTransferView extends StatelessWidget {
//   final CartEntity cart;
//   final ShippingAddressEntity address;
//   final double deliveryFee;
//   final String userId;

//   const BankTransferView({
//     super.key,
//     required this.cart,
//     required this.address,
//     required this.deliveryFee,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => BankTransferViewModel(
//         createOrderWithSlipUseCase: serviceLocator(),
//         cart: cart,
//         shippingAddress: address,
//         deliveryFee: deliveryFee,
//         userId: userId,
//       ),
//       child: BlocListener<BankTransferViewModel, BankTransferState>(
//         listener: (context, state) {
//           if (state.status == BankTransferStatus.error) {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => OrderFailView(
//                   cart: context.read<BankTransferViewModel>().cart,
//                   shippingAddress: context.read<BankTransferViewModel>().shippingAddress,
//                   deliveryFee: context.read<BankTransferViewModel>().deliveryFee,
//                   userId: context.read<BankTransferViewModel>().userId,
//                   errorMessage: state.error,
//                 ),
//               ),
//             );
//           }
//           if (state.status == BankTransferStatus.success && state.createdOrder != null) {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (_) => OrderSuccessView(order: state.createdOrder!),
//               ),
//               (route) => false,
//             );
//           }
//         },
//         child: const BankTransferScreenContent(),
//       ),
//     );
//   }
// }

// class BankTransferScreenContent extends StatelessWidget {
//   const BankTransferScreenContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<BankTransferViewModel>().state;
//     final total = context.read<BankTransferViewModel>().cart.subtotal + context.read<BankTransferViewModel>().deliveryFee;

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Bank Transfer Details'),
//         backgroundColor: AppTheme.backgroundColor,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Step 1: Transfer Payment', style: AppTheme.subheadingStyle),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               color: AppTheme.cardColor,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildBankDetailRow('Bank Name:', 'Nabil Bank Limited'),
//                     _buildBankDetailRow('Account Name:', 'ROLO STORE PVT. LTD.'),
//                     _buildBankDetailRow('Account Number:', '01234567890123'),
//                     _buildBankDetailRow('Transfer Amount:', 'NPR ${total.toStringAsFixed(2)}', isAmount: true),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text('Step 2: Upload Receipt', style: AppTheme.subheadingStyle),
//             const SizedBox(height: 16),
            
//             // --- RESPONSIVE IMAGE CONTAINER FIX ---
//             GestureDetector(
//               onTap: () => context.read<BankTransferViewModel>().add(PickImage()),
//               child: state.pickedImage != null
//                   // If image is picked, show the image in an adaptive container
//                   ? ConstrainedBox(
//                       constraints: const BoxConstraints(
//                         maxHeight: 400, // Prevents very tall images from filling the screen
//                       ),
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(11),
//                           // Use default BoxFit.contain to show the full image without cropping
//                           child: Image.file(state.pickedImage!),
//                         ),
//                       ),
//                     )
//                   // If no image is picked, show the fixed-height upload box
//                   : Container(
//                       height: 200,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: AppTheme.cardColor,
//                         border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.cloud_upload_outlined, size: 50, color: AppTheme.primaryColor),
//                           SizedBox(height: 8),
//                           Text('Tap to upload receipt'),
//                         ],
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: state.status == BankTransferStatus.loading || state.pickedImage == null
//                     ? null
//                     : () => context.read<BankTransferViewModel>().add(SubmitReceipt()),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryColor,
//                   foregroundColor: Colors.black
//                 ),
//                 child: state.status == BankTransferStatus.loading
//                     ? const CircularProgressIndicator(color: Colors.black)
//                     : const Text('Submit & Complete Order'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBankDetailRow(String label, String value, {bool isAmount = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: AppTheme.captionStyle),
//           Text(
//             value,
//             style: AppTheme.bodyStyle.copyWith(
//               fontWeight: FontWeight.bold,
//               color: isAmount ? AppTheme.primaryColor : AppTheme.accentColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















































// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
// import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
// import 'package:rolo/features/order/presentation/view/order_fail_view.dart';   
// import 'package:rolo/features/order/presentation/view/order_success_view.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_event.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_state.dart';
// import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_viewmodel.dart';
// // FIX: Import the cart event and viewmodel
// import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
// import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';

// class BankTransferView extends StatelessWidget {
//   final CartEntity cart;
//   final ShippingAddressEntity address;
//   final double deliveryFee;
//   final String userId;

//   const BankTransferView({
//     super.key,
//     required this.cart,
//     required this.address,
//     required this.deliveryFee,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => BankTransferViewModel(
//         createOrderWithSlipUseCase: serviceLocator(),
//         cart: cart,
//         shippingAddress: address,
//         deliveryFee: deliveryFee,
//         userId: userId,
//       ),
//       child: BlocListener<BankTransferViewModel, BankTransferState>(
//         listener: (context, state) {
//           if (state.status == BankTransferStatus.error) {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => OrderFailView(
//                   cart: context.read<BankTransferViewModel>().cart,
//                   shippingAddress: context.read<BankTransferViewModel>().shippingAddress,
//                   deliveryFee: context.read<BankTransferViewModel>().deliveryFee,
//                   userId: context.read<BankTransferViewModel>().userId,
//                   errorMessage: state.error,
//                 ),
//               ),
//             );
//           }
//           if (state.status == BankTransferStatus.success && state.createdOrder != null) {
//             // --- THIS IS THE FIX for Bank Transfer ---
//             // Before navigating, dispatch the event to clear the cart.
//             context.read<CartViewModel>().add(ClearCart());
//             // ------------------------------------------

//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (_) => OrderSuccessView(order: state.createdOrder!),
//               ),
//               (route) => false,
//             );
//           }
//         },
//         child: const BankTransferScreenContent(),
//       ),
//     );
//   }
// }


// // NO CHANGES ARE NEEDED in the BankTransferScreenContent widget.
// class BankTransferScreenContent extends StatelessWidget {
//   const BankTransferScreenContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<BankTransferViewModel>().state;
//     final total = context.read<BankTransferViewModel>().cart.subtotal + context.read<BankTransferViewModel>().deliveryFee;

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Bank Transfer Details'),
//         backgroundColor: AppTheme.backgroundColor,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Step 1: Transfer Payment', style: AppTheme.subheadingStyle),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               color: AppTheme.cardColor,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildBankDetailRow('Bank Name:', 'Nabil Bank Limited'),
//                     _buildBankDetailRow('Account Name:', 'ROLO STORE PVT. LTD.'),
//                     _buildBankDetailRow('Account Number:', '01234567890123'),
//                     _buildBankDetailRow('Transfer Amount:', 'NPR ${total.toStringAsFixed(2)}', isAmount: true),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text('Step 2: Upload Receipt', style: AppTheme.subheadingStyle),
//             const SizedBox(height: 16),
            
//             GestureDetector(
//               onTap: () => context.read<BankTransferViewModel>().add(PickImage()),
//               child: state.pickedImage != null
//                   ? ConstrainedBox(
//                       constraints: const BoxConstraints(
//                         maxHeight: 400,
//                       ),
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(11),
//                           child: Image.file(state.pickedImage!),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       height: 200,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: AppTheme.cardColor,
//                         border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.cloud_upload_outlined, size: 50, color: AppTheme.primaryColor),
//                           SizedBox(height: 8),
//                           Text('Tap to upload receipt'),
//                         ],
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: state.status == BankTransferStatus.loading || state.pickedImage == null
//                     ? null
//                     : () => context.read<BankTransferViewModel>().add(SubmitReceipt()),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryColor,
//                   foregroundColor: Colors.black
//                 ),
//                 child: state.status == BankTransferStatus.loading
//                     ? const CircularProgressIndicator(color: Colors.black)
//                     : const Text('Submit & Complete Order'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBankDetailRow(String label, String value, {bool isAmount = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: AppTheme.captionStyle),
//           Text(
//             value,
//             style: AppTheme.bodyStyle.copyWith(
//               fontWeight: FontWeight.bold,
//               color: isAmount ? AppTheme.primaryColor : AppTheme.accentColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/cart/domain/entity/cart_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/presentation/view/order_fail_view.dart';   
import 'package:rolo/features/order/presentation/view/order_success_view.dart';
import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_event.dart';
import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_state.dart';
import 'package:rolo/features/order/presentation/view_model/bank_transfer/bank_transfer_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';

class BankTransferView extends StatelessWidget {
  final CartEntity cart;
  final ShippingAddressEntity address;
  final double deliveryFee;
  final String userId;

  const BankTransferView({
    super.key,
    required this.cart,
    required this.address,
    required this.deliveryFee,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankTransferViewModel(
        createOrderWithSlipUseCase: serviceLocator(),
        cart: cart,
        shippingAddress: address,
        deliveryFee: deliveryFee,
        userId: userId,
      ),
      child: BlocListener<BankTransferViewModel, BankTransferState>(
        listener: (context, state) {
          if (state.status == BankTransferStatus.error) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderFailView(
                  cart: context.read<BankTransferViewModel>().cart,
                  shippingAddress: context.read<BankTransferViewModel>().shippingAddress,
                  deliveryFee: context.read<BankTransferViewModel>().deliveryFee,
                  userId: context.read<BankTransferViewModel>().userId,
                  errorMessage: state.error,
                ),
              ),
            );
          }
          if (state.status == BankTransferStatus.success && state.createdOrder != null) {
            context.read<CartViewModel>().add(ClearCart());

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => OrderSuccessView(order: state.createdOrder!),
              ),
              (route) => false,
            );
          }
        },
        child: const BankTransferScreenContent(),
      ),
    );
  }
}

class BankTransferScreenContent extends StatelessWidget {
  const BankTransferScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BankTransferViewModel>().state;
    final total = context.read<BankTransferViewModel>().cart.subtotal + context.read<BankTransferViewModel>().deliveryFee;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Bank Transfer Details'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      // FIX: Wrap the body in a Stack to allow for the loading overlay.
      body: Stack(
        children: [
          // This is the main scrollable content of the page.
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Step 1: Transfer Payment', style: AppTheme.subheadingStyle),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: AppTheme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildBankDetailRow('Bank Name:', 'Nabil Bank Limited'),
                        _buildBankDetailRow('Account Name:', 'ROLO STORE PVT. LTD.'),
                        _buildBankDetailRow('Account Number:', '01234567890123'),
                        _buildBankDetailRow('Transfer Amount:', 'NPR ${total.toStringAsFixed(2)}', isAmount: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Step 2: Upload Receipt', style: AppTheme.subheadingStyle),
                const SizedBox(height: 16),
                
                GestureDetector(
                  onTap: () => context.read<BankTransferViewModel>().add(PickImage()),
                  child: state.pickedImage != null
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.file(state.pickedImage!),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined, size: 50, color: AppTheme.primaryColor),
                              SizedBox(height: 8),
                              Text('Tap to upload receipt'),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.status == BankTransferStatus.loading || state.pickedImage == null
                        ? null
                        : () => context.read<BankTransferViewModel>().add(SubmitReceipt()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.black
                    ),
                    // FIX: The button only shows text now. The loading indicator is in the overlay.
                    child: const Text('Submit & Complete Order'),
                  ),
                ),
              ],
            ),
          ),
          // FIX: This is the loading overlay. It's only visible when submitting.
          if (state.status == BankTransferStatus.loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: _LottieLoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.captionStyle),
          Text(
            value,
            style: AppTheme.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isAmount ? AppTheme.primaryColor : AppTheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LottieLoadingIndicator extends StatelessWidget {
  const _LottieLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/loading.json',
      width: 150,
      height: 150,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(const ['**', 'Shape Layer 1', '**'], value: AppTheme.primaryColor),
          ValueDelegate.color(const ['**', 'Shape Layer 2', '**'], value: AppTheme.primaryColor),
          ValueDelegate.color(const ['**', 'Shape Layer 3', '**'], value: AppTheme.primaryColor),
        ],
      ),
    );
  }
}