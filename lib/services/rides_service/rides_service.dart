import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/multi_ride.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/services/rides_service/rides_api.dart';

import 'dart:convert';


import '../../locator.dart';

abstract class AbstractRideService{
  Future<Result<void>> submitRideRatings(Ratings ratings, ScheduledRide ride);
  Future<Result<List<ScheduledRide>>> getRequestedRides(String userId);
  Future<Result<void>> setRiderStateToJoin(ScheduledRide scheduledRide,
      User user, List<dynamic> state);
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId);
  Future<Result<void>> updateRide(String userId, String rideId, DateTime time);

}

class RidesService extends AbstractRideService{
  final RidesApi _api = locator<RidesApi>();

  Future<Map<String, dynamic>> createScheduledRide(ScheduledRide scheduledRide, User user) async{
    final result = await _api.createScheduledRide(scheduledRide);

    if(result['success'] == false){
    }else{

    }
    return result;
  }

  Future<Map<String, dynamic>> updatecheduledRide(ScheduledRide scheduledRide, User user) async{
    final result = await _api.createScheduledRide(scheduledRide);

    if(result['success'] == false){
    }else{

    }
    return result;
  }

  Future<Map<String, dynamic>> create10ScheduledRide({User user,
    double amount,
    DateTime morning,
    DateTime evening
  }) async{
    final result = await _api.create10ScheduledRide(
      user: user,
      amount: amount,
      morning: morning,
      evening: evening
    );

    if(result['success'] == false){
    }else{

    }
    return result;
  }

  Future<Map<String, dynamic>> createListOfSchedule({User user,
    MultiRideModel multiRideModel
  }) async{
    final result = await _api.createListOfScheduledRide(
      user: user,
      multiRideModel: multiRideModel
    );


    return result;
  }





  Future<List<ScheduledRide>> getActiveRide(String userId) async{
    List<DocumentSnapshot> response = await _api.getScheduledRide(userId);
    

    if(response.length == 0){
      print("an error 3");
      return [];
    }else{
      //ScheduledRide ride = ScheduledRide.fromFirestore(response.data);

      return convertAndSaveRides(response);
    }
  }

  Future<List<ScheduledRide>> getAllRide(String userId) async{
    List<DocumentSnapshot> response = await _api.getAllRides(userId);


    if(response.length == 0){
      print("an error 1");
      return [];
    }else{
      //ScheduledRide ride = ScheduledRide.fromFirestore(response.data);

      List<ScheduledRide> rides = ScheduledRide.listFromFirestore(response);
      return rides;
    }
  }

  Future<List<ScheduledRide>> getInvitedRides(String userId) async{
    List<DocumentSnapshot> response = await _api.getInvitedRides(userId);


    if(response.length == 0){
      print("an error 2");
      return [];
    }else{
      //ScheduledRide ride = ScheduledRide.fromFirestore(response.data);

      List<ScheduledRide> rides = ScheduledRide.listFromFirestore(response);
      return rides;
    }
  }
  @override
  Future<Result<List<ScheduledRide>>> getRequestedRides(String userId) async{
    Result<List<ScheduledRide>> rs = Result();
    Result<List<DocumentSnapshot>> response = await _api.getRequestedRides(userId);
    rs.error = response.error;


    if(response.error == true){
      print("an error 2");
       rs.data = <ScheduledRide>[];
       return rs;
    }else{
      rs.data = ScheduledRide.listFromFirestore(response.data);
      return rs;
    }
  }

  Future<List<ScheduledRide>> convertAndSaveRides(List<DocumentSnapshot> snapshots) async{
    print("saving rides ${snapshots.length}");
      List<ScheduledRide> rides = ScheduledRide.listFromFirestore(snapshots);
      print("saving rides with ${rides.length}");
      return rides;
  }

  Stream<List<ScheduledRide>> getActiveRide2(String userId) {
    return _api.getScheduledRideWithStream(userId);
  }

  Future<List<DocumentSnapshot>> getNearbyCommutters(User user){
    return _api.getNearbyCommutters(user).first;
  }

  Future<List<ScheduledRide>> getAvailableRides(ScheduledRide scheduledRide){
    return _api.getAvailableRides(scheduledRide);
  }


  Future<List<User>> getRidersWithSameRoute({TheLocation fromLocation,
    TheLocation toLocation, DateTime time}){
    return _api.getRidersWithSameRoute(fromLocation,toLocation,time);
  }

  Future<bool> sendRideRequest(ScheduledRide scheduledRide, String userId){
    return _api.sendRideRequest(scheduledRide, userId);
  }


  Future<bool> setRideState(ScheduledRide scheduledRide, String userId, RideState state){
    return _api.setRideState(scheduledRide, userId, state);
  }

  Future<bool> setRiderState(ScheduledRide scheduledRide, String userId, List<dynamic> state){
    return _api.setRiderState(scheduledRide, userId, state);
  }
  @override
  Future<Result<void>> setRiderStateToJoin(ScheduledRide scheduledRide,
      User user, List<dynamic> state){
    return _api.setRiderStateToJoin(scheduledRide, user, state);
  }

  Future<Map<String, dynamic>> acceptOrDeclineRide(ScheduledRide scheduledRide, String userId, bool accept){
    return _api.acceptOrDeclineRide(scheduledRide, userId, accept);
  }

  Future<Map<String, dynamic>> acceptRideInvitation(ScheduledRide scheduledRide, String userId, bool accept){
    return _api.acceptRideInvitation(scheduledRide, userId, accept);
  }

  Future<Map<String, dynamic>> getRemoteRide(String rideId){
    return _api.getRemoteRide(rideId);
  }

  Future<List<DocumentSnapshot>> getRidesScheduledAroundUs(User user){
    print("got here");
    return _api.getNearbyScheduledRide(user).first;
  }

  Stream<DocumentSnapshot> getARideDetail(ScheduledRide ride){
    return _api.getRide(ride);
  }

  Future<Map<String, dynamic>> updateRideRatings(ScheduledRide ride){
    return _api.updateRideRatings(ride);
  }
  Stream<List<ScheduledRide>> tempGetAllAvailableRides(String userId){
    print("ppppp release service");
    return _api.tempGetAllAvailableRides(userId);
  }

  @override
  Future<Result<void>> submitRideRatings(Ratings ratings, ScheduledRide ride) {

    return _api.submitRideRatings(ratings, ride);
  }

  @override
  Future<List<ScheduledRide>> tempGetAllAvailableRidesNonStream(String userId) {
    return _api.tempGetAllAvailableRidesNonStream(userId);
  }

  @override
  Future<Result<void>> updateRide(String userId, String rideId, DateTime time) {
    return _api.updateRide(userId,rideId,time);
  }


}