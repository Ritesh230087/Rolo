// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 1;

  @override
  ProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHiveModel()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..description = fields[2] as String
      ..price = fields[3] as double
      ..quantity = fields[4] as int
      ..imageUrl = fields[5] as String
      ..originalPrice = fields[6] as double
      ..extraImages = (fields[7] as List).cast<String>()
      ..features = (fields[8] as List).cast<String>()
      ..material = fields[9] as String
      ..origin = fields[10] as String
      ..care = fields[11] as String
      ..warranty = fields[12] as String
      ..featured = fields[13] as bool
      ..categoryId = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.originalPrice)
      ..writeByte(7)
      ..write(obj.extraImages)
      ..writeByte(8)
      ..write(obj.features)
      ..writeByte(9)
      ..write(obj.material)
      ..writeByte(10)
      ..write(obj.origin)
      ..writeByte(11)
      ..write(obj.care)
      ..writeByte(12)
      ..write(obj.warranty)
      ..writeByte(13)
      ..write(obj.featured)
      ..writeByte(14)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
