import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/multi_ride.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/result.dart' as Res;
import 'package:mobi/models/search_ride.dart';
import 'package:mobi/models/user.dart';

abstract class AbstractRidesApi {
  Future<Res.Result<void>> submitRideRatings(
      Ratings ratings, ScheduledRide ride);
  Future<Res.Result<List<DocumentSnapshot>>> getRequestedRides(String userId);
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId);
  Future<Res.Result<void>> setRiderStateToJoin(
      ScheduledRide ride, User user, List<dynamic> state);
  Future<Res.Result<void>> updateRide(String userId, String rideId, DateTime time);
  Future<Map<String, dynamic>> createScheduledRide(ScheduledRide scheduledRide);
  Future<Res.Result<void>> createSearchRide(ScheduledRide scheduledRide);
  Future<List<SearchRide>> fetchSearchRides(User user,{Position position});
  Future<List<ScheduledRide>> fetchSearchRides2(User user,{TheLocation fromLoc, TheLocation toLoc});
}

class RidesApi extends AbstractRidesApi {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  GeoFlutterFire geo = GeoFlutterFire();

  @override
  Future<Map<String, dynamic>> createScheduledRide(
      ScheduledRide scheduledRide) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    try{
      scheduledRide.ridersState = [0];

      DocumentReference rideReference = database
          .collection(MyStrings.users())
          .doc(scheduledRide.userId)
          .collection(MyStrings.rides())
          .doc();





      scheduledRide.id = rideReference.id;
      result['ride_id'] = rideReference.id;

      //Create a batch
      var batch = database.batch();

      batch.set(rideReference, scheduledRide.toFireStore(newRide: true));

      await batch.commit();
    }catch(e){
      print("error in creating ride ${e.toString()}");
      result['success'] = false;
      result['message'] = e.toString();
    }


    return result;
  }
  @override
  Future<Res.Result<void>> createSearchRide(
      ScheduledRide scheduledRide) async {
    Res.Result<void> result = Res.Result(error: false);

    SearchRide ride = SearchRide.fromScheduleRide(scheduledRide);


    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(scheduledRide.userId)
        .collection(MyStrings.search_rides())
        .doc();





    ride.id = rideReference.id;


    //Create a batch

    try{
      rideReference.set( ride.toFireStore(newRide: true));

    }catch(e){
      result.error = true;
      result.message = e.toString();
    }


    return result;
  }

  Future<Map<String, dynamic>> updateScheduledRide(
      ScheduledRide scheduledRide) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;
    scheduledRide.ridersState = [0];

    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(scheduledRide.userId)
        .collection(MyStrings.rides())
        .doc();

    scheduledRide.id = rideReference.id;
    result['ride_id'] = rideReference.id;

    //Create a batch
    var batch = database.batch();

    batch.set(rideReference, scheduledRide.toFireStore(newRide: true));

    await batch.commit().catchError((error) {
      result['success'] = false;
      result['message'] = error.toString();
    });

    return result;
  }

  Future<Map<String, dynamic>> create10ScheduledRide({
    User user,
    double amount,
    DateTime morning,
    DateTime evening,
  }) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    //Create a batch
    var batch = database.batch();
    DateTime m = morning;
    DateTime e = evening;
    for (int i = 0; i < 10; i++) {
      if (m.weekday == 5) {
        m = m.add(Duration(days: 3));
        e = e.add(Duration(days: 3));
      } else if (m.weekday == 6) {
        m = m.add(Duration(days: 2));
        e = e.add(Duration(days: 2));
      } else {
        m = m.add(Duration(days: 1));
        e = e.add(Duration(days: 1));
      }
      DocumentReference morningRideReference = database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.rides())
          .doc();

      ScheduledRide morningRide = createdSchedule(
          user: user,
          fromLocation: user.homeLocation,
          toLocation: user.workLocation,
          amount: amount,
          time: m);

      DocumentReference eveningRideReference = database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.rides())
          .doc();

      ScheduledRide eveningRide = createdSchedule(
          user: user,
          fromLocation: user.workLocation,
          toLocation: user.homeLocation,
          amount: amount,
          time: e);

      morningRide.id = morningRideReference.id;
      eveningRide.id = eveningRideReference.id;
      batch.set(
          morningRideReference, morningRide.toFireStore(newRide: true));
      batch.set(
          eveningRideReference, eveningRide.toFireStore(newRide: true));
      print("ooovn setting data");
    }
    result['ride_id'] = "1";

    await batch.commit().catchError((error) {
      result['success'] = false;
      result['message'] = error.toString();
    });

    return result;
  }

  Future<Map<String, dynamic>> createListOfScheduledRide(
      {User user, MultiRideModel multiRideModel}) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    //Create a batch
    var batch = database.batch();

    multiRideModel.dates.forEach((date) {
      DateTime m = DateTime(date.year, date.month, date.day,
          multiRideModel.leaveForWork.hour, multiRideModel.leaveForWork.minute);
      DateTime e = DateTime(date.year, date.month, date.day,
          multiRideModel.leaveForHome.hour, multiRideModel.leaveForHome.minute);
      DocumentReference morningRideReference = database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.rides())
          .doc();

      ScheduledRide morningRide = createdSchedule(
          user: user,
          fromLocation: multiRideModel.homeLocation,
          toLocation: multiRideModel.workLocation,
          amount: multiRideModel.amount.toDouble(),
          time: m);

      DocumentReference eveningRideReference = database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.rides())
          .doc();

      ScheduledRide eveningRide = createdSchedule(
          user: user,
          fromLocation: multiRideModel.workLocation,
          toLocation: multiRideModel.homeLocation,
          amount: multiRideModel.amount.toDouble(),
          time: e);

      morningRide.id = morningRideReference.id;
      eveningRide.id = eveningRideReference.id;
      batch.set(
          morningRideReference, morningRide.toFireStore(newRide: true));
      batch.set(
          eveningRideReference, eveningRide.toFireStore(newRide: true));
      print("ooovn setting data");
    });

    result['ride_id'] = "1";

    await batch.commit().catchError((error) {
      result['success'] = false;
      result['message'] = error.toString();
    });

    return result;
  }

  Future<List<DocumentSnapshot>> getScheduledRide(String userId) async {
    var rides1 = await database
        .collectionGroup(MyStrings.rides())
        .where('riders', arrayContains: userId)
        .where('ride_state', isGreaterThan: 2)
        .get()
        .catchError((error) {
      print(error.toString());
    });
    //print("0w04e ${rides1.docs.length}");

    var rides2 = await database
        .collectionGroup(MyStrings.rides())
        .where('riders_request', arrayContains: userId)
        .where('ride_state', isGreaterThan: 2)
        .get()
        .catchError((error) {
      print(error.toString());
    });

    List<DocumentSnapshot> rides = new List.from(rides1.docs)
      ..addAll(rides2.docs);

    return rides;
  }

  Future<List<DocumentSnapshot>> getAllRides(String userId) async {
    var rides1 = await database
        .collectionGroup(MyStrings.rides())
        .where('riders', arrayContains: userId)
        .limit(15)
        .get()
        .catchError((error) {
      print(error.toString());
    });

    var rides2 = await database
        .collectionGroup(MyStrings.rides())
        .where('riders_request', arrayContains: userId)
        .limit(15)
        .get()
        .catchError((error) {
      print(error.toString());
    });

    List<DocumentSnapshot> rides = new List.from(rides1.docs)
      ..addAll(rides2.docs);

    return rides;
  }

  Future<List<DocumentSnapshot>> getInvitedRides(String userId) async {
    var rides1 = await database
        .collectionGroup(MyStrings.rides())
        .where('invited_riders', arrayContains: userId)
        .limit(15)
        .get()
        .catchError((error) {
      print(error.toString());
    });

    List<DocumentSnapshot> rides = rides1.docs;

    return rides;
  }

  @override
  Future<Res.Result<List<DocumentSnapshot>>> getRequestedRides(
      String userId) async {
    Res.Result<List<DocumentSnapshot>> rs = Res.Result();
    rs.error = false;
    var rides1 = await database
        .collectionGroup(MyStrings.rides())
        .where('riders_request', arrayContains: userId)
        .limit(15)
        .get()
        .catchError((error) {
      rs.error = true;
      print(error.toString());
    });

    List<DocumentSnapshot> rides = rides1.docs;
    rs.data = rides1.docs;

    return rs;
  }

  Stream<List<ScheduledRide>> getScheduledRideWithStream(String userId) {
    var controller = StreamController<List<ScheduledRide>>();

    _combineStreams(userId).listen((snapshots) {
      print("ooooooo");
      List<DocumentSnapshot> docs = List<DocumentSnapshot>();
      //snapshots.first.docChanges.
      snapshots.forEach((snapshot) {
        docs.addAll(snapshot.docs);
      });

      final rides = docs.map((doc) {
        return ScheduledRide.fromFirestore(doc.data());
      }).toList();

      List<ScheduledRide> rides1 = rides
          .where((ride) =>
              ride.rideState != RideState.CANCELLED &&
              ride.rideState != RideState.ENDED)
          .toList();

      controller.add(rides1);
    });

    return controller.stream;
  }

  Stream<List<QuerySnapshot>> _combineStreams(String userId) {
    var rides1 = database
        .collectionGroup(MyStrings.rides())
        .where('riders', arrayContains: userId)
        .where('date',
            isGreaterThan: DateTime.now()
                .subtract(Duration(hours: 6))
                .millisecondsSinceEpoch)
        .orderBy("date")
        .snapshots();

    var rides2 = database
        .collectionGroup(MyStrings.rides())
        .where('riders_request', arrayContains: userId)
        .where('ride_state',
            isGreaterThan: ScheduledRide.convertFromRideState(RideState.ENDED))
        .snapshots();

    return StreamZip(([rides1, rides2])).asBroadcastStream();
  }

  Future<bool> sendRideRequest(ScheduledRide ride, String userId) async {
    bool successful = true;
    var rides = await database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .update(<String, dynamic>{
      'riders_request': FieldValue.arrayUnion([userId])
    }).catchError((error) {
      successful = false;
      print(error.toString());
    });

    return successful;
  }

  Future<bool> setRideState(
      ScheduledRide ride, String userId, RideState state) async {
    bool successful = true;
    await database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .update(<String, dynamic>{
      'ride_state': ScheduledRide.convertFromRideState(state)
    }).catchError((error) {
      successful = false;
      print(error.toString());
    });

    return successful;
  }

  Future<bool> setRiderState(
      ScheduledRide ride, String userId, List<dynamic> state) async {
    bool successful = true;
    await database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .update(<String, dynamic>{'rider_state': state}).catchError(
            (error) {
      successful = false;
      print(error.toString());
    });

    return successful;
  }

  Stream<List<ScheduledRide>> tempGetAllAvailableRides(String userId) {
    var streamTransformer =
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ScheduledRide>>.fromHandlers(
      handleData: (QuerySnapshot data, EventSink sink) {
        sink.add(ScheduledRide.listFromFirestore(data.docs)
            .where((ride) =>
                ride.rideState != RideState.CANCELLED &&
                ride.rideState != RideState.ENDED)
            .toList());
      },
      handleError: (error, stacktrace, sink) {
        print("ppppp release error");
        sink.addError('Something went wrong: $error');
      },
      handleDone: (sink) {
        sink.close();
      },
    );
    print("ppppp release api $userId");
    return database
        .collectionGroup(MyStrings.rides())
        .where('riders', arrayContains: userId)
        .where('date',
            isGreaterThan: DateTime.now()
                .subtract(Duration(hours: 18))
                .millisecondsSinceEpoch)
        .orderBy("date")
        .snapshots()
        .transform(streamTransformer);
  }

  @override
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId) async{

    print("ppppp release api");
    var result = await  database
        .collectionGroup(MyStrings.rides())
        .where('riders', arrayContains: userId)
        .where('date',
        isGreaterThan: DateTime.now()
            .subtract(Duration(hours: 18))
            .millisecondsSinceEpoch)
        .orderBy("date").get();

    return ScheduledRide.listFromFirestore(result.docs).where((ride) =>
    ride.rideState != RideState.CANCELLED &&
        ride.rideState != RideState.ENDED).toList();
  }

  Future<Map<String, dynamic>> getRemoteRide(String userId) async {
    Map<String, dynamic> result = Map();
    result['error'] = false;
    try {
      final response = await database
          .collectionGroup(MyStrings.rides())
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();
      result['ride'] =
          ScheduledRide.fromFirestore(response.docs.first.data());
    } catch (e) {
      result['error'] = true;
      result['message'] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> acceptOrDeclineRide(
      ScheduledRide ride, String userId, bool accept) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id);

    var batch = database.batch();

    if (accept == true) {
      print(">>>>>>>>>>>>> ${[...ride.ridersState,2]}");
      batch.update(rideReference, <String, dynamic>{
        'riders': FieldValue.arrayUnion([userId]),
        'rider_state': [...ride.ridersState,2],
        'riders_request': FieldValue.arrayRemove([userId])
      });

      print(">>>>>>>>>>>>>");
    }else{
      batch.update(rideReference, <String, dynamic>{
        'riders_request': FieldValue.arrayRemove([userId])
      });
    }

    await batch.commit().catchError((error) {
      result['success'] = false;
      result['message'] = error.toString();
    });

    return result;
  }

  Future<Map<String, dynamic>> acceptRideInvitation(
      ScheduledRide ride, String userId, bool accept) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id);

    var batch = database.batch();
    batch.update(rideReference, <String, dynamic>{
      'invited_riders': FieldValue.arrayRemove([userId])
    });
    if (accept == true) {
      batch.update(rideReference, <String, dynamic>{
        'riders': FieldValue.arrayUnion([userId])
      });

      //Set the state of the ride for a particular user
      batch.update(rideReference, <String, dynamic>{
        'rider_state': FieldValue.arrayUnion([2])
      });
    }

    await batch.commit().catchError((error) {
      result['success'] = false;
      result['message'] = error.toString();
    });

    return result;
  }

  Future<List<ScheduledRide>> getAvailableRides(ScheduledRide ride) async {
    List<ScheduledRide> rides = [];
    List<ScheduledRide> ridesFrom = [];
    List<ScheduledRide> ridesTo = [];

    DateTime thatDayRide =
        DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds);
    DateTime thatDayMorning =
        DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day);
    DateTime thatDayEvening =
        DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day + 1);

    var collectionReference = database.collectionGroup(MyStrings.rides()).where(
        'ride_state',
        isEqualTo: ScheduledRide.convertFromRideState(RideState.SCHEDULED));

    var geoRef = geo.collection(collectionRef: collectionReference);

    // Geo point of the Users Start location
    GeoFirePoint centerStartLocation = geo.point(
        latitude: ride.fromLocation.lat, longitude: ride.fromLocation.lon);

    // Geo point of the Users end location
    GeoFirePoint centerEndLocation = geo.point(
        latitude: ride.toLocation.lat, longitude: ride.toLocation.lon);
//    Query query = _queryPoint("s14mkjxj2", 'from_location.position', collectionReference);
//    query.get().catchError((error){
//      print(error.toString());
//    });
    var from = await geoRef
        .within(
            center: centerStartLocation,
            radius: 3,
            field: 'from_location.position',
            strictMode: true)
        .first;

    ridesFrom = ScheduledRide.listFromFirestore(from);

    var to = await geoRef
        .within(
            center: centerEndLocation,
            radius: 3,
            field: 'to_location.position',
            strictMode: true)
        .first;

    ridesTo = ScheduledRide.listFromFirestore(to);

    ridesTo.forEach((data) {
      //print("dffo0w9");
      ridesFrom.forEach((from) {
        if (from.id == data.id) {
          //make sure the ride showing is supposed to take place that day
          if (data.dateinMilliseconds > thatDayMorning.millisecondsSinceEpoch &&
              data.dateinMilliseconds < thatDayEvening.millisecondsSinceEpoch) {
            rides.add(data);
          }
          //rides.add(data);
        }
      });
    });

    return rides;
  }


  @override
  Future<List<SearchRide>> fetchSearchRides(User user,{Position position}) async {
    List<SearchRide> rides = [];
    List<SearchRide> ridesFrom = [];
    List<SearchRide> ridesTo = [];

    DateTime thatDayRide =
    DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    DateTime thatDayMorning =
    DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day);
    DateTime thatDayEvening =
    DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day + 1);

    print("pppp ${thatDayRide.year}-${thatDayRide.month}"
        "-${thatDayRide.day}");
    var collectionReference = database.collectionGroup(MyStrings.search_rides()).where(
      'dateString', isEqualTo: "${thatDayRide.year}-${thatDayRide.month}"
        "-${thatDayRide.day}"
    );

    var geoRef = geo.collection(collectionRef: collectionReference);

    // Geo point of the Users Start location
    GeoFirePoint centerStartLocation = geo.point(
        latitude: user.homeLocation.lat, longitude: user.homeLocation.lon);

    // Geo point of the Users end location
    GeoFirePoint centerEndLocation = geo.point(
        latitude: user.workLocation.lat, longitude: user.workLocation.lon);
   // Query query = _queryPoint("s14mkjxj2", 'from_location.position', collectionReference);
   // query.get().catchError((error){
   //   print(error.toString());
   // });
    print("<<<<<<<<<<<<<<<<<");
    print("<<<<<<<<${user.homeLocation.lat}<<<<<<<<<");
    print("<<<<<<<<<<<<<<<<<");
    var from = await geoRef
        .within(
        center: centerStartLocation,
        radius: 3,
        field: 'from_location.position',
        strictMode: true)
        .first;

    ridesFrom = SearchRide.listFromFirestore(from);
    print("pppp ${ridesFrom}");

    var to = await geoRef
        .within(
        center: centerEndLocation,
        radius: 3,
        field: 'to_location.position',
        strictMode: true)
        .first;

    ridesTo = SearchRide.listFromFirestore(to);
    print("ppe3pp ${ridesTo}");

    ridesTo.forEach((data) {
      print("dffo0w9 $data");
      ridesFrom.forEach((from) {
        print("dffo0w9 ${from.id} --- ${data.id}");
        if (from.id == data.id) {
          //make sure the ride showing is supposed to take place that day
          if (data.date.millisecondsSinceEpoch > thatDayMorning.millisecondsSinceEpoch &&
              data.date.millisecondsSinceEpoch < thatDayEvening.millisecondsSinceEpoch) {
            rides.add(data);
          }
          //rides.add(data);
        }
      });
    });

    return rides;
  } @override

  @override
  Future<List<ScheduledRide>> fetchSearchRides2(User user,{TheLocation fromLoc, TheLocation toLoc}) async {
    List<ScheduledRide> rides = [];
    List<ScheduledRide> ridesFrom = [];
    List<ScheduledRide> ridesTo = [];

    DateTime thatDayRide =
    DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    DateTime thatDayMorning =
    DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day);
    DateTime thatDayEvening =
    DateTime.utc(thatDayRide.year, thatDayRide.month, thatDayRide.day + 1);

    print("pppp ${thatDayRide.year}-${thatDayRide.month}"
        "-${thatDayRide.day}");
    var collectionReference = database.collectionGroup(MyStrings.rides()).where(
      'dateString', isEqualTo: "${thatDayRide.year}-${thatDayRide.month}"
        "-${thatDayRide.day}"
    );

    var geoRef = geo.collection(collectionRef: collectionReference);

    // Geo point of the Users Start location
    GeoFirePoint centerStartLocation = geo.point(
        latitude: fromLoc.lat, longitude: fromLoc.lon);

    // Geo point of the Users end location
    GeoFirePoint centerEndLocation = geo.point(
        latitude: toLoc.lat, longitude: toLoc.lon);
   // Query query = _queryPoint("s14mkjxj2", 'from_location.position', collectionReference);
   // query.get().catchError((error){
   //   print(error.toString());
   // });
    print("<<<<<<<<<<<<<<<<<");
    print("<<<<<<<<${user.homeLocation.lat}<<<<<<<<<");
    print("${thatDayRide.year}-${thatDayRide.month}"
        "-${thatDayRide.day}");
    print("<<<<<<<<<<<<<<<<<");
    var from = await geoRef
        .within(
        center: centerStartLocation,
        radius: 3,
        field: 'from_location.position',
        strictMode: true)
        .first;

    ridesFrom = ScheduledRide.listFromFirestore(from);
    print("pppp rides from ${ridesFrom}");

    var to = await geoRef
        .within(
        center: centerEndLocation,
        radius: 3,
        field: 'to_location.position',
        strictMode: true)
        .first;

    ridesTo = ScheduledRide.listFromFirestore(to);
    print("ppe3pp ${ridesTo}");

    ridesTo.forEach((data) {
      print("dffo0w9 $data");
      ridesFrom.forEach((from) {
        print("dffo0w9 ${from.id} --- ${data.id}");
        if (from.id == data.id) {
          //make sure the ride showing is supposed to take place that day
          if (data.dateinMilliseconds > thatDayMorning.millisecondsSinceEpoch &&
              data.dateinMilliseconds < thatDayEvening.millisecondsSinceEpoch) {
            rides.add(data);
          }
          //rides.add(data);
        }
      });
    });

    return rides;
  }

  Future<List<User>> getRidersWithSameRoute(
      TheLocation fromLocation, TheLocation toLocation, DateTime time) async {
    List<User> users = [];
    List<User> usersFrom = [];
    List<User> usersTo = [];

    var collectionReference = database
        .collection(MyStrings.users())
        .where("drive_state", isEqualTo: 0);

    var geoRef = geo.collection(collectionRef: collectionReference);

    // Geo point of the Users Start location
    GeoFirePoint centerStartLocation =
        geo.point(latitude: fromLocation.lat, longitude: fromLocation.lon);

    // Geo point of the Users end location
    GeoFirePoint centerEndLocation =
        geo.point(latitude: toLocation.lat, longitude: toLocation.lon);
//    Query query = _queryPoint("s14mkjxj2", 'work_location.position', collectionReference);
//    query.get().catchError((error){
//      print(error.toString());
//    });
    var from = await geoRef
        .within(
            center: centerStartLocation,
            radius: 2,
            field: 'home_location.position',
            strictMode: true)
        .first;

    usersFrom = User.listFromFirestore(from);

    var to = await geoRef
        .within(
            center: centerEndLocation,
            radius: 2,
            field: 'work_location.position',
            strictMode: true)
        .first;

    usersTo = User.listFromFirestore(to);

    usersTo.forEach((data) {
      print("hhhhh ${data.phoneNumber}");
      usersFrom.forEach((from) {
        print("h44h ${from.phoneNumber}");
        if (from.phoneNumber == data.phoneNumber) {
          //make sure the ride showing is supposed to take place that day

          users.add(data);
        }
      });
    });

    return users;
  }

  Future<List<User>> getDriversWithSameRoute(
      TheLocation fromLocation, TheLocation toLocation, DateTime time) async {
    List<User> users = [];
    List<User> usersFrom = [];
    List<User> usersTo = [];

    var collectionReference = database
        .collection(MyStrings.users())
        .where("drive_state", isEqualTo: 0);

    var geoRef = geo.collection(collectionRef: collectionReference);

    // Geo point of the Users Start location
    GeoFirePoint centerStartLocation =
        geo.point(latitude: fromLocation.lat, longitude: fromLocation.lon);

    // Geo point of the Users end location
    GeoFirePoint centerEndLocation =
        geo.point(latitude: toLocation.lat, longitude: toLocation.lon);
//    Query query = _queryPoint("s14mkjxj2", 'from_location.position', collectionReference);
//    query.get().catchError((error){
//      print(error.toString());
//    });
    var from = await geoRef
        .within(
            center: centerStartLocation,
            radius: 2,
            field: 'home_location.position',
            strictMode: true)
        .first;

    usersFrom = User.listFromFirestore(from);

    var to = await geoRef
        .within(
            center: centerEndLocation,
            radius: 2,
            field: 'work_location.position',
            strictMode: true)
        .first;

    usersTo = User.listFromFirestore(to);

    usersTo.forEach((data) {
      usersFrom.forEach((from) {
        if (from.phoneNumber == data.phoneNumber) {
          //make sure the ride showing is supposed to take place that day

          users.add(data);
        }
      });
    });

    return users;
  }

  Stream<List<DocumentSnapshot>> getNearbyCommutters(User user) {
    var collectionReference = database.collectionGroup(MyStrings.users());
    var geoRef = geo.collection(collectionRef: collectionReference);
    GeoFirePoint center = geo.point(
        latitude: user.homeLocation.lat, longitude: user.homeLocation.lon);
//    Query query = _queryPoint("s14mkjxj2", 'home_location.position', collectionReference);
//    query.get().catchError((error){
//      print(error.toString());
//    });

    /// changed the kilometer radius to better reflect close commutters.
    // TODO: users should be able to choose thier radius apart themselves
    return geoRef.within(
        center: center,
        radius: 3,
        field: 'home_location.position',
        strictMode: true);
  }

  Stream<List<DocumentSnapshot>> getNearbyScheduledRide(User user) {
    var collectionReference = database.collection(MyStrings.rides());
    print(user.homeLocation.title);
    var geoRef = geo.collection(collectionRef: collectionReference);
    GeoFirePoint center = geo.point(
        latitude: user.homeLocation.lat, longitude: user.homeLocation.lon);
    return geoRef.within(
        center: center,
        radius: 30,
        field: 'from_location.position',
        strictMode: true);
  }

  Stream<DocumentSnapshot> getRide(ScheduledRide ride) {
    return database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .snapshots();
  }

  Query _queryPoint(String geoHash, String field, Query _collectionReference) {
    String end = '$geoHash~';
    Query temp = _collectionReference;
    return temp.orderBy('$field.geohash').startAt([geoHash]).endAt([end]);
  }

  Future<Map<String, dynamic>> updateRideRatings(ScheduledRide ride) async {
    Map<String, dynamic> result = Map();
    result['success'] = true;

    // DocumentReference rideReference = database
    //     .collection(MyStrings.users())
    //     .doc(ride.userId)
    //     .collection(MyStrings.rides())
    //     .doc(ride.id);

    // DocumentReference rideRatingReference = database
    //     .collection(MyStrings.users())
    //     .doc(ride.userId)
    //     .collection(MyStrings.rides())
    //     .doc(ride.id);

    // var batch = database.batch();
    // batch.update(rideReference, <String, dynamic>{
    //   'invited_riders': FieldValue.arrayRemove([userId])
    // });
    // if (accept == true) {
    //   batch.update(rideReference, <String, dynamic>{
    //     'riders': FieldValue.arrayUnion([userId])
    //   });

    //   //Set the state of the ride for a particular user
    //   batch.update(rideReference, <String, dynamic>{
    //     'rider_state': FieldValue.arrayUnion([2])
    //   });
    // }

    // await batch.commit().catchError((error) {
    //   result['success'] = false;
    //   result['message'] = error.toString();
    // });

    return result;
  }

  ScheduledRide createdSchedule(
      {User user,
      TheLocation fromLocation,
      TheLocation toLocation,
      double amount,
      DateTime time}) {
    return ScheduledRide(
        dateinMilliseconds:
            DateTime(time.year, time.month, time.day, time.hour, time.minute)
                .millisecondsSinceEpoch,
        userId: user.phoneNumber,
        userName: user.fullName,
        work: user.work,
        userProfilePix: user.avatar,
        userRatings: user.ratings,
        fromLocation: fromLocation,
        toLocation: toLocation,
        price: amount,
        ridersState: [0],
        time: "${time.hour}:${time.minute}",
        invitedRiders: [],
        riders: [user.phoneNumber],
        ridersRequest: [],
        rideState: RideState.SCHEDULED,
        driveOrRide: DriveOrRide.DRIVE);
  }

  @override
  Future<Res.Result<void>> submitRideRatings(
      Ratings ratings, ScheduledRide ride) async {
    Res.Result res = Res.Result();
    print("got to api class - ${ride.userId}");
    print("got t -${ratings.toFireStore()}-- ");
    res.error = false;
    await database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .update({"ratings": ratings.toFireStore()}).catchError((error) {
      print("error ${error.toString()}");
      res.error = true;
    });
    print("99999 ");
    return res;
  }

  @override
  Future<Res.Result<void>> setRiderStateToJoin(ScheduledRide ride, User user, List<dynamic> state) async{
    bool error = false;
    print("i got here sssssss");

    var batch = database.batch();

    DocumentReference paymentReference = database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .collection(MyStrings.transactions)
        .doc();

    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id);

    batch.update(rideReference, <String, dynamic>{
      'rider_state': state
    });
    batch.set(
        paymentReference,
        MobiTransaction.toMap(MobiTransaction(
            title: 'Payment for ride',
            description: 'You just paid for your ride with ${ride.userName} NGN${ride.price}',
            type: TransactionType.PAYMENT,
            amount: ride.price.toInt(),
            userFrom: user.fullName,
            userTo: ride.userName,
            iDfrom: user.phoneNumber,
            date: DateTime.now(),
            users: [ride.userId, user.phoneNumber],
            iDto: ride.userId)));
    print("i got here vvvvvv");

    await batch.commit().catchError((errr) {
      error = true;
      print("error = $errr");
    });

    return Res.Result(error: error);
  }

  @override
  Future<Res.Result<void>> updateRide(String userId, String rideId, DateTime time) async{
    Res.Result<void> res = Res.Result();
    res.error = false;
    await database
        .collection(MyStrings.users())
        .doc(userId)
        .collection(MyStrings.rides())
        .doc(rideId)
        .update({
      "date": time.millisecondsSinceEpoch,
      "time":"${time.hour}:${time.minute}"
        }).catchError((error) {
      print("error ${error.toString()}");
      res.error = true;
    });
    print("99999 ");
    return res;
  }
}

//Check if the the user is a driver or a rider
// if is a driver, fetch all the riders in that particular area
// fetch all the invited and requested users, with accepted users
//
// if it is a rider, fetch all the car owners in that route that have rides for that day
// fecth all the rides that he has sent invitation to
 