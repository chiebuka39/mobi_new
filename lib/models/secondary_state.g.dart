// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secondary_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecondaryStateAdapter extends TypeAdapter<SecondaryState> {
  @override
  final int typeId = 5;

  @override
  SecondaryState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecondaryState(
      fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SecondaryState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isLoggedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecondaryStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
