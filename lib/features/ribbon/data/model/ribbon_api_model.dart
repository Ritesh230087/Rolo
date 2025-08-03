import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/ribbon/domain/entity/ribbon_entity.dart';

part 'ribbon_api_model.g.dart';

@JsonSerializable()
class RibbonApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String label;
  final String color;

  RibbonApiModel({required this.id, required this.label, required this.color});

  factory RibbonApiModel.fromJson(Map<String, dynamic> json) =>
      _$RibbonApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RibbonApiModelToJson(this);

  RibbonEntity toEntity() => RibbonEntity(id: id, label: label, color: color);
}