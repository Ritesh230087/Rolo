import 'package:equatable/equatable.dart';

class DeliveryLocationEntity extends Equatable {
  final String id;
  final String name;
  final String district;
  final double fare;

  const DeliveryLocationEntity({
    required this.id,
    required this.name,
    required this.district,
    required this.fare,
  });

  @override
  List<Object?> get props => [id, name, district, fare];
}