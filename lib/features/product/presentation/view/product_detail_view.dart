// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/features/cart/presentation/view/cart_view.dart';
// import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_event.dart';
// import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_state.dart';
// import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_viewmodel.dart';
// import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
// import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';
// import 'package:rolo/app/themes/themes_data.dart';

// class ProductDetailPage extends StatelessWidget {
//   final String productId;
//   const ProductDetailPage({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => serviceLocator<ProductDetailViewModel>(
//         param1: context.read<CartViewModel>(),
//       )..add(ProductDetailFetchData(productId)),
//       child: const _ProductDetailView(),
//     );
//   }
// }

// class _ProductDetailView extends StatefulWidget {
//   const _ProductDetailView();

//   @override
//   State<_ProductDetailView> createState() => _ProductDetailViewState();
// }

// class _ProductDetailViewState extends State<_ProductDetailView>
//     with TickerProviderStateMixin {
//   late AnimationController _contentAnimationController;
//   late final AnimationController _cartAnimationController;
//   bool _showConfirmationBar = false;

//   @override
//   void initState() {
//     super.initState();
//     _contentAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _cartAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4), 
//     );
//   }

//   @override
//   void dispose() {
//     _contentAnimationController.dispose();
//     _cartAnimationController.dispose();
//     super.dispose();
//   }

//   void _showCartAnimation() {
//     final OverlayEntry overlayEntry = OverlayEntry(
//       builder: (context) => Material(
//         color: Colors.black54,
//         child: Center(
//           child: Lottie.asset(
//             'assets/animations/shopping cart.json',
//             controller: _cartAnimationController,
//             onLoaded: (composition) {
//               _cartAnimationController
//                 ..duration = composition.duration
//                 ..forward();
//             },
//             delegates: LottieDelegates(
//               values: [
//                 ValueDelegate.color(const ['**', 'Manubrio', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'carretilla', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'caja', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'caja2', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'caja 3', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'caja 4', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'caja 5', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'Llanta 1', '**'], value: const Color(0xFFD4AF37)),
//                 ValueDelegate.color(const ['**', 'Llanta 2', '**'], value: const Color(0xFFD4AF37)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(overlayEntry);

//     void listener(AnimationStatus status) {
//       if (status == AnimationStatus.completed) {
//         overlayEntry.remove();
//         _cartAnimationController.reset();
//         _cartAnimationController.removeStatusListener(listener); 
//         if (mounted) {
//           setState(() => _showConfirmationBar = true);
//           Future.delayed(const Duration(seconds: 4), () {
//             if (mounted) setState(() => _showConfirmationBar = false);
//           });
//         }
//       }
//     }

//     _cartAnimationController.addStatusListener(listener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: Stack(
//         children: [
//           BlocConsumer<ProductDetailViewModel, ProductDetailState>(
//             listener: (context, state) {
//               if (state.status == ProductDetailStatus.success) {
//                 _contentAnimationController.forward();
//               }
//             },
//             builder: (context, state) {
//               if (state.status == ProductDetailStatus.loading ||
//                   state.status == ProductDetailStatus.initial) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: AppTheme.primaryColor));
//               }
//               if (state.status == ProductDetailStatus.error) {
//                 return Center(
//                     child: Text(state.errorMessage ?? 'An error occurred',
//                         style: AppTheme.bodyStyle));
//               }
//               if (state.status == ProductDetailStatus.success &&
//                   state.product != null) {
//                 return _buildContent(context, state);
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             bottom: _showConfirmationBar ? 0 : -100, 
//             left: 0,
//             right: 0,
//             child: Container(
//               color: Colors.green[600],
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Product added to cart",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold)),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => const CartView()),
//                       );
//                     },
//                     child: const Text("GO TO CART",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar:
//           BlocBuilder<ProductDetailViewModel, ProductDetailState>(
//         builder: (context, state) {
//           return state.status == ProductDetailStatus.success
//               ? _buildBottomActionBar(context, state)
//               : const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildContent(BuildContext context, ProductDetailState state) {
//     final bool isOutOfStock = state.product!.quantity == 0;

//     return CustomScrollView(
//       slivers: [
//         _buildSliverAppBar(context, state),
//         SliverToBoxAdapter(
//           child: FadeTransition(
//             opacity: CurvedAnimation(
//               parent: _contentAnimationController,
//               curve: Curves.easeOutCubic,
//             ),
//             child: SlideTransition(
//               position: Tween<Offset>(
//                       begin: const Offset(0, 0.1), end: Offset.zero)
//                   .animate(CurvedAnimation(
//                       parent: _contentAnimationController,
//                       curve: Curves.easeOutCubic)),
//               child: AnimationLimiter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: AnimationConfiguration.toStaggeredList(
//                     duration: const Duration(milliseconds: 400),
//                     childAnimationBuilder: (widget) => SlideAnimation(
//                       verticalOffset: 50.0,
//                       child: FadeInAnimation(child: widget),
//                     ),
//                     children: [
//                       _buildProductInfoBox(context, state, isOutOfStock),
//                       _buildDescriptionSection(context, state),
//                       if (!isOutOfStock) _buildQuantitySection(context, state),
//                       if (state.product!.features.isNotEmpty)
//                         _buildKeyFeatures(context, state),
//                       if (_hasSpecifications(state))
//                         _buildSpecifications(context, state),
//                       const SizedBox(height: 120),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
  
//   bool _hasSpecifications(ProductDetailState state) {
//     final product = state.product!;
//     return product.material.isNotEmpty ||
//         product.origin.isNotEmpty ||
//         product.care.isNotEmpty ||
//         product.warranty.isNotEmpty;
//   }

//   Widget _buildSliverAppBar(BuildContext context, ProductDetailState state) {
//     return SliverAppBar(
//       expandedHeight: MediaQuery.of(context).size.width,
//       pinned: true,
//       stretch: true,
//       backgroundColor: AppTheme.cardColor,
//       leading: _buildAppBarButton(
//         context,
//         icon: Icons.arrow_back,
//         onPressed: () => Navigator.pop(context),
//       ),
//       actions: [
//         if (state.product!.ribbonId != null &&
//             state.product!.ribbonId!.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Center(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text(
//                   'LIMITED',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         stretchModes: const [StretchMode.zoomBackground],
//         background: _buildImageGallery(context, state),
//       ),
//     );
//   }

//   Widget _buildImageGallery(BuildContext context, ProductDetailState state) {
//     return Stack(
//       children: [
//         PageView.builder(
//           itemCount: state.allImages.length,
//           onPageChanged: (index) {
//             context
//                 .read<ProductDetailViewModel>()
//                 .add(ProductDetailImageChanged(index));
//           },
//           itemBuilder: (context, index) {
//             return Container(
//               color: Colors.black,
//               child: Image.network(
//                 state.allImages[index],
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => const Icon(
//                   Icons.image_not_supported,
//                   color: Colors.grey,
//                   size: 50,
//                 ),
//               ),
//             );
//           },
//         ),
//         if (state.allImages.length > 1)
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: state.allImages.asMap().entries.map((entry) {
//                 final isSelected = state.selectedImageIndex == entry.key;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: isSelected ? 24.0 : 8.0,
//                   height: 8.0,
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: isSelected
//                         ? AppTheme.primaryColor
//                         : Colors.white.withOpacity(0.5),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildAppBarButton(BuildContext context,
//       {required IconData icon, required VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: Icon(icon, color: Colors.white),
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfoBox(
//       BuildContext context, ProductDetailState state, bool isOutOfStock) {
//     final product = state.product!;
//     final bool hasDiscount = product.originalPrice > product.price;
//     final Color discountColor = isOutOfStock ? Colors.red : Colors.green;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(product.name,
//               style: AppTheme.headingStyle.copyWith(fontSize: 22)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text('NPR ${product.price.toStringAsFixed(0)}',
//                   style: const TextStyle(
//                       color: AppTheme.primaryColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20)),
//               const SizedBox(width: 12),
//               if (hasDiscount)
//                 Text(
//                     '${product.discountPercent}% OFF',
//                     style: TextStyle(
//                         color: discountColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           if (product.youSave != null && product.youSave! > 0)
//             Text('You Save: NPR ${product.youSave!.toStringAsFixed(0)}',
//                 style: TextStyle(color: discountColor, fontSize: 14)), 
          
//           Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: Text(
//               isOutOfStock 
//                 ? 'Out of Stock' 
//                 : 'Available Quantity: ${product.quantity}',
//               style: TextStyle(
//                 color: isOutOfStock ? Colors.red : Colors.green, 
//                 fontSize: 14
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescriptionSection(
//       BuildContext context, ProductDetailState state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Description', style: AppTheme.subheadingStyle),
//           const SizedBox(height: 8),
//           Text(
//             state.product!.description,
//             style:
//                 AppTheme.bodyStyle.copyWith(color: Colors.grey[400], height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildQuantitySection(BuildContext context, ProductDetailState state) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: AppTheme.cardColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Quantity', style: AppTheme.subheadingStyle),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppTheme.backgroundColor,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon:
//                         const Icon(Icons.remove, color: Colors.red, size: 16),
//                     onPressed: () => context
//                         .read<ProductDetailViewModel>()
//                         .add(ProductDetailQuantityChanged(state.quantity - 1)),
//                   ),
//                   Text('${state.quantity}',
//                       style: AppTheme.bodyStyle
//                           .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
//                   IconButton(
//                     icon: const Icon(Icons.add,
//                         color: AppTheme.primaryColor, size: 16),
//                     onPressed: state.quantity < state.product!.quantity
//                         ? () => context
//                             .read<ProductDetailViewModel>()
//                             .add(ProductDetailQuantityChanged(state.quantity + 1))
//                         : null,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildKeyFeatures(BuildContext context, ProductDetailState state) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('KEY FEATURES', style: AppTheme.subheadingStyle),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             children: state.product!.features.map((feature) {
//               return Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppTheme.cardColor,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey[800]!),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.check,
//                         color: AppTheme.primaryColor, size: 16),
//                     const SizedBox(width: 8),
//                     Text(feature, style: AppTheme.bodyStyle),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSpecifications(BuildContext context, ProductDetailState state) {
//     final product = state.product!;
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//             color: AppTheme.cardColor,
//             borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('SPECIFICATIONS', style: AppTheme.subheadingStyle),
//             const Divider(height: 24, color: Color(0xFF333333)),
//             if (product.material.isNotEmpty)
//               _buildSpecRow('Material', product.material),
//             if (product.origin.isNotEmpty)
//               _buildSpecRow('Origin', product.origin),
//             if (product.care.isNotEmpty) _buildSpecRow('Care', product.care),
//             if (product.warranty.isNotEmpty)
//               _buildSpecRow('Warranty', product.warranty),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSpecRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//               width: 80, child: Text('$label:', style: AppTheme.captionStyle)),
//           const SizedBox(width: 8),
//           Expanded(child: Text(value, style: AppTheme.bodyStyle)),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomActionBar(
//       BuildContext context, ProductDetailState state) {
//     final bool isOutOfStock = state.product!.quantity == 0;
    
//     final addToCartStyle = ElevatedButton.styleFrom(
//       foregroundColor: isOutOfStock ? Colors.red : AppTheme.primaryColor,
//       backgroundColor: AppTheme.backgroundColor,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       disabledForegroundColor: Colors.red.withOpacity(0.5),
//       disabledBackgroundColor: AppTheme.backgroundColor.withOpacity(0.5),
//     );

//     final buyNowStyle = ElevatedButton.styleFrom(
//       foregroundColor: Colors.black,
//       backgroundColor: isOutOfStock ? Colors.red : AppTheme.primaryColor,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       disabledForegroundColor: Colors.white.withOpacity(0.7),
//       disabledBackgroundColor: Colors.red.withOpacity(0.5),
//     );

//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.shopping_cart_outlined),
//               label: const Text('Add to Cart'),
//               style: addToCartStyle,
//               onPressed: !isOutOfStock
//                   ? () {
//                       final cartViewModel = context.read<CartViewModel>();
//                       final product = state.product!;

//                       cartViewModel.add(
//                           AddItemToCart(product, quantity: state.quantity));
//                       context.read<ProductDetailViewModel>().add(
//                             ProductDetailUpdateAvailableQuantity(state.quantity),
//                           );
                      
//                       _showCartAnimation();
//                     }
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.flash_on),
//               label: const Text('Buy Now'),
//               style: buyNowStyle,
//               onPressed: !isOutOfStock
//                   ? () => context
//                       .read<ProductDetailViewModel>()
//                       .add(ProductDetailBuyNow())
//                   : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
































































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/features/cart/presentation/view/cart_view.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_event.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_state.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:shimmer/shimmer.dart';

/// The screen width in pixels above which the tablet layout will be used.
const double kTabletBreakpoint = 600.0;

class ProductDetailPage extends StatelessWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProductDetailViewModel>(
        param1: context.read<CartViewModel>(),
      )..add(ProductDetailFetchData(productId)),
      child: _ProductDetailView(productId: productId),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  final String productId;
  const _ProductDetailView({required this.productId});

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView>
    with TickerProviderStateMixin {
  late AnimationController _contentAnimationController;
  late final AnimationController _cartAnimationController;
  bool _showConfirmationBar = false;

  @override
  void initState() {
    super.initState();
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    );
  }

  @override
  void dispose() {
    _contentAnimationController.dispose();
    _cartAnimationController.dispose();
    super.dispose();
  }

  void _showCartAnimation() {
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Lottie.asset(
            'assets/animations/shopping cart.json',
            controller: _cartAnimationController,
            onLoaded: (composition) {
              _cartAnimationController
                ..duration = composition.duration
                ..forward();
            },
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(const ['**', 'Manubrio', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'carretilla', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'caja', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'caja2', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'caja 3', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'caja 4', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'caja 5', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'Llanta 1', '**'], value: const Color(0xFFD4AF37)),
                ValueDelegate.color(const ['**', 'Llanta 2', '**'], value: const Color(0xFFD4AF37)),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        overlayEntry.remove();
        _cartAnimationController.reset();
        _cartAnimationController.removeStatusListener(listener); 
        if (mounted) {
          setState(() => _showConfirmationBar = true);
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) setState(() => _showConfirmationBar = false);
          });
        }
      }
    }
    _cartAnimationController.addStatusListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          BlocConsumer<ProductDetailViewModel, ProductDetailState>(
            listener: (context, state) {
              if (state.status == ProductDetailStatus.success && !_contentAnimationController.isCompleted) {
                _contentAnimationController.forward();
              }
            },
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth > kTabletBreakpoint;

                  switch (state.status) {
                    case ProductDetailStatus.loading:
                    case ProductDetailStatus.initial:
                      return isTablet ? const _TabletShimmer() : const _PhoneShimmer();

                    case ProductDetailStatus.error:
                      return _ProductError(
                        message: state.errorMessage ?? 'An unknown error occurred.',
                        onRetry: () {
                          context.read<ProductDetailViewModel>().add(ProductDetailFetchData(widget.productId));
                        },
                      );
                      
                    case ProductDetailStatus.success:
                      if (state.product != null) {
                        return isTablet 
                          ? _buildTabletLayout(context, state) 
                          : _buildPhoneLayout(context, state);
                      }
                      return const Center(child: Text("Product not found."));
                  }
                },
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showConfirmationBar ? 0 : -100, 
            left: 0,
            right: 0,
            child: Container(
              color: Colors.green[600],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Product added to cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartView()));
                    },
                    child: const Text("GO TO CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Renders the two-column layout for tablets and wide screens.
  Widget _buildTabletLayout(BuildContext context, ProductDetailState state) {
    return Column(
      children: [
        AppBar(
          leading: _buildAppBarButton(context, icon: Icons.arrow_back, onPressed: () => Navigator.pop(context)),
          backgroundColor: AppTheme.cardColor,
          elevation: 1,
          title: Text(state.product!.name, style: AppTheme.headingStyle.copyWith(fontSize: 18)),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildImageGallery(context, state),
                ),
              ),
              Expanded(
                flex: 2,
                child: Scaffold(
                  backgroundColor: AppTheme.backgroundColor,
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildProductDetailsColumn(context, state),
                  ),
                  bottomNavigationBar: _buildBottomActionBar(context, state),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Renders the single-column, scrollable layout for phones.
  Widget _buildPhoneLayout(BuildContext context, ProductDetailState state) {
    return Scaffold(
         backgroundColor: AppTheme.backgroundColor,
         body: RefreshIndicator(
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.cardColor,
            onRefresh: () async {
              context.read<ProductDetailViewModel>().add(ProductDetailFetchData(widget.productId));
            },
            child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, state),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _contentAnimationController, curve: Curves.easeOutCubic),
                  child: SlideTransition(
                     position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _contentAnimationController, curve: Curves.easeOutCubic)),
                    child: _buildProductDetailsColumn(context, state),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomActionBar(context, state),
      );
  }

  // A shared column of product details, used by both phone and tablet layouts.
  Widget _buildProductDetailsColumn(BuildContext context, ProductDetailState state) {
    final bool isOutOfStock = state.product!.quantity == 0;
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildProductInfoBox(context, state, isOutOfStock),
            _buildDescriptionSection(context, state),
            if (!isOutOfStock) _buildQuantitySection(context, state),
            if (state.product!.features.isNotEmpty) _buildKeyFeatures(context, state),
            if (_hasSpecifications(state)) _buildSpecifications(context, state),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  bool _hasSpecifications(ProductDetailState state) {
    final product = state.product!;
    return product.material.isNotEmpty || product.origin.isNotEmpty || product.care.isNotEmpty || product.warranty.isNotEmpty;
  }

  Widget _buildSliverAppBar(BuildContext context, ProductDetailState state) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.cardColor,
      leading: _buildAppBarButton(context, icon: Icons.arrow_back, onPressed: () => Navigator.pop(context)),
      actions: [
        if (state.product!.ribbonId != null && state.product!.ribbonId!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(8)),
                child: const Text('LIMITED', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: _buildImageGallery(context, state),
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, ProductDetailState state) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: state.allImages.length,
          onPageChanged: (index) => context.read<ProductDetailViewModel>().add(ProductDetailImageChanged(index)),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.black,
              child: Image.network(
                state.allImages[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
              ),
            );
          },
        ),
        if (state.allImages.length > 1)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.allImages.asMap().entries.map((entry) {
                final isSelected = state.selectedImageIndex == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isSelected ? AppTheme.primaryColor : Colors.white.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAppBarButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
        child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
      ),
    );
  }

  Widget _buildProductInfoBox(BuildContext context, ProductDetailState state, bool isOutOfStock) {
    final product = state.product!;
    final bool hasDiscount = product.originalPrice > product.price;
    final Color discountColor = isOutOfStock ? Colors.red.shade400 : Colors.green.shade400;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: AppTheme.headingStyle.copyWith(fontSize: 22)),
          const SizedBox(height: 12),
          Row(children: [
            Text('NPR ${product.price.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(width: 12),
            if (hasDiscount)
              Text('${product.discountPercent}% OFF', style: TextStyle(color: discountColor, fontWeight: FontWeight.bold, fontSize: 14)),
          ]),
          const SizedBox(height: 8),
          if (product.youSave != null && product.youSave! > 0)
            Text('You Save: NPR ${product.youSave!.toStringAsFixed(0)}', style: TextStyle(color: discountColor, fontSize: 14)), 
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              isOutOfStock ? 'Out of Stock' : 'Available Quantity: ${product.quantity}',
              style: TextStyle(color: isOutOfStock ? Colors.red.shade400 : Colors.green.shade400, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ProductDetailState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Description', style: AppTheme.subheadingStyle),
        const SizedBox(height: 8),
        Text(state.product!.description, style: AppTheme.bodyStyle.copyWith(color: Colors.grey[400], height: 1.5)),
      ]),
    );
  }
  
  Widget _buildQuantitySection(BuildContext context, ProductDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quantity', style: AppTheme.subheadingStyle),
          Container(
            decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.red, size: 16),
                onPressed: () => context.read<ProductDetailViewModel>().add(ProductDetailQuantityChanged(state.quantity - 1)),
              ),
              Text('${state.quantity}', style: AppTheme.bodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add, color: AppTheme.primaryColor, size: 16),
                onPressed: state.quantity < state.product!.quantity
                    ? () => context.read<ProductDetailViewModel>().add(ProductDetailQuantityChanged(state.quantity + 1))
                    : null,
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildKeyFeatures(BuildContext context, ProductDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('KEY FEATURES', style: AppTheme.subheadingStyle),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: state.product!.features.map((feature) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[800]!)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(feature, style: AppTheme.bodyStyle),
            ]),
          );
        }).toList()),
      ]),
    );
  }

  Widget _buildSpecifications(BuildContext context, ProductDetailState state) {
    final product = state.product!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SPECIFICATIONS', style: AppTheme.subheadingStyle),
          const Divider(height: 24, color: Color(0xFF333333)),
          if (product.material.isNotEmpty) _buildSpecRow('Material', product.material),
          if (product.origin.isNotEmpty) _buildSpecRow('Origin', product.origin),
          if (product.care.isNotEmpty) _buildSpecRow('Care', product.care),
          if (product.warranty.isNotEmpty) _buildSpecRow('Warranty', product.warranty),
        ]),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 80, child: Text('$label:', style: AppTheme.captionStyle)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: AppTheme.bodyStyle)),
      ]),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ProductDetailState state) {
    final bool isOutOfStock = state.isOutOfStock;
    final addToCartStyle = ElevatedButton.styleFrom(
      foregroundColor: isOutOfStock ? Colors.grey : AppTheme.primaryColor,
      backgroundColor: AppTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final buyNowStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: isOutOfStock ? Colors.grey : AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(color: AppTheme.cardColor, border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1))),
      child: Row(children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
            style: addToCartStyle,
            onPressed: !isOutOfStock ? () {
              context.read<CartViewModel>().add(AddItemToCart(state.product!, quantity: state.quantity));
              context.read<ProductDetailViewModel>().add(ProductDetailUpdateAvailableQuantity(state.quantity));
              _showCartAnimation();
            } : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.flash_on),
            label: const Text('Buy Now'),
            style: buyNowStyle,
            onPressed: !isOutOfStock ? () => print('Buying now...') : null,
          ),
        ),
      ]),
    );
  }
}

class _PhoneShimmer extends StatelessWidget {
  const _PhoneShimmer();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardColor,
      highlightColor: const Color(0xFF444444),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: MediaQuery.of(context).size.width, width: double.infinity, color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 30, width: double.infinity, color: Colors.black, margin: const EdgeInsets.only(bottom: 12)),
              Container(height: 24, width: 200, color: Colors.black, margin: const EdgeInsets.only(bottom: 16)),
              Container(height: 100, width: double.infinity, color: Colors.black, margin: const EdgeInsets.only(bottom: 24)),
              Container(height: 24, width: 150, color: Colors.black, margin: const EdgeInsets.only(bottom: 12)),
              Container(height: 60, width: double.infinity, color: Colors.black),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TabletShimmer extends StatelessWidget {
  const _TabletShimmer();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(backgroundColor: AppTheme.cardColor, elevation: 1),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: AppTheme.cardColor,
            highlightColor: const Color(0xFF444444),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: Padding(padding: const EdgeInsets.all(24.0), child: Container(width: double.infinity, height: double.infinity, color: Colors.black))),
              Expanded(flex: 2, child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 30, width: double.infinity, color: Colors.black, margin: const EdgeInsets.only(bottom: 12)),
                    Container(height: 24, width: 200, color: Colors.black, margin: const EdgeInsets.only(bottom: 16)),
                    Container(height: 100, width: double.infinity, color: Colors.black, margin: const EdgeInsets.only(bottom: 24)),
                    Container(height: 24, width: 150, color: Colors.black, margin: const EdgeInsets.only(bottom: 12)),
                    Container(height: 60, width: double.infinity, color: Colors.black),
                    const Spacer(),
                    Container(height: 50, width: double.infinity, color: Colors.black)
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProductError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ProductError({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.grey, size: 80),
          const SizedBox(height: 20),
          Text('Failed to Load Product', style: AppTheme.headingStyle.copyWith(fontSize: 20), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(message, style: AppTheme.bodyStyle.copyWith(color: Colors.grey[400]), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)
            ),
          )
        ]),
      ),
    );
  }
}