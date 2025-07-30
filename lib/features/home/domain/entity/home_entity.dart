import 'package:equatable/equatable.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/home/domain/entity/home_section_entity.dart'; 
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class HomeEntity extends Equatable {
  final List<CategoryEntity> categories;
  final List<ProductEntity> featuredProducts;
  final List<HomeSectionEntity> ribbonSections; 

  const HomeEntity({
    required this.categories,
    required this.featuredProducts,
    required this.ribbonSections,
  });

  @override
  List<Object?> get props => [categories, featuredProducts, ribbonSections];
}