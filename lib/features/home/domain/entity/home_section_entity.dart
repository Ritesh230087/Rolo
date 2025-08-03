import 'package:equatable/equatable.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/ribbon/domain/entity/ribbon_entity.dart';

class HomeSectionEntity extends Equatable {
  final RibbonEntity ribbon;
  final List<ProductEntity> products;

  const HomeSectionEntity({required this.ribbon, required this.products});

  @override
  List<Object?> get props => [ribbon, products];
  HomeSectionEntity copyWith({
    RibbonEntity? ribbon,
    List<ProductEntity>? products,
  }) {
    return HomeSectionEntity(
      ribbon: ribbon ?? this.ribbon,
      products: products ?? this.products,
    );
  }
}