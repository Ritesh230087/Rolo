import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/home/data/model/home_data_hive_model.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';

abstract interface class IHomeLocalDataSource {
  Future<void> cacheHomeData(HomeEntity data);
  Future<HomeEntity?> getHomeData();
}

class HomeLocalDataSourceImpl implements IHomeLocalDataSource {
  static const String _homeDataKey = 'homeData';

  @override
  Future<void> cacheHomeData(HomeEntity data) async {
    final box = await Hive.openBox<HomeDataHiveModel>(HiveTableConstant.homeCacheBox);
    final hiveModel = HomeDataHiveModel.fromEntity(data);
    await box.put(_homeDataKey, hiveModel);
  }

  @override
  Future<HomeEntity?> getHomeData() async {
    final box = await Hive.openBox<HomeDataHiveModel>(HiveTableConstant.homeCacheBox);
    final hiveModel = box.get(_homeDataKey);
    return hiveModel?.toEntity();
  }
}