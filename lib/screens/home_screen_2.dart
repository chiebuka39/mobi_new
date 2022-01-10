import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/app_config.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/bar_item.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/ride_started/ride_started_screen.dart';
import 'package:mobi/screens/rides/ride_ratings.dart';
import 'package:mobi/screens/tabs/dashboard_no_login_screen.dart';
import 'package:mobi/screens/tabs/dashboard_screen.dart';
import 'package:mobi/screens/home_screen.dart';
import 'package:mobi/screens/nearby_commutters.dart';
import 'package:mobi/screens/recent_rides.dart';
import 'package:mobi/screens/tabs/connections_screen.dart';
import 'package:mobi/screens/tabs/profile_screen.dart';
import 'package:mobi/screens/tabs/rides_history.dart';
import 'package:mobi/screens/tabs/settings_screen.dart';
import 'package:mobi/screens/tabs/tab_1.dart';
import 'package:mobi/screens/tabs/wallet/wallet_screen.dart';
import 'package:mobi/screens/update_profile/update_car_details.dart';
import 'package:mobi/services/dialogs/dialog_service.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/animated_bottom_bar.dart';
import 'package:provider/provider.dart';

class HomeTabs extends StatefulWidget {
  final bool firstTimeUser;

  const HomeTabs({Key key, this.firstTimeUser = false}) : super(key: key);
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> with AfterLayoutMixin<HomeTabs> {
  bool built = false;
  bool built_ = false;
  DialogService _dialogService = locator<DialogService>();
  UserModel _userModel;

  RidesViewModel _ridesViewModel;

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  List<Widget> pages = [
    //RideRatingsScreen(),
    DashboardScreen(),
    //HomeScreen(key: PageStorageKey('page 2'),),
    RidesHistoryScreen(
      key: PageStorageKey('page 2'),
    ),
    WalletScreen(
      key: PageStorageKey('page 3'),
    ),
    SettingsScreen(
      key: PageStorageKey('page 4'),
    ),
  ];

  @override
  void initState() {
    print("ppppp release init");
    super.initState();
    //pprint("i am here");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.firstTimeUser == true && _userModel.coupon != null) {
      //pprint("i am here first time user");
      Future.delayed(Duration(seconds: 2)).then((value) {
        _dialogService.showPromoDialog().then((value) {});
      });
    }
    if(_userModel.user != null){
      print("ppppp release");
      _ridesViewModel
          .tempGetAllAvailableRides(_userModel.user.phoneNumber)
          .listen((data) {
        print("ccccc ${data.length}");
        _ridesViewModel.scheduleRideList = data;
        print("checking is i should create rides");

        //checkAndCreateRideSchedules(data);
        data.forEach((ride) {
          int index = ride.riders.indexOf(_userModel.user.phoneNumber);
          print("index of user $index");
          print("index of riders ${ride.riders}");
          print("index of riders state ${ride.ridersState}");
          RiderState riderState =
          ScheduledRide.convertToRiderState(ride.ridersState)[index];
          print("this is the user riderState $riderState");
          if (_userModel.user.drivingState == DrivingState.Drives &&
              _userModel.user.carDetails.carImageUrl != null) {
            if (ride.rideState == RideState.STARTED) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RideStartedScreen2(
                        ride: ride,
                      )),
                      (Route<dynamic> route) => false);
            }
          } else {
            print("ppppppf hs rk dsd sd ${_userModel.newRide}");
            if (ride.rideState == RideState.STARTED &&
                riderState == RiderState.JOINED) {
              _userModel.newRide = true;
            }
            if (index != -1 &&
                riderState == RiderState.ENDED &&
                _userModel.newRide == true) {
              _userModel.newRide = false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RideRatingsScreen(
                        ride: ride,
                      )));
            }
          }
        });
      });
    }

  }

  void checkAndCreateRideSchedules(List<ScheduledRide> data) {
    if (data.length < 6) {
      DateTime time;
      if (data.length > 0) {
        time =
            DateTime.fromMillisecondsSinceEpoch(data.last.dateinMilliseconds);
      } else {
        time = DateTime.now();
      }
      DateTime morning = DateTime(
              time.year,
              time.month,
              time.day,
              _userModel.user.leaveForWork.hour,
              _userModel.user.leaveForWork.minute)
          .add(Duration(hours: 24));
      DateTime evening = DateTime(
              time.year,
              time.month,
              time.day,
              _userModel.user.leaveForHome.hour,
              _userModel.user.leaveForHome.minute)
          .add(Duration(hours: 24));
      _ridesViewModel.create10ScheduledRide(
          user: _userModel.user,
          amount: 500,
          morning: morning,
          evening: evening);
    }
  }

  @override
  Widget build(BuildContext context) {
    setUpAppConfig(context);
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of(context);

    if (_userModel.user == null) {
      return Scaffold(

        body: NoLoginDashboardScreen(),
      );
    }

    return (_userModel.user.drivingState == DrivingState.Drives &&
            widget.firstTimeUser == true)
        ? Scaffold(
            body: VerifyCarScreen(),
          )
        : Scaffold(
            bottomNavigationBar: AnimatedBottomBarWidget(
              barItems: items,
              onTabSelected: (item) {
                setState(() {
                  _selectedIndex = item;
                });
              },
            ),
            body: PageStorage(
              child: pages[_selectedIndex],
              bucket: bucket,
            ),
          );
  }

  void setUpAppConfig(BuildContext context) {
    AppConfig.height = MediaQuery.of(context).size.height;
    AppConfig.width = MediaQuery.of(context).size.width;
    AppConfig.blockSize = AppConfig.width / 100;
    AppConfig.blockSizeVertical = AppConfig.height / 100;
    AppConfig.safeAreaHorizontal = MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
  }
}

class VerifyCarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Row(
            children: <Widget>[
              Spacer(),
              FlatButton(
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessageHandler(
                                child: HomeTabs(),
                              )),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
          Spacer(),
          SvgPicture.asset("assets/img/verify.svg"),
          SizedBox(
            height: 80,
          ),
          Text(
            "Verify your account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "For your safety and that of other commutters, we would need some of your car details",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ButtonTheme(
                buttonColor: myPrimaryColor,
                minWidth: double.infinity,
                height: 55,
                child: RaisedButton(
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => UpdateCarDetails()));
                  },
                )),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
