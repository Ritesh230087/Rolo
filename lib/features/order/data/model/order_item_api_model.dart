import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/core/utils/backend-image.dart';
import 'package:rolo/features/order/domain/entity/order_item_entity.dart';

part 'order_item_api_model.g.dart';

@JsonSerializable()
class OrderItemApiModel {
  @JsonKey(name: '_id')
  final String productId;
  final String name;
  final String filepath; 
  final int quantity;
  final double price;

  OrderItemApiModel({
    required this.productId,
    required this.name,
    required this.filepath,
    required this.quantity,
    required this.price,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemApiModelToJson(this);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      name: name,
      imageUrl: getBackendImageUrl(filepath), 
      quantity: quantity,
      price: price,
    );
  }
}