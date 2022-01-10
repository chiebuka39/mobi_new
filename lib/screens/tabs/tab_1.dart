import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/nearby_commutters.dart';
import 'package:mobi/screens/profile/user_profile.dart';
import 'package:mobi/screens/rides/schedule_option_rider.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/home/choose_a_schedule.dart';
import 'package:mobi/widgets/home/header.dart';
import 'package:provider/provider.dart';
import 'message_screen.dart';

class TabOneScreen extends StatefulWidget {
  TabOneScreen({Key key}) : super(key: key);
  @override
  _TabOneScreenState createState() => _TabOneScreenState();
}

class _TabOneScreenState extends State<TabOneScreen> {
  UserModel _userModel;

  @override
  void initState() {
    print("init state called");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: InkWell(
//                  onTap: (){
//                    Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleRideDriver()));
//                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Hello",
                        style: TextStyle(fontSize: MyUtils.fontSize(4)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _userModel.user.fullName.split(" ").first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyUtils.fontSize(4)),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MessageScreen()));
                        },
                        icon: Icon(Icons.email),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UserProfileScreen()));
                          //Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: "sTfiokJIt0s1GVk28LUr",)));
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (_) => ViewProfileScreen(userId: '+2348161167993',)));
                        },
                        icon: Icon(Icons.account_circle),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MyUtils.buildSizeHeight(2),
              ),
              //getHeaderWidget(),
              Header(),
              SizedBox(
                height: MyUtils.buildSizeHeight(2),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 3,
                  child: GestureDetector(
                    onTap: () {
                      isVerified(_userModel.user) == true
                          ? _userModel.user.drivingState !=
                                  DrivingState.Does_Not_Drive
                              ? goToDriverScheduleScreen(
                                  context, _userModel, true)
                              : goToRiderScheduleScreen(
                                  context, _userModel, true)
                          : Widgets.showCustomDialog(MyStrings.verifiedMessage,
                              context, "Verification", "Ok", () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                    },
                    child: Container(
                      padding: EdgeInsets.all(MyUtils.buildSizeWidth(4)),
                      width: MyUtils.buildSizeWidth(88),
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset(
                            "assets/img/calendar.svg",
                            color: Colors.white,
                            width: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Take a ride",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MyUtils.buildSizeHeight(1.5),
                          ),
                          Text(
                            "Schedule a ride and find other commuters going your way, "
                            "you can either share your car space with them or Join others on a ride",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: primaryColor[800],
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MyUtils.buildSizeHeight(3.5),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => NearbyCommuters()));
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.all(MyUtils.buildSizeWidth(4)),
                      width: MyUtils.buildSizeWidth(88),
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset(
                            "assets/img/avatar.svg",
                            color: Colors.white,
                            width: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "View Nearby Commutters",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Find rides around you and enjoy a great commutes with coworkers and neigbores",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: primaryColor[800],
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  void goToDriverScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleOptionDriver()));
//    if (evening == true) {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (_) => ScheduleRideDriver(
//                    fromLocation: userModel.user.workLocation,
//                    toLocation: userModel.user.homeLocation,
//                    canEdit: canEdit,
//                  )));
//    } else {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (_) => ScheduleRideDriver(
//                    fromLocation: userModel.user.homeLocation,
//                    toLocation: userModel.user.workLocation,
//                    canEdit: canEdit,
//                  )));
//    }
  }

  void goToRiderScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    if (evening == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                  toLocation: userModel.user.homeLocation,
                  fromLocation: userModel.user.workLocation,
                  canEdit: canEdit)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                  fromLocation: userModel.user.homeLocation,
                  toLocation: userModel.user.workLocation,
                  canEdit: canEdit)));
    }
  }
}
