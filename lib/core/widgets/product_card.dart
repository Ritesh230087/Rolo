// import 'package:flutter/material.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';
// import 'package:rolo/features/product/presentation/view/product_detail_view.dart';

// class ProductCard extends StatelessWidget {
//   final ProductEntity product;

//   const ProductCard({
//     super.key,
//     required this.product,
//   });

//   @override
//   Widget build(BuildContext context) {
//     void _navigateToDetail() {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProductDetailPage(productId: product.id),
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: _navigateToDetail,
//       child: Container(
//         width: 180,
//         decoration: BoxDecoration(
//           color: AppTheme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.backgroundColor.withOpacity(0.5),
//               blurRadius: 8,
//               offset: const Offset(4, 4),
//             ),
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               children: [
//                 SizedBox(
//                   height: 160,
//                   width: double.infinity,
//                   child: Image.network(
//                     product.imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => const Center(
//                       child: Icon(Icons.image_not_supported,
//                           size: 50, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 if (product.discountPercent != null && product.discountPercent! > 0)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppTheme.primaryColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         '${product.discountPercent}% OFF',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Flexible(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       product.name,
//                       style: AppTheme.bodyStyle
//                           .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         // --- Price Column ---
//                         Flexible(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 'NPR ${product.price.toStringAsFixed(0)}',
//                                 style: const TextStyle(
//                                     color: AppTheme.primaryColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16),
//                               ),
//                               if (product.youSave != null && product.youSave! > 0)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 2.0),
//                                   child: Text(
//                                     'NPR ${product.originalPrice.toStringAsFixed(0)}',
//                                     style: AppTheme.captionStyle.copyWith(
//                                       decoration: TextDecoration.lineThrough,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: AppTheme.primaryColor,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: IconButton(
//                             icon: const Icon(Icons.add,
//                                 size: 16, color: Colors.black),
//                             onPressed: () {
//                               // Cart Logic
//                             },
//                             padding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }














































import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/services/cart_animation_service.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_event.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/product/presentation/view/product_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final GlobalKey itemKey = GlobalKey();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(productId: product.id),
          ),
        );
      },
      child: Card(
        key: itemKey,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                  if (product.discountPercent != null && product.discountPercent! > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${product.discountPercent}% OFF',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (product.originalPrice > product.price)
                            Text(
                              'NPR ${product.originalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          // 1. Add item to cart via BLoC
                          context.read<CartViewModel>().add(AddItemToCart(product));

                          // 2. Run the visual animation
                          CartAnimationService.runFlyAnimation(
                            itemKey: itemKey,
                            context: context,
                            imageUrl: product.imageUrl,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 20, color: Colors.white),
                        ),
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
}