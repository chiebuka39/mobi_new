import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import 'package:hive/hive.dart';
import 'package:mobi/extras/utils.dart';


part 'location.g.dart';


@HiveType(typeId: 2)
class TheLocation {
  @HiveField(0)
  String title;

  @HiveField(1)
  double lat;

  @HiveField(2)
  double lon;

  String type;
  GeoFlutterFire geo = GeoFlutterFire();

  TheLocation({this.title, this.lat, this.lon});

  static fromMap(Map<dynamic, dynamic> map) {
    return TheLocation(
        title: map['title'],
        lat:map['lat'],
        lon:map['lon'] );
  }

  static fromFirestore(Map<dynamic, dynamic> map) {
    if(map.containsKey("position")){
      return TheLocation(
          title: map['title'],
          lat:(map['position']['geopoint'] as GeoPoint).latitude,
          lon:(map['position']['geopoint'] as GeoPoint).longitude);
    }else{
      return TheLocation(
          title: map['title'],
          lat:map['position'],
          lon:map['position']);
    }

  }

  Map<dynamic, dynamic> getGeoPoint(){
    pprint("$lat - $lon");
    return GeoFlutterFire().point(latitude: lat, longitude: lon).data;
  }

  static Map<String, dynamic> toMap(TheLocation location) {
    var userMap = Map<String, dynamic>();
    userMap['title'] = location.title;
    userMap['lat'] = location.lat;
    userMap['lon'] = location.lon;
    userMap['type'] = location.type;

    return userMap;
  }

  static Map<String, dynamic> toFireStore(TheLocation location) {
    var userMap = Map<String, dynamic>();
    pprint("oooo ${location.title}");
    userMap['title'] = location.title;
    userMap['position'] = location.getGeoPoint();

    return userMap;
  }
}