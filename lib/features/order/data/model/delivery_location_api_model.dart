import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';

part 'delivery_location_api_model.g.dart';

@JsonSerializable()
class DeliveryLocationApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String district;
  final double fare;

  DeliveryLocationApiModel({
    required this.id,
    required this.name,
    required this.district,
    required this.fare,
  });

  factory DeliveryLocationApiModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryLocationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryLocationApiModelToJson(this);

  DeliveryLocationEntity toEntity() {
    return DeliveryLocationEntity(
      id: id,
      name: name,
      district: district,
      fare: fare,
    );
  }
}