import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/profile/data/model/profile_hive_model.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';

abstract interface class IProfileLocalDataSource {
  Future<void> cacheProfileData(ProfileEntity profile);
  Future<ProfileEntity?> getProfileData();
}

class ProfileLocalDataSource implements IProfileLocalDataSource {
  static const String _profileKey = 'user_profile';

  @override
  Future<void> cacheProfileData(ProfileEntity profile) async {
    final box = await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileCacheBox); // Add constant
    final hiveModel = ProfileHiveModel.fromEntity(profile);
    await box.put(_profileKey, hiveModel);
  }

  @override
  Future<ProfileEntity?> getProfileData() async {
    final box = await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileCacheBox);
    final hiveModel = box.get(_profileKey);
    return hiveModel?.toEntity();
  }
}