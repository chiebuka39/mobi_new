import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';


List<SearchRide> userRidesFromJson(String str) => new List<SearchRide>.from(json.decode(str).map((x) => SearchRide.fromMap(x)));
List<SearchRide> userRidesFromFireStore(String str) => new List<SearchRide>.from(json.decode(str).map((x) => SearchRide.fromFirestore(x)));

String userRidesToJson(List<SearchRide> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));


SearchRide rideFromJson(String str) => SearchRide.fromMap(json.decode(str));
//List<CountryMerchants> countryMerchantsFromJson(String str) => new List<CountryMerchants>.from(json.decode(str).map((x) => CountryMerchants.fromJson(x)));
String rideToJson(SearchRide data) => json.encode(data.toMap());

class SearchRide{
  String id;
  String userId;
  String userName;
  String work;
  double userRatings;
  String userProfilePix;
  TheLocation fromLocation;
  TheLocation toLocation;
  DateTime date;
  String dateString;
  String time;



  SearchRide({
    this.id,
    this.userId,

    this.work,
    this.date,
    this.fromLocation,
    this.toLocation,
    this.userName,
    this.userProfilePix,
    this.userRatings,
    this.time,this.dateString

  });

  Map<String, dynamic> toMap() {
    var userMap = Map<String, dynamic>();
    userMap['id'] = id;
    userMap['user_id'] = userId;
    userMap['user_name'] = userName;
    userMap['user_ratings'] = userRatings;
    userMap['work'] = work;
    userMap['user_profilePix'] = userProfilePix;
    userMap['from_location'] = TheLocation.toMap(fromLocation);
    userMap['to_location'] = TheLocation.toMap(toLocation);
    userMap['date'] = date != null
        ? Timestamp.fromDate(date)
        : Timestamp.fromDate(DateTime.now());
    userMap['time'] = time;
    userMap['dateString'] = dateString;

    return userMap;
  }

  Map<String, dynamic> toFireStore({bool newRide = false}) {
    var userMap = Map<String, dynamic>();
    userMap['id'] = id;
    userMap['user_id'] = userId;
    userMap['user_name'] = userName;
    userMap['work'] = work;
    userMap['user_ratings'] = userRatings;
    userMap['user_profilePix'] = userProfilePix;
    userMap['from_location'] = TheLocation.toFireStore(fromLocation);
    userMap['to_location'] = TheLocation.toFireStore(toLocation);

    userMap['date'] = date != null
        ? Timestamp.fromDate(date)
        : Timestamp.fromDate(DateTime.now());
    userMap['time'] = time;
    userMap['dateString'] = dateString;

    return userMap;
  }

  static SearchRide fromMap(Map<String, dynamic> map){
    print(map['ratings_count']);
    return SearchRide(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'],
      work: map['work'],
      userRatings: map['user_rating'] ?? 0.0,
      userProfilePix: map['user_profilePix'],
      fromLocation: TheLocation.fromMap(map['from_location']),
      toLocation: TheLocation.fromMap(map['to_location']),

      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : Timestamp.now().toDate(),
        time: map['time'],
      dateString: map['dateString'],
    );

  }
  static SearchRide fromScheduleRide(ScheduledRide ride){

    return SearchRide(
      id: ride.id,
      userId: ride.userId,
      userName: ride.userName,
      work: ride.work,
      userRatings: ride?.userRatings ?? 0.0,
      userProfilePix: ride.userProfilePix,
      fromLocation: ride.fromLocation,
      toLocation: ride.toLocation,
      time: ride.time,
      date: DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds),
      dateString: "${DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds).year}-${DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds).month}"
          "-${DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds).day}",
    );

  }

  static SearchRide fromFirestore(Map<String, dynamic> map){
    //print(map);

    SearchRide ride =  SearchRide(
      id: map['id'],
      
        userId: map['user_id'],
        userName: map['user_name'],
        work: map['work'],
        userRatings: map['user_rating'],
        userProfilePix: map['user_profilePix'],
        fromLocation: TheLocation.fromFirestore(map['from_location']),
        toLocation: TheLocation.fromFirestore(map['to_location']),
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : Timestamp.now().toDate(),
        time: map['time'],
      dateString: map['dateString'],
    );
    //pprint("ride stTEW ${ride.ridersState}");
    return ride;
  }

  static List<SearchRide> listFromFirestore(List<DocumentSnapshot> docs){
    List<SearchRide> rides = [];
    docs.forEach((doc){
      Map<String, dynamic> map = doc.data();
      rides.add(
          SearchRide.fromFirestore(map)
      );
    });

     return rides;
  }

  @override
  String toString() {
    return id;
  }
}




