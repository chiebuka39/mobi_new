// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fullName: fields[0] as String,
      emailAddress: fields[1] as String,
      phoneNumber: fields[2] as String,
      carDetails: fields[13] as CarDetails,
      drivingState: fields[10] as DrivingState,
      homeLocation: fields[8] as TheLocation,
      avatar: fields[14] as String,
      balance: fields[5] as dynamic,
      ratings: fields[11] as double,
      work: fields[3] as String,
      jobDesc: fields[4] as String,
      verified: fields[12] as bool,
      workLocation: fields[9] as TheLocation,
      workIdentityUrl: fields[15] as String,
      couponId: fields[17] as String,
      accounts: fields[18] as SocialAccounts,
      dateJoined: fields[19] as DateTime,
      leaveForHome: fields[22] as TimeOfDayCustom,
      leaveForWork: fields[21] as TimeOfDayCustom,
      dateUpdated: fields[20] as DateTime,
      scheduledRideIds: (fields[16] as List)?.cast<String>(),
      couponBalance: fields[6] as double,
      couponBalanceWithdrawn: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.emailAddress)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.work)
      ..writeByte(4)
      ..write(obj.jobDesc)
      ..writeByte(5)
      ..write(obj.balance)
      ..writeByte(6)
      ..write(obj.couponBalance)
      ..writeByte(7)
      ..write(obj.couponBalanceWithdrawn)
      ..writeByte(8)
      ..write(obj.homeLocation)
      ..writeByte(9)
      ..write(obj.workLocation)
      ..writeByte(10)
      ..write(obj.drivingState)
      ..writeByte(11)
      ..write(obj.ratings)
      ..writeByte(12)
      ..write(obj.verified)
      ..writeByte(13)
      ..write(obj.carDetails)
      ..writeByte(14)
      ..write(obj.avatar)
      ..writeByte(15)
      ..write(obj.workIdentityUrl)
      ..writeByte(16)
      ..write(obj.scheduledRideIds)
      ..writeByte(17)
      ..write(obj.couponId)
      ..writeByte(18)
      ..write(obj.accounts)
      ..writeByte(19)
      ..write(obj.dateJoined)
      ..writeByte(20)
      ..write(obj.dateUpdated)
      ..writeByte(21)
      ..write(obj.leaveForWork)
      ..writeByte(22)
      ..write(obj.leaveForHome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
