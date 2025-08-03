import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/product/data/model/product_hive_model.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

abstract interface class IProductLocalDataSource {
  Future<void> cacheProduct(ProductEntity product);
  Future<ProductEntity?> getProductById(String productId);
}

class ProductLocalDataSourceImpl implements IProductLocalDataSource {
  Future<Box<ProductHiveModel>> _getCacheBox() async {
    return Hive.openBox<ProductHiveModel>(HiveTableConstant.productCacheBox);
  }

  @override
  Future<void> cacheProduct(ProductEntity product) async {
    final box = await _getCacheBox();
    final hiveModel = ProductHiveModel.fromEntity(product);
    await box.put(product.id, hiveModel);
  }

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    final box = await _getCacheBox();
    final hiveModel = box.get(productId);
    return hiveModel?.toEntity();
  }
}