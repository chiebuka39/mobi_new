import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/schedule.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/chat_screen.dart';
import 'package:mobi/screens/nearby_commutters.dart';
import 'package:mobi/screens/profile/user_profile.dart';
import 'package:mobi/screens/ride_alerts.dart';
import 'package:mobi/screens/ride_details.dart';
import 'package:mobi/screens/rides/schedule_option_rider.dart';
import 'package:mobi/screens/rides/schedule_ride_church.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/screens/rides/schedule_ride_format_screen.dart';
import 'package:mobi/screens/tabs/traffic_tab.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/empty_rides_widget.dart';
import 'package:mobi/widgets/home/planned_rides.dart';
import 'package:mobi/widgets/home/planned_rides_wid.dart';
import 'package:mobi/widgets/new/bottom_sheets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NoLoginDashboardScreen extends StatefulWidget {
  @override
  _NoLoginDashboardScreenState createState() => _NoLoginDashboardScreenState();
}

class _NoLoginDashboardScreenState extends State<NoLoginDashboardScreen> {

  List<Color> colors = [blueLight, orangeLight];


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(20),
        ),
        body: emptyData(context));
  }


  SliverList headerPortion(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Material(
              elevation: 3,
              shape: CircleBorder(),
              child: ClipOval(
                clipper: CircleClipper(),
                child: CachedNetworkImage(
                  imageUrl:  MyStrings.avatar,
                  width: 69,
                  height: 69,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hello",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  MyUtils.getReadableDate(DateTime.now()),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            )
          ],
        ),

      ]),
    );
  }

  void schedulSingleRide(BuildContext context, UserModel userModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ScheduleRideChurch(
                  driveOrRide: DriveOrRide.DRIVE,
                  fromLocation: userModel.user.homeLocation,
                  toLocation: userModel.user.workLocation,
                  canEdit: true,
                )));
  }

  CustomScrollView emptyData(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[headerPortion(context), EmptyRideWidget()],
    );
  }

  void goToDriverScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ScheduleOptionDriver()));
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

class ScheduledWidget extends StatefulWidget {
  final String title;
  final Color bgColor;
  final Schedule schedule;
  const ScheduledWidget({
    Key key,
    this.title,
    this.bgColor,
    this.schedule,
  }) : super(key: key);

  @override
  _ScheduledWidgetState createState() => _ScheduledWidgetState();
}

class _ScheduledWidgetState extends State<ScheduledWidget> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of(context);
    var width2 = (MediaQuery.of(context).size.width - 70) / 2;
    var rideTextStyle = TextStyle(fontSize: 18);
    var textStyle = TextStyle(fontSize: 12, color: Colors.black54);
    var textStyle2 = TextStyle(fontWeight: FontWeight.bold);
    var textStyle3 = TextStyle(fontSize: 12);
    return InkWell(
      onTap: () {
        _checkAndProceedToRideScreen(context);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 150,
          width: width2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    MyStrings
                        .intToStringDayOfWeek[widget.schedule.time.weekday],
                    style: textStyle2,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "(${MyStrings.intToStringMonthSemi[widget.schedule.time.month]} ${widget.schedule.time.day})",
                    style: textStyle3,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: rideTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.schedule.direction == LocationDirection.TO
                    ? "${MyUtils.getReadableTime2(_userModel.user.leaveForWork)} "
                        "- ${MyUtils.addTimeOfDayMinutes(_userModel.user.leaveForWork, 15)}"
                    : "${MyUtils.getReadableTime2(_userModel.user.leaveForHome)} "
                        "- ${MyUtils.addTimeOfDayMinutes(_userModel.user.leaveForHome, 15)}",
                style: textStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 30,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: ClipOval(
                              clipper: CircleClipper(),
                              child: CachedNetworkImage(
                                imageUrl: _userModel.user.avatar,
                                width: 27,
                                height: 27,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 15,
                            child: ClipOval(
                              clipper: CircleClipper(),
                              child: CachedNetworkImage(
                                imageUrl: _userModel.user.avatar,
                                width: 27,
                                height: 27,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 30,
                            child: ClipOval(
                              clipper: CircleClipper(),
                              child: CachedNetworkImage(
                                imageUrl: _userModel.user.avatar,
                                width: 27,
                                height: 27,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.navigate_next)
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: widget.bgColor, borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }

  void _goToSchedulePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ViewDailyRideDetails(
                  schedule: widget.schedule,
                )));
  }

  void _checkAndProceedToRideScreen(BuildContext context) {
    var morningMidnight = DateTime(widget.schedule.time.year,
            widget.schedule.time.month, widget.schedule.time.day)
        .millisecondsSinceEpoch;
    var eveningMidnight = DateTime(widget.schedule.time.year,
            widget.schedule.time.month, widget.schedule.time.day, 12)
        .millisecondsSinceEpoch;
    List<ScheduledRide> rides = _ridesViewModel.scheduledRideList
        .where((ride) =>
            ride.dateinMilliseconds > morningMidnight &&
            ride.dateinMilliseconds < eveningMidnight)
        .toList();
  }
}
