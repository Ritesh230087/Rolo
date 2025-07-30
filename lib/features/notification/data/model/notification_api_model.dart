import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/notification/domain/entity/notification_entity.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String message;
  final String? link;
  final bool isRead;
  final String category;
  final DateTime createdAt;

  NotificationApiModel({
    required this.id,
    required this.message,
    this.link,
    required this.isRead,
    required this.category,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      message: message,
      link: link,
      isRead: isRead,
      category: category,
      createdAt: createdAt,
    );
  }
}