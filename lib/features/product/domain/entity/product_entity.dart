import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final int quantity;
  final String imageUrl;
  final List<String> extraImages; 
  final List<String> features;
  final String material;
  final String origin;
  final String care;
  final String warranty;
  final bool featured;
  final String categoryId;
  final String? ribbonId;
  final int? discountPercent;
  final double? youSave;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.imageUrl,
    required this.extraImages,
    required this.features,
    required this.material,
    required this.origin,
    required this.care,
    required this.warranty,
    required this.featured,
    required this.categoryId,
    this.ribbonId,
    this.discountPercent,
    this.youSave,
  });


ProductEntity copyWith({
  String? id,
  String? name,
  String? description,
  double? price,
  double? originalPrice,
  int? quantity,
  String? imageUrl,
  List<String>? extraImages,
  List<String>? features,
  String? material,
  String? origin,
  String? care,
  String? warranty,
  bool? featured,
  String? categoryId,
  String? ribbonId,
  int? discountPercent,
  double? youSave,
}) {
  return ProductEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    originalPrice: originalPrice ?? this.originalPrice,
    quantity: quantity ?? this.quantity,
    imageUrl: imageUrl ?? this.imageUrl,
    extraImages: extraImages ?? this.extraImages,
    features: features ?? this.features,
    material: material ?? this.material,
    origin: origin ?? this.origin,
    care: care ?? this.care,
    warranty: warranty ?? this.warranty,
    featured: featured ?? this.featured,
    categoryId: categoryId ?? this.categoryId,
    ribbonId: ribbonId ?? this.ribbonId,
    discountPercent: discountPercent ?? this.discountPercent,
    youSave: youSave ?? this.youSave,
  );
}

  @override
  List<Object?> get props => [id, name, price]; 
}