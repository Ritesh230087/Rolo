import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;

  CategoryApiModel({
    required this.id,
    required this.name,
  });
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);
  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
      );
}