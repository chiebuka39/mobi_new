import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobi/api/profile_api.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/local/local_state.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/multi_ride.dart';
import 'package:mobi/models/secondary_state.dart';
import 'package:mobi/models/user.dart' as u;
import 'package:mobi/viewmodels/user_repo.dart';

import '../locator.dart';
abstract class AbsUserModel extends ChangeNotifier{
  String _coupon;
  String get coupon => _coupon;




  Future<u.User> fetchUserWithCouponId(String couponId);
  Stream<u.User> listenForUser(String phoneNumber);
  Future<bool> checkIfUserHasActivatedInviteCoupon();
  Future<void> checkAndGetUser();
  Future<Result<u.User>> updateWorkDetails(File file,u.User user,String docType);
  Future<Map<String, dynamic>> createUserProfile(u.User user, File profile);
  Future<Map<String, dynamic>> getSignUpsFromCoupon();
  Future<Result<void>> setWithdrawnAmount(double amount, u.User user);
  Future<Result<void>> addChurch(TheLocation location, u.User user);
  Future<Result<TheLocation>> fetchChurches( u.User user);
  Future<Result<List<int>>> getNumberCompletedRidesFromUsers(List<u.User> users);

}
class UserModel extends AbsUserModel{
  final ProfileApi _api = locator<ProfileApi>();
  final ProfileRepository _repo = locator<ProfileRepository>();
  final ABSAppStateLocalStorage _localStorage =
  locator<ABSAppStateLocalStorage>();

  u.User _user;
  MultiRideModel _multiRideModel = MultiRideModel();
  List<Connection> _connections = [];
  List<Connection> _coworkers = [];
  List<Connection> _neigbors = [];
  List<Connection> _connects= [];
  ViewState _viewState = ViewState.IDLE;

  u.User get user => _user;
  MultiRideModel get multiRideModel => _multiRideModel;
  List<Connection> get connections => _connections;
  List<Connection> get neigbhors => _neigbors;
  List<Connection> get coworkers => _coworkers;
  List<Connection> get connects => _connects;
  ViewState get viewState => _viewState;

  bool newRide;

  set coupon(String coupon1) {
    _coupon = coupon1;
    notifyListeners();
  }



  set connections(List<Connection> connect){
    _connections = connect;
    notifyListeners();
  }

  set multiRideModel(MultiRideModel value){
    _multiRideModel = value;
    notifyListeners();
  }
  set user(u.User value){
    _user = value;
    _localStorage.saveUserState(value);
    notifyListeners();
  }



  UserModel(){
    _user = _localStorage.getUser();
  }

  Future<Map<String, dynamic>> updateUserCarDetails(u.User user, String plateNumber, String color, String model,[File licenseImage, File carImage]) async{
    Map<String, dynamic> result = await _repo.updateUserCarDetails(user, licenseImage, carImage, plateNumber, color, model);

    if(result['error'] == false){
      u.User user2 = _user;
      user2.carDetails = result['detail'] as CarDetails;
      user = user2;
    }

    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> updateUserProfileSocialAccounts(u.User user3, SocialAccounts url) async{
    Map<String, dynamic> result = await _repo.updateUserSocialAccount(user3, url);

    if(result['error'] == false){
      u.User user2 = _user;
      user2.accounts = url;
      user = user2;

    }

    notifyListeners();
    return result;

  }

  void setState(ViewState state){
    _viewState = state;
    notifyListeners();
  }

  void setUser(u.User user2)async{
   user = user2;
    notifyListeners();
  }
  void setUserOnLogin(u.User user)async{
    _localStorage.saveUserState(user);
    _localStorage.saveSecondaryState(SecondaryState(true));
    _user = user;
    notifyListeners();
  }
  void setUserBalance(int amount)async{
    u.User user2 = _user;
    user2.balance = _user.balance + amount;
    setUser(user2);

    notifyListeners();
  }

  void substractUserBalance(int amount)async{
    u.User user2 = _user;
    user2.balance = _user.balance - amount;
    user = user2;
    notifyListeners();
  }

  void addRideId(String id){

    //_user.scheduledRideIds.add(id);
    notifyListeners();
  }

  void setUserHomeLocation(TheLocation homeLocation){
    _user.homeLocation = homeLocation;
    notifyListeners();
  }

  void setUserWorkLocation(TheLocation workLocation){
    _user.workLocation = workLocation;
    notifyListeners();
  }

  Future<u.User> getUser(String phoneNumber) async{
    u.User user = await _api.getUser(phoneNumber);

    if(user != null){
      if(user.couponId.isEmpty){
        String coupon = "${user.fullName.substring(0,3)}"
            "${user.phoneNumber.substring(10)}";
        var result = await _api.updateUserDetails(user,
            'coupon_id',coupon);
        if(result['error'] == false){
          user.couponId = coupon;
        }
      }

      setUserOnLogin(user);
    }
    return user;
  }

  Future<String> updateUser({TheLocation homeLocation, TheLocation workLocation}) async{
    setState(ViewState.LOADING);
    var response = await _api.updateUser(_user,homeLocation: homeLocation, workLocation: workLocation);
    if(response.isEmpty){
      u.User user2 = _user;
      user2.homeLocation = homeLocation;
      user2.workLocation = workLocation;
      user = user2;
    }
    setState(ViewState.IDLE);
    return response;
  }

  Future<String> updateUser2(TheLocation homeLocation, TheLocation workLocation,
      [TimeOfDayCustom leaveForHome, TimeOfDayCustom leaveForWork]) async{
   u.User user2 = u.User.fromUser(_user);
   print("harrry ${homeLocation.title}");
   print("teddy ${homeLocation.title}");
   user2.homeLocation = homeLocation;
   user2.workLocation = workLocation;
   user2.leaveForWork = leaveForWork;
   user2.leaveForHome = leaveForHome;
   print("teddy ${user2.homeLocation.title}");
    var response = await _api.updateUser(user2);
    if(response.isEmpty){

      user = user2;
      notifyListeners();
    }

    return response;
  }


  Future<Map<String, dynamic>> addConnection(Connection connection) async{

    var response = await _api.addConnection(connection);
    if(response['error'] == false){
      List<Connection> connection1 = List.from(connections)..add(connection);

      connections = connection1;
    }
    return response;
  }

  Future<List<Connection>> getConnections() async{

    if(_user != null){
      var response = await _api.getConnections(user.phoneNumber);
      print("I got this response from $response");
      if(response.length > 0){
        connections = response;
      }else{
        connections = [];
      }
      return response;
    }else {
      return [];
    }

  }

  Future<u.User> getAUser(String phone) async{
    u.User user = await _api.getUser(phone,saveUser: false);
    if(user != null){

    }
    return user;
  }

  Future<List<u.User>> getAllUsers(List ids) async{
    List<u.User> users = [];
    List<Future<u.User>> futures = [];
    print("all ${ids}");
    ids.forEach((id) {
      futures.add(_api.getUser(id, saveUser: false));
    });

    users = await Future.wait(futures);
    return users;
  }

  Stream<QuerySnapshot> getUserTransactions(){
    List<u.MobiTransaction> transactions = [];
    print("llllll ${_user.phoneNumber}");
    Stream<QuerySnapshot> result = FirebaseFirestore.instance.collectionGroup('transactions')
        .where('users', arrayContains: _user.phoneNumber).orderBy('date',descending: true).snapshots();
    //print("bjdbd ${_user.phoneNumber}");

    return result;
  }

  Future<QuerySnapshot> getUserTransactions2()async{
    List<u.MobiTransaction> transactions = [];
    print("llllll222 ${_user.phoneNumber}");
    QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('transactions')
        .where('users', arrayContains: "+2348161167994").get();
    print("bjdbdrr33 ${result.docs.length}");

    return result;
  }

  Future<void> checkAndGetUser() async {
    var user1 = await _repo.getUser(_user.phoneNumber);
    if(user != null){
      setUser(user1);
    }
  }

  @override
  Future<u.User> fetchUserWithCouponId(String couponId) {
    return _api.fetchUserWithCouponId(couponId);
  }

  @override
  Future<bool> checkIfUserHasActivatedInviteCoupon() {

    return null;
  }

  @override
  Future<Map<String, dynamic>> createUserProfile(u.User user1, File profile) async{
    var result = await _repo.createUserProfile(user1, profile);

    if(result['error'] == false){
      user = user1;
    }
    return result;

  }

  @override
  Future<Map<String, dynamic>> getSignUpsFromCoupon() {
    return _repo.getSignUpsFromCoupon(_user.couponId);
  }

  @override
  Future<Result<u.User>> updateWorkDetails(File file,u.User user,String docType) async{
    var result = await _repo.updateWorkDetails(file, user, docType);
    if(result.error == false){
      user = result.data;
    }
    return result;
  }

  @override
  Future<Result<List<int>>> getNumberCompletedRidesFromUsers(List<u.User> users) {
    print("ppppp");
    return _repo.getNumberCompletedRidesFromUsers(users);
  }

  @override
  Future<Result<void>> setWithdrawnAmount(double amount, u.User user) {
    _repo.setWithdrawnAmount(amount, user);
  }

  @override
  Stream<u.User> listenForUser(String phoneNumber) {
    return _api.listenForUser(phoneNumber);
  }

  @override
  Future<Result<void>> addChurch(TheLocation location, u.User user) {
    return _api.addChurch(location,user);
  }

  @override
  Future<Result<TheLocation>> fetchChurches(u.User user) {
    return _api.fetchChurches(user);
  }


}