// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbon_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RibbonApiModel _$RibbonApiModelFromJson(Map<String, dynamic> json) =>
    RibbonApiModel(
      id: json['_id'] as String,
      label: json['label'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$RibbonApiModelToJson(RibbonApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'label': instance.label,
      'color': instance.color,
    };
