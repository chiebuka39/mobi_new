import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/coupon_model.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/user.dart';

abstract class AbsProfileApi{
  Future<bool> checkIfUserHasActivatedInviteCoupon();
  Future<bool> addCouponToUser(CouponModel couponModel);
  Future<Map<String, dynamic>> getSignUpsFromCoupon(String couponId);
  Future<Result<void>> updateWorkDetails(User user);
  Future<Result<int>> getNumberCompletedRidesFromUser(User user);
  Future<Result<void>> setWithdrawnAmount(double amount,User user);


  Future<void> createUserProfile(User user);
  Future<Result<TheLocation>> fetchChurches(User user);
  Future<Result<void>> addChurch(TheLocation location, User user);
}

class ProfileApi extends AbsProfileApi{
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  //String users = "users_production";

  @override
  Future<Map<String,dynamic>> createUserProfile(User user) async {
    Map<String,dynamic> result = Map();
    result['error'] = false;

  await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .set(user.toFirestore()).catchError((error){
          result['error'] = true;
    });

    return result;
  }
/// fetch a single user using its coupon idtr
  Future<User> fetchUserWithCouponId(String couponId) async {
    final response = await database
        .collection(MyStrings.users())
        .where('coupon_id',
        isEqualTo: couponId).get();
    final users = User.listFromFirestore(response.docs);
    if(users.length > 0){
      return users.first;
    }
    return null;
  }

  Future<void> updatePersonalProfile(User user) async {
    final response = await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update(user.toPersonalFirestore());

    return response;
  }

  Future<User> getUser(String userId, {bool saveUser = true}) async {
    final response = await database
        .collection(MyStrings.users())
        .doc(userId).get();


    if (!response.exists) {
      return null;
    } else {
      return User.fromFirestore(response.data());
    }
  }
  Stream<User> listenForUser(String userId, {bool saveUser = true})  {
    var streamTransformer =
    StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, User>.fromHandlers(
      handleData: (DocumentSnapshot data, EventSink sink) {
        sink.add(User.fromFirestore(data.data()));
      },
      handleError: (error, stacktrace, sink) {
        print("ppppp release error");
        sink.addError('Something went wrong: $error');
      },
      handleDone: (sink) {
        sink.close();
      },
    );
    final response =  database
        .collection(MyStrings.users())
        .doc(userId).snapshots();


    return response.transform(streamTransformer).asBroadcastStream();
  }

  Future<dynamic> uploadUserProfile(File file, String phoneNum) async {
    var storageRef = storage.ref().child(MyStrings.profileLocation(phoneNum));
    var task = storageRef.putFile(file);
    //await task.whenComplete(() => null);
    var r =await task.whenComplete(() {});

    return r.ref.getDownloadURL();

  }

  Future<dynamic> uploadFile(File file, String phoneNum, String docType) async {
    var storageRef = storage.ref().child(MyStrings.userDocsLocation(phoneNum,docType));
    var task = storageRef.putFile(file);
    var r =await task.whenComplete(() {});

    return r.ref.getDownloadURL();
  }

  Future<String> updateUser(User user, {TheLocation homeLocation, TheLocation workLocation}) async {
    String response1 = "";
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update({
      'home_location': TheLocation.toFireStore( homeLocation ?? user.homeLocation),
      'work_location': TheLocation.toFireStore(workLocation ?? user.workLocation)
    }).catchError((error) {
      pprint(error.toString());
      response1 = error.toString();
    });

    return response1;
  }

  Future<Map<String, dynamic>> addConnection(Connection connection) async {
    Map<String, dynamic> result = Map();
    result['error'] = false;
    await database
        .collection(MyStrings.users())
        .doc(connection.userId)
        .collection("connections")
        .doc(connection.connectionId)
        .set(connection.toMap())
        .catchError((error) {
      pprint(error.toString());
      result['error'] = false;
      result['message'] = error.toString();
    });


    return result;
  }

  Future<List<Connection>> getConnections(String userId) async {
    var querySnapshot = await database
        .collection(MyStrings.users()).doc(userId).collection("connections").get();

    List<Connection> connections = [];
     querySnapshot.docs.forEach((doc){
       connections.add(Connection.fromFirestore(doc.data()));
     });

     return connections;
  }

  Future<String> updateUserCarDetails(User user) async {
    String response1 = "";
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update({
      'date_updated': Timestamp.now(),
      'car_details': user.carDetails.toMap2()
        }).catchError(
            (error) {
      response1 = error.toString();
    });

    return response1;
  }

  Future<String> updateSocialAccountUrl(User user) async {
    String response1 = "";
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update({'accounts': user.accounts.toMap2(user.accounts)}).catchError(
            (error) {
      response1 = error.toString();
    });

    return response1;
  }

  Future<dynamic> uploapImage(File carImage, User user, String type) async {
    var storageRef = storage.ref().child("${user.phoneNumber}/$type.jpg");
    var task = storageRef.putFile(carImage);
    var r =await task.whenComplete(() {});

    return r.ref.getDownloadURL();
  }

  Future<Map<String, dynamic>> updateUserDetails(User user, String field, String value) async{
    Map<String, dynamic> response1 = Map();
    response1['error'] = false;
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update({field: value}).catchError(
            (error) {
          response1['message'] = error.toString();
          response1['error'] = true;
        });

    return response1;
  }

  @override
  Future<bool> checkIfUserHasActivatedInviteCoupon() {

    return null;
  }

  @override
  Future<bool> addCouponToUser(CouponModel couponModel) async{

    try{
      await database
          .collection(MyStrings.users())
          .doc(couponModel.userId).collection('coupons')
          .add(CouponModel.toJson(couponModel));
    }catch(e){
      return false;
    }


    return true;
  }

  @override
  Future<Map<String, dynamic>> getSignUpsFromCoupon(String couponId) async{
    Map<String,dynamic> result = Map();
    result['error'] = false;
    var querySnapshot = await database
        .collection(MyStrings.users())
        .where('used_coupons',arrayContains: couponId)
        .get().catchError((error){
          result['error'] = true;
    });

    print("i got here---");
    if(result['error'] == false){
      List<User> users = User.listFromFirestore(querySnapshot.docs);
      print("oooo $couponId ${users.length}");
      result['users'] = users;
    }


    return result;
  }

  @override
  Future<Result<void>> updateWorkDetails(User user) async{
    var result = Result(error: false);
    print("uploading stuff");
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update(user.toWorkFirestore()).catchError((error){
          result.error = true;
    });

    return result;
  }

  @override
  Future<Result<int>> getNumberCompletedRidesFromUser(User user) async{

    Result<int> res = Result(error: false,data: 0);
    var querySnapshot = await database
        .collectionGroup(MyStrings.rides())
        .where('riders',arrayContains: user.phoneNumber)
        .where('ride_state', isEqualTo: 1)
        .get().catchError((error){
      res.error = true;
    });


    if(res.error == false){
      res.data = querySnapshot.docs.length;
    }

    return res;
  }

  @override
  Future<Result<void>> setWithdrawnAmount(double amount, User user) async{
    var result = Result(error: false);
    print("uploading stuff");
    await database
        .collection(MyStrings.users())
        .doc(user.phoneNumber)
        .update({
      'coupon_balance_withdrawn': amount
    }).catchError((error){
      result.error = true;
    });

    return result;
  }

  @override
  Future<Result<void>> addChurch(TheLocation location, User user) async{
    var result = Result(error: false);
    print("uploading stuff");
    try{
      database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.address())
          .add(TheLocation.toMap(location));
    }catch(e){
      result.error = true;
    }


    return result;
  }

  @override
  Future<Result<TheLocation>> fetchChurches(User user) async{

    Result<TheLocation> res = Result(error: false);

    try{
      var querySnapshot = await database
          .collection(MyStrings.users())
          .doc(user.phoneNumber)
          .collection(MyStrings.address())
          .where('type', isEqualTo: "church")
          .get();

      res.data = TheLocation.fromMap(querySnapshot.docs.first.data());

    }catch(e){
      res.error = true;
    }


    return res;
  }


}
