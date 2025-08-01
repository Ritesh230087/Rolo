// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      filepath: json['filepath'] as String,
      featured: json['featured'] as bool,
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      youSave: (json['youSave'] as num?)?.toDouble(),
      extraImages: (json['extraImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      material: json['material'] as String,
      origin: json['origin'] as String,
      care: json['care'] as String,
      warranty: json['warranty'] as String,
      categoryId: ProductApiModel._categoryFromJson(json['categoryId']),
      ribbonId: ProductApiModel._ribbonFromJson(json['ribbonId']),
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'quantity': instance.quantity,
      'filepath': instance.filepath,
      'featured': instance.featured,
      'discountPercent': instance.discountPercent,
      'youSave': instance.youSave,
      'extraImages': instance.extraImages,
      'features': instance.features,
      'material': instance.material,
      'origin': instance.origin,
      'care': instance.care,
      'warranty': instance.warranty,
      'categoryId': instance.categoryId,
      if (instance.ribbonId case final value?) 'ribbonId': value,
    };
