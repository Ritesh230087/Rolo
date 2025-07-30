import 'package:json_annotation/json_annotation.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';

part 'shipping_address_api_model.g.dart';

@JsonSerializable()
class ShippingAddressApiModel {
  final String fullName;
  final String phone;
  final String country;
  final String district;
  final String city;
  @JsonKey(name: 'addressLine') 
  final String address;
  final String? postalCode;
  final String? notes;

  ShippingAddressApiModel({
    required this.fullName,
    required this.phone,
    required this.country,
    required this.district,
    required this.city,
    required this.address,
    this.postalCode,
    this.notes,
  });

  factory ShippingAddressApiModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressApiModelToJson(this);

  factory ShippingAddressApiModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressApiModel(
      fullName: entity.fullName,
      phone: entity.phone,
      country: entity.country,
      district: entity.district,
      city: entity.city,
      address: entity.address,
      postalCode: entity.postalCode,
      notes: entity.notes,
    );
  }

  ShippingAddressEntity toEntity() {
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    return ShippingAddressEntity(
      firstName: firstName,
      lastName: lastName,
      email: '', 
      phone: phone,
      address: address,
      city: city,
      district: district,
      country: country,
      postalCode: postalCode ?? '',
      notes: notes ?? '',
    );
  }
}