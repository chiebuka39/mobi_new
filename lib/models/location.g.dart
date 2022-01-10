// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TheLocationAdapter extends TypeAdapter<TheLocation> {
  @override
  final int typeId = 2;

  @override
  TheLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TheLocation(
      title: fields[0] as String,
      lat: fields[1] as double,
      lon: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TheLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TheLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
