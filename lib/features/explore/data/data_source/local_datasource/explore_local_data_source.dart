import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/home/data/model/category_hive_model.dart';
import 'package:rolo/features/product/data/model/product_hive_model.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

abstract interface class IExploreLocalDataSource {
  Future<void> cacheExploreData(List<ProductEntity> products, List<CategoryEntity> categories);
  Future<(List<ProductEntity>?, List<CategoryEntity>?)> getExploreData();
}

class ExploreLocalDataSourceImpl implements IExploreLocalDataSource {
  static const _productsKey = 'all_products';
  static const _categoriesKey = 'all_categories';

  @override
  Future<void> cacheExploreData(List<ProductEntity> products, List<CategoryEntity> categories) async {
    final box = await Hive.openBox(HiveTableConstant.exploreCacheBox);
    final hiveProducts = products.map((p) => ProductHiveModel.fromEntity(p)).toList();
    final hiveCategories = categories.map((c) => CategoryHiveModel.fromEntity(c)).toList();
    
    await box.put(_productsKey, hiveProducts);
    await box.put(_categoriesKey, hiveCategories);
  }

  @override
  Future<(List<ProductEntity>?, List<CategoryEntity>?)> getExploreData() async {
    final box = await Hive.openBox(HiveTableConstant.exploreCacheBox);
    final List<ProductHiveModel>? hiveProducts = (box.get(_productsKey) as List?)?.cast<ProductHiveModel>();
    final List<CategoryHiveModel>? hiveCategories = (box.get(_categoriesKey) as List?)?.cast<CategoryHiveModel>();
    
    final products = hiveProducts?.map((p) => p.toEntity()).toList();
    final categories = hiveCategories?.map((c) => c.toEntity()).toList();
    
    return (products, categories);
  }
}