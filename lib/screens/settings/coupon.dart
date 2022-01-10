import 'package:after_layout/after_layout.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/coupon_model.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/services/rides_service/coupons_service.dart';
import 'package:mobi/viewmodels/payment_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
 
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class RedeemCoupon extends StatefulWidget {
  final String couponId;

  const RedeemCoupon({Key key, this.couponId}) : super(key: key);
  @override
  _RedeemCouponState createState() => _RedeemCouponState();
}

class _RedeemCouponState extends State<RedeemCoupon>  with AfterLayoutMixin<RedeemCoupon>{

  final ACouponService _couponService = locator<ACouponService>();
  UserModel _userModel;
  PaymentViewModel _paymentViewModel;
  bool _loading = false;
  DynamicLinkParameters parameters;
  List<User> _signedUpUsers = [];
  List<User> _signedUpUserRides = [];
  List<int> ridesPerUser = [];
  double _totalAmountGotten = 0;

  ProgressDialog _pr;



  @override
  void initState() {
    parameters  = DynamicLinkParameters(
        uriPrefix: 'https://mobiride.page.link',
        link: Uri.parse('https://mobing.com/?invite=${widget.couponId}'),
        androidParameters: AndroidParameters(
          packageName: 'me.mobbid.mobiride',
          minimumVersion: 125,
        ),
        iosParameters: IosParameters(
          bundleId: 'me.mobbid.mobbidRide',
          minimumVersion: '1.1.0',
          appStoreId: '1481578143',
        )
    );
    super.initState();

  }
  @override
  void afterFirstLayout(BuildContext context) async{
      var result = await _userModel.getSignUpsFromCoupon();
      if(result['error'] == false){
        setState(() {
          _signedUpUsers = result['users'];
        });
        _userModel.getNumberCompletedRidesFromUsers(_signedUpUsers).then((value) {
          print("oooooooojjjjj ${value.data}");
          ridesPerUser = value.data;
          _totalAmountGotten = (ridesPerUser.where((element) => element > 0)
              .toList().length * 100) - _userModel.user.couponBalanceWithdrawn;;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _paymentViewModel = Provider.of(context);
    print("ooo ${_userModel.user.couponId}");
    _pr = ProgressDialog(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          FlatButton(child: Text("Withdraw"),onPressed: ()async{
            if((_totalAmountGotten) > 1000){
              _pr.show();
              await _withdrawFromEarning();
              _pr.hide();
            }else{
              showSimpleNotification(Text("You can only withdraw when you have upto 1000 naira"),
                  background: Colors.redAccent);
            }
          },)
        ],
        title: Text("Share and Earn", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7)
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.only(left: 20,top: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                  borderRadius: BorderRadius.circular(7)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Rewards", style:
                  TextStyle(fontSize: 11, color: secondaryGrey),),
                  SizedBox(height: 12,),
                  Text("NGN ${_totalAmountGotten - _userModel.user.couponBalanceWithdrawn}",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30,
                      color: Colors.white
                    ),)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(MyStrings.shareNEarn, style: TextStyle(fontSize: 13),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,top: 60),
          child: Text("Referral Stats", style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 30),
            child: Text("Total Signups".toUpperCase(), style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.normal),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 7),
            child: Text(_signedUpUsers.length.toString(), style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 30),
            child: Text("Total Signups that Take first ride".toUpperCase(), style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.normal),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 7),
            child: Text(ridesPerUser.where((element) => element > 0)
                .toList().length.toString(), style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold),),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
                width: double.infinity,
                height: 55,
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: _handleShare2,
                  child: _loading == true ?
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),): Text(
                    "Share invite code".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
      ],),
    );
  }
  //Get a free ride worth NGN200 when you sign up and take your first ride on mobirideng with my invite code Chi-167993
  Scaffold buildScaffold() {
    return Scaffold(
    appBar: AppBar(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 180,
              child: Text(
                "Gift your friends a free trip",
                style: TextStyle(fontSize: 24),
              )),
          Spacer(),
          Row(
            children: <Widget>[
              Spacer(),
              SvgPicture.asset(
                "assets/img/voucher.svg",
                height: 224,
              ),
              Spacer(),
            ],
          ),
          Text(
            "Gift a friend a free trip to work or 700 naira  in fuel "
            "when you share the app with them and they take their first trip on mobiride",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          Spacer(),
          Text("View coupon stats", style: TextStyle(color: Colors.green),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Container(
                width: double.infinity,
                height: 55,
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: _handleShare2,
                  child: _loading == true ?
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),): Text(
                    "Share with Friends".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
  }

  Future<void> _handleShare2() async {
    String link = await createLink();
    Share.share('Get a free ride worth NGN200 when you sign up and take your '
        'first ride on mobirideng with my invite code $link');

  }

  Future<String> createLink()async{
    final dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
  Future _withdrawFromEarning()async{
    var result = await _paymentViewModel.createCouponTransaction(transaction: MobiTransaction(
        title: 'Payment for a trip',
        description: 'Payment of a trip',
        type: TransactionType.PAYMENT,
        amount: _totalAmountGotten.toInt(),
        userFrom: "Coupon Earnings",
        userTo: _userModel.user.fullName,
        iDfrom: "",
        users: [_userModel.user.phoneNumber],
        iDto: _userModel.user.phoneNumber),userId: _userModel.user.phoneNumber,amount: _userModel.user.couponBalanceWithdrawn + _totalAmountGotten);
    print("result $result");

    if(result['error'] == false){
      _userModel.setUserBalance(_totalAmountGotten.toInt());
      showSimpleNotification(Text("Coupon money added to wallet"), background: Colors.greenAccent);
    }else{
      showSimpleNotification(Text("Error occured"), background: Colors.redAccent);
    }
  }
}//https://mobiride.page.link/xhs5DYmvdAhup4wj7
//Get a free ride worth NGN200 when you sign up and take your first ride on mobirideng with my invite code https://mobiride.page.link/9YGfsvLHnrXe3t217
