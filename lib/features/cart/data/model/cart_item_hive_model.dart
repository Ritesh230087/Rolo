import 'package:hive/hive.dart';
import 'package:rolo/features/product/data/model/product_hive_model.dart';

part 'cart_item_hive_model.g.dart';

@HiveType(typeId: 2)
class CartItemHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ProductHiveModel product;

  @HiveField(2)
  int quantity;

  CartItemHiveModel({
    required this.id,
    required this.product,
    required this.quantity,
  });
}