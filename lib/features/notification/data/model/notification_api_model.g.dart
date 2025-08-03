// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['_id'] as String,
      message: json['message'] as String,
      link: json['link'] as String?,
      isRead: json['isRead'] as bool,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'message': instance.message,
      'link': instance.link,
      'isRead': instance.isRead,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
    };
