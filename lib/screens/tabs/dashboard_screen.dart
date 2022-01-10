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

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AfterLayoutMixin<DashboardScreen> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  var randomGenerator = Random();
  List<Color> colors = [blueLight, orangeLight];
  DateTime now;
  List<Schedule> _calendar = [];

  @override
  void initState() {
    super.initState();
  }

  void fillUpCalendar() {
    now = DateTime.now();
    DateTime morning = DateTime(now.year, now.month, now.day,
        _userModel.user.leaveForWork?.hour ?? 0, _userModel.user.leaveForWork?.minute ?? 10);
    DateTime evening = DateTime(now.year, now.month, now.day,
        _userModel.user.leaveForHome?.hour ?? 0, _userModel.user.leaveForHome?.minute ?? 0);


    List<Schedule> calendar = [];
    DateTime date = DateTime.now();
    for (var i = 1; i <= 6; i++) {
      if (date.weekday == 5) {
        print("llll");
        date = date.add(Duration(days: 3));
      } else if (date.weekday == 6) {
        print("llll99");
        date = date.add(Duration(days: 2));
        print("llll99 -- ${MyStrings.intToStringDayOfWeek[date.weekday]}");
      } else {
        print("llll00");
        date = date.add(Duration(days: 1));
      }
      Schedule schedule = Schedule(
          time: date, title: "Ride to work", direction: LocationDirection.TO);
      Schedule schedule2 = Schedule(
          time: date,
          title: "Ride from Work",
          direction: LocationDirection.FRO);
      calendar.add(schedule);
      calendar.add(schedule2);
    }
    if (now.millisecondsSinceEpoch < morning.millisecondsSinceEpoch &&
        now.weekday != 6 &&
        now.weekday != 7) {
      var schedule1 = Schedule(
          title: "Ride to work",
          direction: LocationDirection.TO,
          time: morning);
      var schedule2 = Schedule(
          title: "Ride From work",
          direction: LocationDirection.FRO,
          time: evening);
      setState(() {
        _calendar = [schedule1, schedule2, ...calendar];
      });
    } else if (now.millisecondsSinceEpoch < evening.millisecondsSinceEpoch &&
        now.weekday != 6 &&
        now.weekday != 7) {
      var schedule2 = Schedule(
          title: "Ride From work",
          direction: LocationDirection.FRO,
          time: evening);

      setState(() {
        _calendar = [schedule2, ...calendar];
      });
    } else {
      setState(() {
        _calendar = calendar;
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if(_userModel.user!= null){
      fillUpCalendar();
    }

//    _ridesViewModel.tempGetAllAvailableRidesNonStream(_userModel.user.phoneNumber).then((value) {
//        print("llllt>>>>>>>");
//      _ridesViewModel.scheduleRideList = value;
//    });
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _ridesViewModel = Provider.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(20),
        ),
        body:_userModel.user == null ? emptyData(context): _ridesViewModel.scheduledRideList == null
            ? noData(context)
            : _ridesViewModel.scheduledRideList.isEmpty
                ? emptyData(context)
                : listData(context, _ridesViewModel.scheduledRideList));
  }

  CustomScrollView noData(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        headerPortion(context),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  margin: EdgeInsets.only(right: 5.0, left: 30.0),
                  height: 220.0,
                  width: 230.0,
                  color: Colors.white,
                ),
              ),
            );
            ;
          }, childCount: 4),
        )
      ],
    );
  }

  SliverList headerPortion(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => UserProfileScreen()));
              },
              child: Material(
                elevation: 3,
                shape: CircleBorder(),
                child: ClipOval(
                  clipper: CircleClipper(),
                  child: CachedNetworkImage(
                    imageUrl: _userModel.user?.avatar ?? MyStrings.avatar,
                    width: 69,
                    height: 69,
                    fit: BoxFit.cover,
                  ),
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
                  "Hello, ${_userModel.user == null ? '':_userModel.user .fullName.split(" ").first}",
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
        SizedBox(
          height: 30,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  isVerified(_userModel.user) == true
                      ? _userModel.user.drivingState !=
                              DrivingState.Does_Not_Drive
                          ? goToDriverScheduleScreen(context, _userModel, true)
                          : goToRiderScheduleScreen(context, _userModel, true)
                      : Widgets.showCustomDialog(MyStrings.verifiedMessage,
                          context, "Verification", "Ok", () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Color(0xFFEBF1FF),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      SvgPicture.asset(
                        "assets/img/new_t.svg",
                        height: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Work Trip",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // isVerified(_userModel.user) == true
                  //     ? schedulSingleRide(context, _userModel)
                  //     : Widgets.showCustomDialog(MyStrings.verifiedMessage,
                  //         context, "Verification", "Ok", () {
                  //         Navigator.of(context, rootNavigator: true).pop();
                  //       });
                  showModalBottomSheet < Null > (context: context, builder: (BuildContext context) {
                    return UpcomingFeature();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Color(0xFFEBF1FF),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      SvgPicture.asset(
                        "assets/img/pie-chart1.svg",
                        height: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Church trip",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // isVerified(_userModel.user) == true
                  //     ? schedulSingleRide(context, _userModel)
                  //     : Widgets.showCustomDialog(MyStrings.verifiedMessage,
                  //         context, "Verification", "Ok", () {
                  //         Navigator.of(context, rootNavigator: true).pop();
                  //       });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RideAlertScreen(
                            user: _userModel.user,
                          )));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Color(0xFFEBF1FF),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      SvgPicture.asset(
                        "assets/img/jeep.svg",
                        height: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Ride Alerts",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Text(
                "Schedule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Spacer(),
              Text("View all")
            ],
          ),
        ),
        SizedBox(
          height: 15,
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

  CustomScrollView listData(BuildContext context, List<ScheduledRide> data) {
    return CustomScrollView(
      slivers: <Widget>[
        headerPortion(context),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RideDetailsScreen(
                              ride: data[index],
                            )));
              },
              child: PlannedRideWidgetSecondary(
                horizontalMargin: 20,
                ride: data[index],
                user: _userModel.user,
                bgColor: blueLight,
              ),
            );
          }, childCount: data.length > 5 ? 5 : data.length),
        )
      ],
    );
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
