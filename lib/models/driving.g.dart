// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driving.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrivingStateAdapter extends TypeAdapter<DrivingState> {
  @override
  final int typeId = 3;

  @override
  DrivingState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DrivingState.Does_Not_Drive;
      case 1:
        return DrivingState.Drives;
      case 2:
        return DrivingState.Drives_Once_A_While;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, DrivingState obj) {
    switch (obj) {
      case DrivingState.Does_Not_Drive:
        writer.writeByte(0);
        break;
      case DrivingState.Drives:
        writer.writeByte(1);
        break;
      case DrivingState.Drives_Once_A_While:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrivingStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeOfDayCustomAdapter extends TypeAdapter<TimeOfDayCustom> {
  @override
  final int typeId = 20;

  @override
  TimeOfDayCustom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeOfDayCustom(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeOfDayCustom obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayCustomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
