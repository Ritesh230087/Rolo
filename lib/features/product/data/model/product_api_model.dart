import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/core/utils/backend-image.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final int quantity;
  final String filepath;
  final bool featured;
  final int? discountPercent;
  final double? youSave;
  final List<String> extraImages;
  final List<String> features;
  final String material;
  final String origin;
  final String care;
  final String warranty;
  @JsonKey(name: 'categoryId', fromJson: _categoryFromJson)
  final String categoryId;
  @JsonKey(name: 'ribbonId', fromJson: _ribbonFromJson, includeIfNull: false)
  final String? ribbonId;

  ProductApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.filepath,
    required this.featured,
    this.discountPercent,
    this.youSave,
    required this.extraImages,
    required this.features,
    required this.material,
    required this.origin,
    required this.care,
    required this.warranty,
    required this.categoryId,
    this.ribbonId,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  static String _categoryFromJson(dynamic json) {
    if (json is Map<String, dynamic>) return json['_id'];
    return json as String;
  }

  static String? _ribbonFromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) return json['_id'];
    return json as String?;
  }

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    price: price,
    originalPrice: originalPrice,
    quantity: quantity,
        imageUrl: getBackendImageUrl(filepath), 
        extraImages: extraImages.map((path) => getBackendImageUrl(path)).toList(),
    features: features,
    material: material,
    origin: origin,
    care: care,
    warranty: warranty,
    featured: featured,
    categoryId: categoryId,
    ribbonId: ribbonId,
    discountPercent: discountPercent,
    youSave: youSave,
  );
}