// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemApiModel _$OrderItemApiModelFromJson(Map<String, dynamic> json) =>
    OrderItemApiModel(
      productId: json['_id'] as String,
      name: json['name'] as String,
      filepath: json['filepath'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemApiModelToJson(OrderItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'filepath': instance.filepath,
      'quantity': instance.quantity,
      'price': instance.price,
    };
