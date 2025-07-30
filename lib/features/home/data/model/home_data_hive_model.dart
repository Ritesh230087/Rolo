import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/home/data/model/category_hive_model.dart';
import 'package:rolo/features/home/data/model/home_section_hive_model.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/product/data/model/product_hive_model.dart';

part 'home_data_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.homeDataTableId)
class HomeDataHiveModel extends HiveObject {
  @HiveField(0)
  late List<CategoryHiveModel> categories;

  @HiveField(1)
  late List<ProductHiveModel> featuredProducts;

  @HiveField(2)
  late List<HomeSectionHiveModel> ribbonSections;

  HomeDataHiveModel();

  HomeDataHiveModel.fromEntity(HomeEntity entity) {
    categories = entity.categories.map((c) => CategoryHiveModel.fromEntity(c)).toList();
    featuredProducts = entity.featuredProducts.map((p) => ProductHiveModel.fromEntity(p)).toList();
    ribbonSections = entity.ribbonSections.map((s) => HomeSectionHiveModel.fromEntity(s)).toList();
  }

  HomeEntity toEntity() {
    return HomeEntity(
      categories: categories.map((c) => c.toEntity()).toList(),
      featuredProducts: featuredProducts.map((p) => p.toEntity()).toList(),
      ribbonSections: ribbonSections.map((s) => s.toEntity()).toList(),
    );
  }
}