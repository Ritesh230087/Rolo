import 'package:equatable/equatable.dart';

class RibbonEntity extends Equatable {
  final String id;
  final String label;
  final String color;

  const RibbonEntity({
    required this.id,
    required this.label,
    required this.color,
  });

  @override
  List<Object?> get props => [id, label, color];
}