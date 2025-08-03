// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_section_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeSectionHiveModelAdapter extends TypeAdapter<HomeSectionHiveModel> {
  @override
  final int typeId = 5;

  @override
  HomeSectionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeSectionHiveModel()
      ..ribbon = fields[0] as RibbonHiveModel
      ..products = (fields[1] as List).cast<ProductHiveModel>();
  }

  @override
  void write(BinaryWriter writer, HomeSectionHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ribbon)
      ..writeByte(1)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeSectionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
