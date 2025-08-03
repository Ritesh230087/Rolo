// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      id: json['_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      shippingAddress: ShippingAddressApiModel.fromJson(
          json['shippingAddress'] as Map<String, dynamic>),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      deliveryStatus: json['deliveryStatus'] as String,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'items': instance.items,
      'shippingAddress': instance.shippingAddress.toJson(),
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'deliveryStatus': instance.deliveryStatus,
      'deliveryFee': instance.deliveryFee,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
