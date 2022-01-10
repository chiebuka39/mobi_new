import 'package:flutter/foundation.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/models/bank.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/services/payment_api.dart';

import '../locator.dart';

abstract class ABSPaymentViewModel extends ChangeNotifier{
  final _api = locator<ABSPaymentApi>();
  Future<Map<String,dynamic>> createTransaction({MobiTransaction transaction, User user});
  Future<Result<Bank>> fetchBankTransferDetails();
  Future<Map<String, dynamic>> createCouponTransaction(
      {MobiTransaction transaction, String userId, double amount});
}

class PaymentViewModel extends ABSPaymentViewModel{

  @override
  Future<Map<String, dynamic>> createTransaction({MobiTransaction transaction, User user}) {
    return _api.createTransaction(transaction: transaction,userId: user.phoneNumber);
  }

  @override
  Future<Map<String, dynamic>> createCouponTransaction({MobiTransaction transaction, String userId, double amount}) {
    return _api.createCouponTransaction(transaction: transaction,userId: userId,amount: amount);
  }

  @override
  Future<Result<Bank>> fetchBankTransferDetails() {
    return _api.fetchBankTransferDetails();
  }

}