import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String district;
  final String country;
  final String postalCode;
  final String notes;

  const ShippingAddressEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.district,
    required this.country,
    this.postalCode = '',
    this.notes = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  ShippingAddressEntity copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? district,
    String? country,
    String? postalCode,
    String? notes,
  }) {
    return ShippingAddressEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    firstName, lastName, email, phone, address,
    city, district, country, postalCode, notes
  ];
}