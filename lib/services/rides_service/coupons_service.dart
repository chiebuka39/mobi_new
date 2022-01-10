import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/models/coupon_model.dart';
import 'package:mobi/extras/strings.dart';



class CouponService extends ACouponService{
  final FirebaseFirestore database = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> createCouponInvitation(
      String userId, CouponModel couponModel) async {
    Map<String, dynamic> result = Map();
    result['error'] = false;
    await database
        .collection(MyStrings.users())
        .doc(userId)
        .collection(MyStrings.coupons())
        .doc(couponModel.ownerId)
        .set(CouponModel.toJson(couponModel)).catchError((error) {
      print(error.toString());
      result['error'] = true;
    });

    return result;
  }
}

abstract class ACouponService{
  Future<Map<String, dynamic>> createCouponInvitation(
      String userId, CouponModel couponModel);
}
