import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable{

  @JsonKey(name: '_id')
  final String? userId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const UserApiModel({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fName: firstName,
      lName: lastName,
      email: email,
      password:password,
    );
  }

  factory UserApiModel.fromEntity(UserEntity entity) {
    final user = UserApiModel(
      firstName: entity.fName,
      lastName: entity.lName,
      email: entity.email,
      password: entity.password,
    );
    return user;
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    password,
  ];
}