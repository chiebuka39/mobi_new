
import 'package:hive/hive.dart';

part 'details.g.dart';

@HiveType(typeId: 12)
class CarDetails {
  @HiveField(0)
  String carModel;

  @HiveField(1)
  String carColor;

  @HiveField(2)
  String carImageUrl;

  @HiveField(3)
  String plateNumber;

  @HiveField(4)
  String licenseImageUrl;

  CarDetails({this.carImageUrl, this.plateNumber, this.licenseImageUrl, this.carColor,this.carModel});

  static fromMap(Map<dynamic, dynamic> map) {
    return CarDetails(
        carImageUrl: map['car_image_url'],
        carColor: map['car_color'] ?? '',
        carModel: map['car_model'] ?? '',
        plateNumber: map['plate_number'],
        licenseImageUrl: map['license_image_url']);
  }

  static Map<dynamic, dynamic> toMap(CarDetails details) {
    var carMap = Map<dynamic, dynamic>();
    carMap['car_image_url'] = details.carImageUrl;
    carMap['car_color'] = details.carColor ?? '';
    carMap['car_model'] = details.carModel ?? '';
    carMap['plate_number'] = details.plateNumber;
    carMap['license_image_url'] = details.licenseImageUrl;
    return carMap;
  }

  Map<dynamic, dynamic> toMap2(){
    return {
      'car_image_url': carImageUrl,
      'car_color': carColor ?? '',
      'car_model': carModel ?? '',
      'plate_number' : plateNumber,
      'license_image_url': licenseImageUrl
    };
  }
}


@HiveType(typeId: 13)
class SocialAccounts{
  @HiveField(0)
  String twitter;
  @HiveField(1)
  String instagram;
  @HiveField(2)
  String fb;
  @HiveField(3)
  String linkedIn;

  SocialAccounts({this.twitter, this.instagram, this.linkedIn, this.fb});

  static fromMap(Map<dynamic, dynamic> map) {

    return SocialAccounts(
        twitter: map['twitter'] != null ? map['twitter'] : '',
        instagram: map['instagram'] != null ? map['instagram'] : '',
        fb:map['fb'] != null ? map['fb'] : '',
        linkedIn: map['linked_in'] != null ? map['linked_in'] : '');
  }

  Map<dynamic, dynamic> toMap2(SocialAccounts accounts) {
    return {
      'linked_in': accounts.linkedIn ?? '',
      'fb': accounts.fb ?? '',
      'instagram': accounts.instagram ?? '',
      'twitter': accounts.twitter ?? '',
    };
  }

  static Map<dynamic, dynamic> toMap(SocialAccounts accounts) {
    var social = Map<dynamic, dynamic>();
    social['linked_in'] = accounts.linkedIn ?? '';
    social['fb'] = accounts.fb ?? '';
    social['instagram'] = accounts.instagram ?? '';
    social['twitter'] = accounts.twitter ?? '';
    return social;
  }
  @override
  String toString() {

    return "$instagram-$fb-$twitter-$linkedIn";
  }
}