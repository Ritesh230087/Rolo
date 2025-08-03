// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ribbon_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RibbonHiveModelAdapter extends TypeAdapter<RibbonHiveModel> {
  @override
  final int typeId = 4;

  @override
  RibbonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RibbonHiveModel()
      ..id = fields[0] as String
      ..label = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, RibbonHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RibbonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
