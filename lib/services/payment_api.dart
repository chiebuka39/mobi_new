import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/bank.dart';
import 'package:mobi/models/user.dart';


abstract class ABSPaymentApi {
  Future<Map<String, dynamic>> createTransaction(
      {MobiTransaction transaction, String userId});
  Future<Result<Bank>> fetchBankTransferDetails();
  Future<Map<String, dynamic>> createCouponTransaction(
      {MobiTransaction transaction, String userId, double amount});
}

class FirestorePaymentApi extends ABSPaymentApi {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> createTransaction(
      {MobiTransaction transaction, String userId}) async {
    Map<String, dynamic> result = Map();
    result['error'] = false;

    DocumentReference rideReference = await database
        .collection(MyStrings.users())
        .doc(userId)
        .collection(MyStrings.transactions)
        .add(MobiTransaction.toMap(transaction))
        .catchError((error) {
      result['error'] = false;
      result['message'] = error.toString();
    });
    return result;
  }

  @override
  Future<Map<String, dynamic>> createCouponTransaction(
      {MobiTransaction transaction, String userId, double amount}) async {
    Map<String, dynamic> result = Map();
    result['error'] = false;

    var batch = database.batch();

    DocumentReference rideReference = database
        .collection(MyStrings.users())
        .doc(userId)
        .collection(MyStrings.transactions)
        .doc();
    DocumentReference reference =
        database.collection(MyStrings.users()).doc(userId);

    batch.set(rideReference, MobiTransaction.toMap(transaction));
    batch.update(reference, {'coupon_balance_withdrawn': amount});

    batch.commit().catchError((error) {
      result['error'] = false;
      result['message'] = error.toString();
    });
    return result;
  }

  @override
  Future<Result<Bank>> fetchBankTransferDetails()async {
    Result<Bank> result = Result(error: false);
    DocumentReference reference = database
        .collection("back_office")
        .doc('account');
    try{
      var snap = await reference.get();
      result.data = Bank.fromMap(snap.data());
      result.error = false;
    }catch(e){
      result.error = true;
      result.message = "Could not fetch bank";
    }
    return result;
  }
}
