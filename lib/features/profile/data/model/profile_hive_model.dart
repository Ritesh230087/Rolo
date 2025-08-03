import 'package:hive/hive.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/auth/data/model/user_hive_model.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.profileTableId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  late UserHiveModel user;
  
  // Orders and ShippingAddress have been REMOVED.

  ProfileHiveModel();

  // This now only caches the user information from the ProfileEntity.
  ProfileHiveModel.fromEntity(ProfileEntity entity) {
    user = UserHiveModel.fromEntity(entity.user);
  }

  // When converting back to an entity from the cache,
  // it provides the user data and returns empty/null for the rest.
  ProfileEntity toEntity() {
    return ProfileEntity(
      user: user.toEntity(),
      orders: [], // Orders are not cached, so return an empty list.
      lastShippingAddress: null, // Address is not cached, so return null.
    );
  }
}