// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class userdataAdapter extends TypeAdapter<userdata> {
  @override
  final int typeId = 0;

  @override
  userdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return userdata(
      fields[0] as String,
      fields[1] as String,
      fields[2] as ImageJson,
    );
  }

  @override
  void write(BinaryWriter writer, userdata obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.empCode)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is userdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageJsonAdapter extends TypeAdapter<ImageJson> {
  @override
  final int typeId = 1;

  @override
  ImageJson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageJson(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ImageJson obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.bitmap)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageJsonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
