import 'package:flutter/material.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class RibbonProductsPage extends StatelessWidget {
  final String ribbonId;
  final String ribbonLabel;
  final List<ProductEntity> products;

  const RibbonProductsPage({
    super.key,
    required this.ribbonId,
    required this.ribbonLabel,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ribbonLabel),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: products.isEmpty
          ? Center(child: Text('No products available', style: AppTheme.bodyStyle))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,     
                crossAxisSpacing: 16,    
                mainAxisSpacing: 16,    
                childAspectRatio: 0.65,    
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
    );
  }
}