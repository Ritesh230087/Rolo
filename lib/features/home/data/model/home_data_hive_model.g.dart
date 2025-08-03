// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeDataHiveModelAdapter extends TypeAdapter<HomeDataHiveModel> {
  @override
  final int typeId = 6;

  @override
  HomeDataHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeDataHiveModel()
      ..categories = (fields[0] as List).cast<CategoryHiveModel>()
      ..featuredProducts = (fields[1] as List).cast<ProductHiveModel>()
      ..ribbonSections = (fields[2] as List).cast<HomeSectionHiveModel>();
  }

  @override
  void write(BinaryWriter writer, HomeDataHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.featuredProducts)
      ..writeByte(2)
      ..write(obj.ribbonSections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeDataHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
