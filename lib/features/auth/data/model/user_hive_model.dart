import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rolo/app/constant/hive_table_constant.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fName;

  @HiveField(2)
  final String lName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? password;

  @HiveField(5)
  final String? authProvider;

  UserHiveModel({
    String? userId,
    required this.fName,
    required this.lName,
    required this.email,
    this.password,
    this.authProvider,
  }) : userId = userId ?? const Uuid().v4();

  const UserHiveModel.initial()
      : userId = '',
        fName = '',
        lName = '',
        email = '',
        password = '',
        authProvider = 'credentials';

  factory UserHiveModel.fromEntity(UserEntity entity) => UserHiveModel(
        userId: entity.userId,
        fName: entity.fName,
        lName: entity.lName,
        email: entity.email,
        password: entity.password,
        authProvider: entity.authProvider,
      );

  UserEntity toEntity() => UserEntity(
        userId: userId,
        fName: fName,
        lName: lName,
        email: email,
        password: password,
        authProvider: authProvider,
      );

  @override
  List<Object?> get props => [userId, fName, lName, email, password, authProvider];
}