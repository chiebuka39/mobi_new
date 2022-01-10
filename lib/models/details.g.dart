// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarDetailsAdapter extends TypeAdapter<CarDetails> {
  @override
  final int typeId = 12;

  @override
  CarDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarDetails(
      carImageUrl: fields[2] as String,
      plateNumber: fields[3] as String,
      licenseImageUrl: fields[4] as String,
      carColor: fields[1] as String,
      carModel: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CarDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.carModel)
      ..writeByte(1)
      ..write(obj.carColor)
      ..writeByte(2)
      ..write(obj.carImageUrl)
      ..writeByte(3)
      ..write(obj.plateNumber)
      ..writeByte(4)
      ..write(obj.licenseImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SocialAccountsAdapter extends TypeAdapter<SocialAccounts> {
  @override
  final int typeId = 13;

  @override
  SocialAccounts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialAccounts(
      twitter: fields[0] as String,
      instagram: fields[1] as String,
      linkedIn: fields[3] as String,
      fb: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SocialAccounts obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.twitter)
      ..writeByte(1)
      ..write(obj.instagram)
      ..writeByte(2)
      ..write(obj.fb)
      ..writeByte(3)
      ..write(obj.linkedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialAccountsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
