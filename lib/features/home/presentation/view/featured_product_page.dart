// import 'package:flutter/material.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/product_card.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';

// class FeaturedProductsPage extends StatelessWidget {
//   final List<ProductEntity> products;

//   const FeaturedProductsPage({
//     super.key,
//     required this.products,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Featured Products'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       backgroundColor: AppTheme.backgroundColor,
//       body: products.isEmpty
//           ? Center(child: Text('No featured products available', style: AppTheme.bodyStyle))
//           : GridView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: products.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,         
//                 crossAxisSpacing: 16,    
//                 mainAxisSpacing: 16,     
//                 childAspectRatio: 0.65,    
//               ),
//               itemBuilder: (context, index) {
//                 return ProductCard(product: products[index]);
//               },
//             ),
//     );
//   }
// }






























import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class FeaturedProductsPage extends StatelessWidget {
  final List<ProductEntity> products;

  const FeaturedProductsPage({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Products'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeViewModel>().add(const LoadHomeData(isRefresh: true));
        },
        child: products.isEmpty
            ? _buildEmptyState()
            : AnimationLimiter(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: (MediaQuery.of(context).size.width / 220).floor(),
                      child: ScaleAnimation(
                        curve: Curves.easeOutCubic,
                        child: FadeInAnimation(
                          child: ProductCard(product: products[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Featured Products', style: AppTheme.subheadingStyle),
          Text('Check back later for our top picks!', style: AppTheme.bodyStyle),
        ],
      ),
    );
  }
}