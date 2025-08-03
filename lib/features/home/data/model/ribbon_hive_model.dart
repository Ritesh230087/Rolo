import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/ribbon/domain/entity/ribbon_entity.dart';

part 'ribbon_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.ribbonTableId)
class RibbonHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String label;

  RibbonHiveModel();

  RibbonHiveModel.fromEntity(RibbonEntity entity) {
    id = entity.id;
    label = entity.label;
  }

  RibbonEntity toEntity() {
    return RibbonEntity(
      id: id,
      label: label,
      color: '#808080', 
    );
  }
}