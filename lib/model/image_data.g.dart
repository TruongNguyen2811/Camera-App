// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageDataAdapter extends TypeAdapter<ImageData> {
  @override
  final int typeId = 0;

  @override
  ImageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageData(
      createDate: fields[0] as DateTime?,
      name: fields[2] as String?,
      isDbr: fields[3] as bool?,
      uint8list: fields[1] as Uint8List?,
      id: fields[4] as int?,
      type: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ImageData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.createDate)
      ..writeByte(1)
      ..write(obj.uint8list)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isDbr)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
