// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_location_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryLocationApiModel _$DeliveryLocationApiModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryLocationApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      fare: (json['fare'] as num).toDouble(),
    );

Map<String, dynamic> _$DeliveryLocationApiModelToJson(
        DeliveryLocationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'district': instance.district,
      'fare': instance.fare,
    };
