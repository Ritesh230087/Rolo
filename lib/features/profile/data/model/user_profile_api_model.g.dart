// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileApiModel _$UserProfileApiModelFromJson(Map<String, dynamic> json) =>
    UserProfileApiModel(
      userId: json['_id'] as String?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      authProvider: json['authProvider'] as String?,
    );

Map<String, dynamic> _$UserProfileApiModelToJson(
        UserProfileApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'authProvider': instance.authProvider,
    };
