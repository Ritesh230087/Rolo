import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.categoryTableId)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  CategoryHiveModel();

  CategoryHiveModel.fromEntity(CategoryEntity entity) {
    id = entity.id;
    name = entity.name;
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, name: name);
  }
}