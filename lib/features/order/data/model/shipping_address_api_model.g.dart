// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddressApiModel _$ShippingAddressApiModelFromJson(
        Map<String, dynamic> json) =>
    ShippingAddressApiModel(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      address: json['addressLine'] as String,
      postalCode: json['postalCode'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ShippingAddressApiModelToJson(
        ShippingAddressApiModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'country': instance.country,
      'district': instance.district,
      'city': instance.city,
      'addressLine': instance.address,
      'postalCode': instance.postalCode,
      'notes': instance.notes,
    };
