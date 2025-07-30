import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';

part 'user_profile_api_model.g.dart';

@JsonSerializable()
class UserProfileApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;

  @JsonKey(defaultValue: '')
  final String firstName;

  @JsonKey(defaultValue: '')
  final String lastName;

  @JsonKey(defaultValue: '')
  final String email;

  final String? authProvider;

  const UserProfileApiModel({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.authProvider, 
  });

  factory UserProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileApiModelToJson(this);
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fName: firstName,
      lName: lastName,
      email: email,
      password: '', 
      authProvider: authProvider,
    );
  }

  @override
  List<Object?> get props => [userId, firstName, lastName, email, authProvider];
}