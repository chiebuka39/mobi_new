import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/multi_ride.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/search_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/extras/result.dart' as Res;
import 'package:mobi/services/dialogs/dialog_service.dart';
import 'package:mobi/services/rides_service/rides_api.dart';
import 'package:mobi/services/rides_service/rides_service.dart';

import '../locator.dart';

abstract class AbstractRideViewModel extends ChangeNotifier{
  Future<Result<void>> submitRideRatings(Ratings ratings, ScheduledRide ride);
  Future<List<ScheduledRide>> getInvitedRides(String userId);
  Future<Result<void>> setRiderStateToJoin(ScheduledRide scheduledRide, User user, List<dynamic> state);
  Future<Result<List<ScheduledRide>>> getRequestedRides(String userId);
  Future<Result<void>> updateRide(String userId, String rideId,DateTime time);
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId);
  Future<List<SearchRide>> fetchSearchRides(User user,{Position position});
  Future<List<ScheduledRide>> fetchSearchRides2(User user,{TheLocation fromLoc, TheLocation toLoc});
  Future<Map<String, dynamic>> makeRideRequest(ScheduledRide scheduledRidee, User user);
  Future<Res.Result<void>> createSearchRide(
      ScheduledRide scheduledRide);
}

class RidesViewModel extends AbstractRideViewModel{

  final RidesService _ridesService = locator<RidesService>();
  final RidesApi _api = locator<RidesApi>();
  DialogService _dialogService = locator<DialogService>();

  ScheduledRide _scheduledRide;
  List<ScheduledRide> _scheduledRideList;
  List<ScheduledRide> _allRideList = [];
  List<ScheduledRide> _invitedRideList = [];
  StreamSubscription _scheduledRidesstreamSubscription;
  StreamSubscription get scheduledRidesStreamSubscription => _scheduledRidesstreamSubscription;

  PostState _state = PostState.INIT;

  ModelState _nearbyCommuttersState = ModelState.LOADING;
  ModelState get nearbyCommuttersState => _nearbyCommuttersState;

  ModelState _nearbyRidersState = ModelState.LOADING;
  ModelState get nearbyRidersState => _nearbyRidersState;

  PostState get state => _state;
  ScheduledRide get scheduledRide => _scheduledRide;
  List<ScheduledRide> get scheduledRideList => _scheduledRideList;
  List<ScheduledRide> get allRideList => _allRideList;
  List<ScheduledRide> get invitedRideList => _invitedRideList;
  bool _deleteRides = false;
  bool get deleteRides => _deleteRides;

  List<User> _nearbyCommutters = [];

  List<User> get nearbyCommutters => _nearbyCommutters;


  List<ScheduledRide> _nearByRides;

  List<ScheduledRide> get nearbyRides => _nearByRides;

  set scheduledRidesStreamSubscription(StreamSubscription subscription){
    _scheduledRidesstreamSubscription = subscription;
    notifyListeners();
  }



  set nearbyCommutters(List<User> users){
    if(users.length == 0){
      _nearbyCommutters = users;
      _nearbyCommuttersState = ModelState.EMPTY;
    }else{
      _nearbyCommutters = users;
      _nearbyCommuttersState = ModelState.COMPLETE;
    }

    notifyListeners();
  }


  set nearbyRiders(List<ScheduledRide> rides){
    if(rides.length == 0){
      _nearByRides = rides;
      _nearbyRidersState = ModelState.EMPTY;
    }else{
      _nearByRides = rides;
      _nearbyRidersState = ModelState.COMPLETE;
    }

    notifyListeners();
  }




  set state(PostState value){
    _state = value;
    notifyListeners();
  }

  set scheduledRide(ScheduledRide value){
     _scheduledRide = value;
     _state = PostState.COMPLETE;
  }

  set scheduleRideList(List<ScheduledRide> rides){
    if(rides.isNotEmpty){
      _scheduledRideList = rides;
      //preferences.setString(MyStrings.scheduledRide, userRidesToJson(rides));
      notifyListeners();
    }else{
      setEmptyList();
    }


  }

  setEmptyList(){
    print("got to this third delet");
    _scheduledRideList = [];
    //preferences.setString(MyStrings.scheduledRide, userRidesToJson(_scheduledRideList));
    notifyListeners();
  }

  setListToEmpty(){
    _scheduledRideList = [];
    notifyListeners();
  }

  @override
  Future<Map<String, dynamic>> makeRideRequest(ScheduledRide scheduledRidee, User user) async{
    state = PostState.POSTING;
    print(_state);
    scheduledRidee.ridersState = [2];
    Map<String, dynamic> result = await _ridesService.createScheduledRide(scheduledRidee, user);
    if(result['success'] == true){
      scheduledRide = scheduledRidee;
      add(scheduledRidee);
    }else{
      state = PostState.ERROR;
    }
    return result;

  }

  @override
  Future<Res.Result<void>> createSearchRide(ScheduledRide scheduledRidee) async{
    return _api.createSearchRide(scheduledRidee);
  }

  Future<Map<String, dynamic>> makeRideUpdateRequest(ScheduledRide scheduledRidee, User user) async{
    state = PostState.POSTING;
    print(_state);
    scheduledRidee.ridersState = [2];
    Map<String, dynamic> result = await _ridesService.updatecheduledRide(scheduledRidee, user);
    if(result['success'] == true){
      scheduledRide = scheduledRidee;
      add(scheduledRidee);
    }else{
      state = PostState.ERROR;
    }
    return result;

  }

  Future<Map<String, dynamic>> create10ScheduledRide({User user,
    double amount,
    DateTime morning,
    DateTime evening,
  }) async{
    final result = await _ridesService.create10ScheduledRide(
        user: user,
        amount: amount,
        morning: morning,
        evening: evening,
    );

    return result;
  }

  Future<Map<String, dynamic>> createListOfSchedule({User user,
    MultiRideModel multiRideModel
  }) async{
    final result = await _ridesService.createListOfSchedule(
        user: user,
        multiRideModel: multiRideModel
    );

    return result;
  }

  Future<void> getActiveRidesAndSave(String userId) async{
    var result = await _ridesService.getActiveRide(userId);

    if(result != null){
      scheduleRideList = result;
    }
  }

  Future<List<ScheduledRide>> getAllRides(String userId) async{
    var result = await _ridesService.getAllRide(userId);

    if(result != null){
      _allRideList = result;
      notifyListeners();
      return result;
    }else{
      return [];
    }
  }

  @override
  Future<List<ScheduledRide>> getInvitedRides(String userId) async{
    var result = await _ridesService.getInvitedRides(userId);

    if(result != null){
      _invitedRideList = result;
      notifyListeners();
      return result;
    }else{
      return [];
    }
  }


  Stream<List<ScheduledRide>> getActiveRidesAndSave3(String userId) {
    return _ridesService.getActiveRide2(userId);
  }

  

  Future<List<DocumentSnapshot>> fetchNearByCommutters(User user) async{
    var result = await _ridesService.getNearbyCommutters(user);
    List<User> users = List();
    int count = 0;
    print("nearby commuters are ${result.length}");
    result.forEach((snap){
      if(count < 10){
        User fetcheduser = User.fromFirestore(snap.data());
        if(fetcheduser.phoneNumber != user.phoneNumber){
          users.add(fetcheduser);
        }
        print(fetcheduser.fullName);
        print(fetcheduser.phoneNumber);

      }
      count ++;
    });

    nearbyCommutters = users;
    notifyListeners();
    //nearbyCommutters = [];

    return result;
  }

  Future<List<ScheduledRide>> fetchAvailableRides(ScheduledRide scheduledRide) async{
    var rides = await _ridesService.getAvailableRides(scheduledRide);

    return rides;
  }
  Future<List<SearchRide>> fetchSearchRides(User user,{Position position}) async{
    var rides = await _api.fetchSearchRides(user, position:position);

    return rides;
  }

  @override
  Future<List<ScheduledRide>> fetchSearchRides2(User user,{TheLocation fromLoc, TheLocation toLoc}) async{
    var rides = await _api.fetchSearchRides2(user,fromLoc: fromLoc,toLoc: toLoc);

    return rides;
  }

  Future<List<User>> getRidersWithSameRoute({TheLocation fromLocation,
    TheLocation toLocation, DateTime time}){
    return _ridesService.getRidersWithSameRoute(
        fromLocation:fromLocation,
        toLocation:toLocation,time:time);
  }

  Future<bool> sendRideRequest(ScheduledRide scheduledRide, String userId) async{
    var successful = await _ridesService.sendRideRequest(scheduledRide, userId);
    if(successful == true){
      add(scheduledRide);
    }
    return successful;
  }

  Future<bool> setRideState(ScheduledRide scheduledRide, String userId, RideState state) async{
    var successful = await _ridesService.setRideState(scheduledRide, userId, state);
    if(successful == true && ((state == RideState.CANCELLED) || state == RideState.ENDED)){
      delete(scheduledRide);
    }else if(successful == true){
      updateState(scheduledRide);
    }
    return successful;
  }

  Future<bool> setRiderState(ScheduledRide scheduledRide, String userId, List<dynamic> state) async{
    var successful = await _ridesService.setRiderState(scheduledRide, userId, state);
    if(successful == true){

    }else if(successful == true){

    }
    return successful;
  }

  ///  * [User], can Accept and decline a ride by the some one who is requesting
  ///
  ///  * The [catalog of layout widgets](https://flutter.dev/widgets/layout/).
  Future<Map<String, dynamic>> acceptOrDeclineRide(ScheduledRide scheduledRide, String userId, bool accept) async{
    var result = await _ridesService.acceptOrDeclineRide(scheduledRide, userId, accept);
    if(result['success'] == true){
      scheduledRide.ridersRequest = List.from(scheduledRide.ridersRequest)..remove(userId);
      update(scheduledRide, accept, userId);
    }
    return result;
  }

  ///  * [User], can Accept a ride invitation
  ///
  ///  * The [catalog of layout widgets](https://flutter.dev/widgets/layout/).
  Future<Map<String, dynamic>> acceptRideInvitation(ScheduledRide scheduledRide, String userId, bool accept) async{
    var result = await _ridesService.acceptRideInvitation(scheduledRide, userId, accept);
    return result;
  }

  /// THis is to cancle a ride that a user has already booked.
  /// I am to delete the ride after completing this process.
  Future<Map<String, dynamic>> cancelRide(ScheduledRide scheduledRide, String userId, bool accept) async{
    var result = await _ridesService.acceptOrDeclineRide(scheduledRide, userId, accept);
    if(result['success'] == true){
      //scheduledRide.ridersRequest = List.from(scheduledRide.ridersRequest)..remove(userId);
      //update(scheduledRide, accept, userId);
      delete(scheduledRide, reset: true);
    }
    return result;
  }


  Future<List<DocumentSnapshot>> fetchNearbyScheduledRides(User user) async{
    var result = await _ridesService.getRidesScheduledAroundUs(user);
    List<ScheduledRide> rides = List();
    int count = 0;
    result.forEach((snap){
      if(count < 10){
        ScheduledRide fetchedrides = ScheduledRide.fromFirestore(snap.data());
        if(fetchedrides.userId != user.phoneNumber){
          rides.add(fetchedrides);
        }
        print("${fetchedrides.userName} hk");

      }
      count ++;
    });

    nearbyRiders = rides;

    return result;
  }



  void add(ScheduledRide scheduledRidee) {
    _scheduledRideList.add(scheduledRidee);
    notifyListeners();
  }

  void update(ScheduledRide scheduledRide, bool accept, String userId) {
    _scheduledRideList.forEach((ride){
      if(ride.id == scheduledRide.id){
        ride.ridersRequest = List.from( ride.ridersRequest)..remove(userId);
        if(accept == true){
          ride.riders = List.from( ride.riders)..add(userId);
          ride.ridersState = List.from(ride.ridersState)..add(2);
        }
      }
    });

    scheduleRideList = _scheduledRideList;
  }

  void delete(ScheduledRide scheduledRide, {bool reset = false}) {

    print("got to delete");
    List<ScheduledRide> rides = List.from(_scheduledRideList)..removeWhere((item)=> item.id == scheduledRide.id);

    if(rides.isEmpty){
      setEmptyList();
    }else{
      scheduleRideList = rides;
    }
    if(reset == true){

    }


    print("got to jjj delete ${rides.length}");

  }

  void updateState(ScheduledRide scheduledRide) {
    List<ScheduledRide> rides = List.from(_scheduledRideList);

    rides.forEach((ride){
      if(ride.id == scheduledRide.id){
        ride = scheduledRide;
      }
    });

    scheduleRideList = rides;
  }

  Stream<DocumentSnapshot> getRide(ScheduledRide ride){
    return _ridesService.getARideDetail(ride);
  }

  Future<Map<String, dynamic>> getRemoteRide(String rideId){
    return _ridesService.getRemoteRide(rideId);
  }

  Stream<List<ScheduledRide>> tempGetAllAvailableRides(String userId){
    return _ridesService.tempGetAllAvailableRides(userId);
  }

  @override
  Future<Result<void>> submitRideRatings(Ratings ratings, ScheduledRide ride) {
    print("got to view model");
    return _ridesService.submitRideRatings(ratings, ride);
  }


  @override
  Future<Result<List<ScheduledRide>>> getRequestedRides(String userId) {
    return _ridesService.getRequestedRides(userId);
  }

  @override
  Future<Result<void>> setRiderStateToJoin(ScheduledRide scheduledRide,
      User user, List<dynamic> state) {
    print("ppppp tttt");
    return _ridesService.setRiderStateToJoin(scheduledRide, user, state);
  }

  @override
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId) {
    return _ridesService.tempGetAllAvailableRidesNonStream(userId);
  }

  @override
  Future<Result<void>> updateRide(String userId, String rideId, DateTime time) {
    return _ridesService.updateRide(userId,rideId,time);
  }





}