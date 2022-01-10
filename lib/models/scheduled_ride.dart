import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';


List<ScheduledRide> userRidesFromJson(String str) => new List<ScheduledRide>.from(json.decode(str).map((x) => ScheduledRide.fromMap(x)));
List<ScheduledRide> userRidesFromFireStore(String str) => new List<ScheduledRide>.from(json.decode(str).map((x) => ScheduledRide.fromFirestore(x)));

String userRidesToJson(List<ScheduledRide> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));


ScheduledRide rideFromJson(String str) => ScheduledRide.fromMap(json.decode(str));
//List<CountryMerchants> countryMerchantsFromJson(String str) => new List<CountryMerchants>.from(json.decode(str).map((x) => CountryMerchants.fromJson(x)));
String rideToJson(ScheduledRide data) => json.encode(data.toMap());

class ScheduledRide{
  String id;
  String userId;
  String userName;
  String work;
  double userRatings;
  String userProfilePix;
  DriveOrRide driveOrRide;
  TheLocation fromLocation;
  TheLocation toLocation;
  int dateinMilliseconds;
  DateTime date;
  int seatsAvailable;
  String time;
  List<String> riders;
  List<String> invitedRiders;
  List<String> ridersRequest;
  List<dynamic> ridersState;
  RideState rideState;
  double price;
  Ratings ratings;



  ScheduledRide({
    this.id,
    this.userId,
    this.driveOrRide,
    this.work,
    this.dateinMilliseconds,
    this.fromLocation,
    this.toLocation,
    this.userName,
    this.userProfilePix,
    this.userRatings,
    this.time,
    this.rideState,
    this.riders,
    this.invitedRiders,
    this.ridersRequest,
    this.ridersState,
    this.price,
    this.seatsAvailable,
    this.ratings,this.date
  });

  Map<String, dynamic> toMap() {
    var userMap = Map<String, dynamic>();
    userMap['id'] = id;
    userMap['user_id'] = userId;
    userMap['user_name'] = userName;
    userMap['user_ratings'] = userRatings;
    userMap['work'] = work;
    userMap['user_profilePix'] = userProfilePix;
    userMap['drive_Ride'] = convertFromDriveOrRide(driveOrRide);
    userMap['from_location'] = TheLocation.toMap(fromLocation);
    userMap['to_location'] = TheLocation.toMap(toLocation);
    userMap['date'] = dateinMilliseconds;
    userMap['time'] = time;
    userMap['ride_state'] = ScheduledRide.convertFromRideState(rideState);
    userMap['riders'] = riders;
    userMap['invited_riders'] = invitedRiders;
    userMap['riders_request'] = ridersRequest;
    userMap['riders_state'] = ridersState;
    userMap['price'] = price ?? 0.0;
    userMap['ratings_count'] = ratings.toFireStore() ?? Ratings(ratings: [],users: []).toFireStore();
    userMap['seats_available'] = seatsAvailable ?? 1;
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
    userMap['drive_Ride'] = convertFromDriveOrRide(driveOrRide);
    userMap['from_location'] = TheLocation.toFireStore(fromLocation);
    userMap['to_location'] = TheLocation.toFireStore(toLocation);
    userMap['date'] = dateinMilliseconds;
    userMap['time'] = time;
    userMap['ride_state'] = ScheduledRide.convertFromRideState(rideState);
    userMap['rider_state'] = [3];
    userMap['riders'] = riders;
    userMap['invited_riders'] = invitedRiders;
    userMap['riders_request'] = [];
    userMap['price'] = price ?? 0.0;
    userMap['ratings_count'] = ratings == null ? Ratings(ratings: [],users: []).toFireStore():ratings.toFireStore();
    userMap['seats_available'] = seatsAvailable ?? 1;
    return userMap;
  }

  static ScheduledRide fromMap(Map<String, dynamic> map){
    print(map['ratings_count']);
    return ScheduledRide(
      id: map['id'],
      userId: map['user_id'],
      ratings: map['ratings'] != null ? Ratings.fromFirestore(map['ratings']) :  Ratings(ratings: [],users: []),
      userName: map['user_name'],
      work: map['work'],
      userRatings: map['user_rating'] ?? 0.0,
      userProfilePix: map['user_profilePix'],
      driveOrRide: convertToDriveOrRide(map['drive_ride']),
      fromLocation: TheLocation.fromMap(map['from_location']),
      toLocation: TheLocation.fromMap(map['to_location']),
        dateinMilliseconds: map['date'],
        time: map['time'],
        rideState: ScheduledRide.convertToRideState(map['ride_state']),
        ridersState: map['rider_state'] != null ? List.from(map['rider_state']).map((admin) => admin.toInt()).toList(): [],
        riders: map['riders'] != null ? List.from(map['riders']).map((admin) => admin.toString()).toList(): [],
        invitedRiders: map['invited_riders'] != null ? List.from(map['invited_riders']).map((admin) => admin.toString()).toList(): [],
        ridersRequest: map['riders_request'] != null ? List.from(map['riders_request']).map((admin) => admin.toString()).toList(): [],
        price:  map['price'] ?? 0.0,
        seatsAvailable:  map['seats_available'] ?? 1

    );

  }

  static ScheduledRide fromFirestore(Map<String, dynamic> map){
    //print(map);

    ScheduledRide ride =  ScheduledRide(
      id: map['id'],
      
        userId: map['user_id'],
        ratings: map['ratings'] != null ? Ratings.fromFirestore(map['ratings']) :  Ratings(ratings: [],users: []),
        userName: map['user_name'],
        work: map['work'],
        userRatings: map['user_rating'],
        userProfilePix: map['user_profilePix'],
        driveOrRide: convertToDriveOrRide(map['drive_ride']),
        fromLocation: TheLocation.fromFirestore(map['from_location']),
        toLocation: TheLocation.fromFirestore(map['to_location']),
        dateinMilliseconds: map['date'],
        time: map['time'],
        rideState: ScheduledRide.convertToRideState(map['ride_state']),
        ridersState: map['rider_state'] != null ? List.from(map['rider_state']).map((admin) => admin).toList(): [],
        riders: map['riders'] != null ? List.from(map['riders']).map((admin) => admin.toString()).toList(): [],
        invitedRiders: map['invited_riders'] != null ? List.from(map['invited_riders']).map((admin) => admin.toString()).toList(): [],
        ridersRequest: map['riders_request'] != null ? List.from(map['riders_request']).map((admin) => admin.toString()).toList(): [],
        price: map['price'] == null ?0.0:  map['price'] is double ? map['price']: (map['price'] as int).toDouble(),
        seatsAvailable:  map['seats_available'] ?? 1
    );
    //pprint("ride stTEW ${ride.ridersState}");
    print("${MyUtils.getReadableDate(DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds))} - ${MyUtils.getReadableTime(DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds))}");
    return ride;
  }

  static List<ScheduledRide> listFromFirestore(List<DocumentSnapshot> docs){
    List<ScheduledRide> rides = [];
    docs.forEach((doc){
      Map<String, dynamic> map = doc.data();
      rides.add(
          ScheduledRide.fromFirestore(map)
      );
    });


     return rides;
  }





  static int convertFromDriveOrRide(DriveOrRide driveOrRide) => driveOrRide == DriveOrRide.DRIVE ? 1 : 0;

  static DriveOrRide convertToDriveOrRide(int num) => num == 0 ? DriveOrRide.RIDE : DriveOrRide.DRIVE;

  static int convertFromRideState(RideState rideState){
    if(rideState == RideState.CANCELLED){
      return 0;
    }else if(rideState == RideState.ENDED){
      return 1;
    }else if(rideState == RideState.IN_PROGRESS){
      return 2;
    }else if(rideState == RideState.SCHEDULED){
      return 3;
    }else if(rideState == RideState.STARTED){
      return 4;
    }

    return 3;
  }
  static int convertFromRiderState(RiderState rideState){
    if(rideState == RiderState.CANCELLED){
      return 0;
    }else if(rideState == RiderState.ENDED){
      return 1;
    }else if(rideState == RiderState.DEFAULT){
      return 2;
    }else if(rideState == RiderState.AVAILABLE){
      return 3;
    }else if(rideState == RiderState.JOINED){
      return 4;
    }

    return 2;
  }

  static List<int> convertFromRidersState(List<RiderState> rideState){
    List<int> states = [];
    rideState.forEach((ride){
      states.add(ScheduledRide.convertFromRiderState(ride));
    });
    return states;
  }

  static RideState convertToRideState(int value){
    if(value == 0){
      return RideState.CANCELLED;
    }else if(value == 1){
      return RideState.ENDED;
    }else if(value == 2){
      return RideState.IN_PROGRESS;
    }else if(value == 3){
      return RideState.SCHEDULED;
    }else if(value == 4){
      return RideState.STARTED;
    }

    return RideState.SCHEDULED;
  }

  static RiderState convertToRiderState2(int value){
    pprint("got here....-----");
    if(value == 0){
      return RiderState.CANCELLED;
    }else if(value == 1){
      return RiderState.ENDED;
    }else if(value == 2){
      return RiderState.DEFAULT;
    }else if(value == 3){
      return RiderState.AVAILABLE;
    }
    else if(value == 4){
      return RiderState.JOINED;
    }

    return RiderState.DEFAULT;
  }

  static List<RiderState> convertToRiderState(List<dynamic> value){
    List<RiderState> states = [];


    pprint("value adnk $value");
    if(value == null){

      return [];
    }
    value.forEach((state){
      int dval = state;

      states.add(ScheduledRide.convertToRiderState2(dval));
    });

    pprint("------value adnk $states");
    return states;
  }

  @override
  String toString() {
    return id;
  }
}

class Rider{
  String name;
  String profileUrl;
  String phoneNum;
  TheLocation pickupLocation;
  TheLocation dropOffLocation;
  RiderState state;
  AcceptState acceptState;

  Rider({this.state, this.profileUrl, this.phoneNum,
    this.name, this.dropOffLocation, this.pickupLocation, this.acceptState});


}

class RidePickups{
  TheLocation pickupLocation;
  TheLocation dropOffLocation;

  RidePickups({this.dropOffLocation, this.pickupLocation});

  static RidePickups fromFirestore(Map<String, dynamic> map){
    return RidePickups(

        pickupLocation: TheLocation.fromFirestore(map['pickup_location']),
        dropOffLocation: TheLocation.fromFirestore(map['dropoff_location']),

    );
  }

  static RidePickups fromMap(Map<String, dynamic> map){
    return RidePickups(

      pickupLocation: TheLocation.fromMap(map['pickup_location']),
      dropOffLocation: TheLocation.fromMap(map['dropoff_location']),

    );
  }

  Map<String, dynamic> toFireStore() {
    var userMap = Map<String, dynamic>();

    userMap['pickup_location'] = TheLocation.toFireStore(pickupLocation);
    userMap['dropoff_location'] = TheLocation.toFireStore(dropOffLocation);
    return userMap;
  }

  Map<String, dynamic> toMap() {
    var userMap = Map<String, dynamic>();

    userMap['pickup_location'] = TheLocation.toMap(pickupLocation);
    userMap['dropoff_location'] = TheLocation.toMap(dropOffLocation);
    return userMap;
  }

}

class Ratings{
  List<String> users;
  List<double> ratings;

  Map<String, dynamic> toFireStore() {
    var userMap = Map<String, dynamic>();

    userMap['users'] = users;
    userMap['ratings'] = ratings;
    return userMap;
  }

  Ratings({this.ratings,this.users});

  add(String userId,double ratings){

    this.users.add(userId);
    this.ratings.add(ratings);

  }

  //invitedRiders: map['invited_riders'] != null ? List.from(map['invited_riders']).map((admin) => admin.toString()).toList(): []
  static Ratings fromFirestore(Map map){
    print("mappppppppp $map");
    return Ratings(
      users: map['users'] != null ? List.from(map['users']).map((admin) => admin.toString()).toList(): [],
      ratings: map['ratings'] != null ? List.from(map['ratings']).map((admin) => admin is double ? admin : double.parse(admin)).toList(): [],

    );
  }

}
