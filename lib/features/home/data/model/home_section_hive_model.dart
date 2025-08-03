import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/home/data/model/ribbon_hive_model.dart';
import 'package:rolo/features/home/domain/entity/home_section_entity.dart';
import 'package:rolo/features/product/data/model/product_hive_model.dart';

part 'home_section_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.homeSectionTableId)
class HomeSectionHiveModel extends HiveObject {
  @HiveField(0)
  late RibbonHiveModel ribbon;

  @HiveField(1)
  late List<ProductHiveModel> products;

  HomeSectionHiveModel();

  HomeSectionHiveModel.fromEntity(HomeSectionEntity entity) {
    ribbon = RibbonHiveModel.fromEntity(entity.ribbon);
    products = entity.products.map((p) => ProductHiveModel.fromEntity(p)).toList();
  }

  HomeSectionEntity toEntity() {
    return HomeSectionEntity(
      ribbon: ribbon.toEntity(),
      products: products.map((p) => p.toEntity()).toList(),
    );
  }
}