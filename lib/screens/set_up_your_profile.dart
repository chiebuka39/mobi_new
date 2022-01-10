import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart' as u;
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/set_locations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/screens/setting_up_profile.dart';
import 'package:mobi/viewmodels/payment_view_model.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/set_up_profile/company_details.dart';
import 'package:mobi/widgets/set_up_profile/enter_name_widget.dart';
import 'package:mobi/widgets/set_up_profile/profile_and_coupon_widget.dart';
import 'package:mobi/widgets/set_up_profile/ride_or_drive.dart';
import 'package:mobi/widgets/set_up_profile/set_up_header.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class SetUpProfile extends StatefulWidget {
  final ScheduledRide ride;

  const SetUpProfile({Key key, this.ride}) : super(key: key);
  @override
  _SetUpProfileState createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> with AfterLayoutMixin<SetUpProfile> {
  DrivingState _drivingState = DrivingState.Does_Not_Drive;
  u.User _user;
  User _fireBaseUser;
  PageController _pageController;


  int visiblePage = 0;
  File _image;

  final ProfileRepository _repo = locator<ProfileRepository>();

  UserModel _userModel;
  PaymentViewModel _paymentViewModel;

  ProgressDialog pr;

  @override
  void initState() {
    _user = u.User();
      _fireBaseUser = FirebaseAuth.instance.currentUser;

    _pageController = PageController();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: false);
    pr.style(
        message: 'Setting up your account',
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _userModel = Provider.of<UserModel>(context);
    _paymentViewModel = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SetUpProfileHeaderWidget(visiblePage: visiblePage),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(children: <Widget>[
                  Positioned.fill(child:
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      EnterNameWidget(onPressed: (String name, String coupon){
                        _user.fullName = name;
                        _userModel.coupon = coupon;
                        _user.phoneNumber = _fireBaseUser.phoneNumber;
                        print("jjjj ${_userModel.coupon}");
                        print("jjjj333 $coupon");
                        print("jjjj444 $name");

                        moveToNext();
                      }, coupon: _userModel.coupon,),

                      WorkDetailsWidget(onPressed: (String company, String email){
                        print("jjjj ${_user.phoneNumber}");
                        print("jjjj00 ${_fireBaseUser.phoneNumber}");
                        _user.work = company;
                        _user.emailAddress = email ?? '';
                        moveToNext();
                      },),
                      RideOrDriveWidget(
                        size: size,
                        changeToDrives: setDrivingStateToDrives,
                        changeToNotDrives: setDrivingStateToDoesNotDrive,
                        drivingState: _drivingState,
                        onPressed: (){
                          moveToNext();
                        },
                      ),
                      UploadProfile(onPressed: (file){
                        _image = file;
                        moveToNext();
                      },),


                    ],
                  ))
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }





  Future<void> moveToNext() async {
    setState(() {
      if (visiblePage == 3) {
        _handleProfileCreation();
      } else {
        visiblePage = visiblePage + 1;
      }
    });
    _pageController.animateToPage(visiblePage,
        duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
  }


  _handleProfileCreation() async{

    String coupon = "${_user.fullName.substring(0,3)}"
        "${_user.phoneNumber.substring(10)}";


    _user.drivingState = _drivingState;
    pprint("driving state ${_drivingState}");
    _user.balance = 0;
    _user.couponId = coupon;
    if(_userModel.coupon != null){
      _user.usedCoupons = [_userModel.coupon];
    }
    _user.dateJoined = DateTime.now();
    _user.couponId =
        "${_user.fullName.substring(0, 2)}${_fireBaseUser.phoneNumber.substring(_fireBaseUser.phoneNumber.length - 4)}";
    _user.carDetails =
        CarDetails(plateNumber: null, licenseImageUrl: null, carImageUrl: null);
    _user.homeLocation = TheLocation(title: null, lat: null, lon: null);
    _user.workLocation = TheLocation(title: null, lat: null, lon: null);
    if (_drivingState == DrivingState.Does_Not_Drive) {
      _user.verified = true;
    }

    pr.show();
    var result = await _userModel.createUserProfile(_user, _image);
    if(result['error'] == false){
     await _paymentViewModel.createTransaction(transaction:u.MobiTransaction(
          title: 'Payment to wallet',
          description: 'Invite coupon: You just got credited with NGN200',
          type: TransactionType.COUPON,
          amount: 200,
          userFrom: "",
          userTo: _userModel.user.fullName,
          iDfrom: '',
          users: [_userModel.user.phoneNumber],
          iDto: _userModel.user.phoneNumber), user: _user);
      pr.hide();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ScheduleRideDriver(
                ride: widget.ride,
                fromLocation: widget.ride.fromLocation,
                toLocation: widget.ride.toLocation,
                canChangeDriving: true,
                canEdit: true,
              )),
              (Route<dynamic> route) => false);
    }else{
      pr.hide();
      showSimpleNotification(Text("u.User could not be created"), background: Colors.red);
    }

  }


  int isEmail(String email) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(email)) {
      return 0;
    }

    return 1;
  }

  void setDrivingStateToDrives() {
    setState(() {
      if (_drivingState == DrivingState.Drives) {
      } else {
        _drivingState = DrivingState.Drives;
      }
    });
    pprint("i was called ${_drivingState}");
  }

  void setDrivingStateToDoesNotDrive() {
    setState(() {
      if (_drivingState == DrivingState.Does_Not_Drive) {
      } else {
        _drivingState = DrivingState.Does_Not_Drive;
      }
    });
    pprint("i was called ${_drivingState}");
  }
}


