class CouponModel {
  String ownerId;
  String userId;
  String type;

  CouponModel({this.ownerId, this.userId, this.type});

  static Map<dynamic, dynamic> toJson(CouponModel model){
    var coupon = Map<String, dynamic>();
    coupon['owner_id'] = model.ownerId ?? '';
    coupon['user_id'] = model.userId ?? '';
    coupon['type'] = model.type ?? '';
    return coupon;
  }



  static fromMap(Map<dynamic, dynamic> map) {

    return CouponModel(
        ownerId: map['owner_id'] != null ? map['owner_id'] : '',
        userId:map['user_id'] ?? '',
        type:map['type'] ?? '');

  }
}
