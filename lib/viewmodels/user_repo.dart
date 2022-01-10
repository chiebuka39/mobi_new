import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/api/profile_api.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/local/local_state.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/user.dart';
abstract class AProfileRepository{
  Future<Map<String,dynamic>> createUserProfile(User user, File profile);
  Future<User> getUser(String userId);
  Future<Result<User>> updateWorkDetails(File image,User user,String docType);
  Future<Map<String, dynamic>> getSignUpsFromCoupon(String couponId);
  Future<Result<List<int>>> getNumberCompletedRidesFromUsers(List<User> users);
  Future<Result<void>> setWithdrawnAmount(double amount, User user);

}
class ProfileRepository extends AProfileRepository{
  final ProfileApi _api = locator<ProfileApi>();
  final ABSAppStateLocalStorage _localStorage =
  locator<ABSAppStateLocalStorage>();

  @override
  Future<Map<String,dynamic>> createUserProfile(User user, File profile) async {
    Map<String, dynamic> result = Map();

    user.avatar = await _api.uploadUserProfile(profile, user.phoneNumber);
    final result1 = await _api.createUserProfile(user);
    if(result1['error'] ==false){

      return result1;
    }else{
      result['error'] = true;
      return result;
    }

  }

  Future<User> updatePersonalDetails(User user, [File profile]) async {
    if(profile != null){
      user.avatar = await _api.uploadUserProfile(profile, user.phoneNumber);
    }
    final result = await _api.updatePersonalProfile(user);

    return user;
  }

  Future<Map<String, dynamic>> updateUserCarDetails(
      User user, File licenseImage, File carImage, String plateNumber, String color, String model) async {
    print("called here");
    String carImageUrl;
    String licenseImageUrl;
    if(carImage != null){
       carImageUrl = await _api.uploapImage(carImage, user,"car");
    }

    if(licenseImage != null){
      licenseImageUrl = await _api.uploapImage(licenseImage, user,"licence");
    }


    CarDetails carDetails = CarDetails(
        carImageUrl: carImageUrl ?? user.carDetails.carImageUrl,
        licenseImageUrl: licenseImageUrl ?? user.carDetails.licenseImageUrl,
        carColor: color,
        carModel: model,
        plateNumber: plateNumber);
    user.carDetails = carDetails;
    //user.verified = true;
    String result = await _api.updateUserCarDetails(user);

    if(result.isEmpty){

      return {"error": false,"detail": carDetails};
    }else{
      return {"error": true,"detail": result};
    }
  }

  Future<Map<String, dynamic>> updateUserSocialAccount(
      User user, SocialAccounts accounts) async {
    print("called here");
    user.accounts = accounts;
    String result = await _api.updateSocialAccountUrl(user);

    if(result.isEmpty){

      return {"error": false,"detail": result};
    }else{
      return {"error": true,"detail": result};
    }
  }

  Future<Map<String, dynamic>> addConnection(Connection connection) async{

    var response = await _api.addConnection(connection);

    return response;
  }

  Future<List<Connection>> getUserConnections(String userId) async{

    var response = await _api.getConnections(userId);

    return response;
  }

  @override
  Future<User> getUser(String userId) {
    return _api.getUser(userId);
  }

  @override
  Future<Map<String, dynamic>> getSignUpsFromCoupon(String couponId) {
    return _api.getSignUpsFromCoupon(couponId);
  }

  @override
  Future<Result<User>> updateWorkDetails(File image,User user,String docType) async{
    if(image != null){
      user.workIdentityUrl = await _api.uploadFile(image, user.phoneNumber,docType);
    }
    final result = await _api.updateWorkDetails(user);
    return Result<User>(error: result.error,data: user);
  }

  @override
  Future<Result<List<int>>> getNumberCompletedRidesFromUsers(List<User> users) async{
    List<int> ridesPerUser = [];
    List<Result<int>> rides = [];
    List<Future<Result<int>>> futures = [];
    print("mmmmmm");
    users.forEach((id) {
      futures.add(_api.getNumberCompletedRidesFromUser(id));
    });
    print("wwwww");
    rides = await Future.wait(futures);
    print("55555");

    rides.forEach((element) {
      ridesPerUser.add(element.data);
    });


    return Result<List<int>>(error: false,data: ridesPerUser);
  }

  @override
  Future<Result<void>> setWithdrawnAmount(double amount, User user) {
    return _api.setWithdrawnAmount(amount, user);
  }

}
