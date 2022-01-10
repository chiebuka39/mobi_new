import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/dimens.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/choose_location.dart';
import 'package:mobi/screens/connections/connections_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/animated_button.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:provider/provider.dart';

import 'available_rides.dart';
import 'home_screen_2.dart';

class ScheduleRideCommutersScreen extends StatefulWidget {
  final TheLocation fromLocation;
  final TheLocation toLocation;
  final bool canEdit;

  const ScheduleRideCommutersScreen({Key key, this.fromLocation, this.toLocation, this.canEdit =  false}) : super(key: key);
  @override
  _ScheduleRideCommutersState createState() => _ScheduleRideCommutersState();
}

class _ScheduleRideCommutersState extends State<ScheduleRideCommutersScreen>
    with TickerProviderStateMixin, AfterLayoutMixin<ScheduleRideCommutersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RidesViewModel _viewModel;

  DriveOrRide _driveOrRide = DriveOrRide.RIDE;
  // Animation for controlling date animation
  AnimationController _controller;

  // Animation controller for showing time picker animation
  AnimationController _timeController;

  // Relative rect animation that slides in a Date picker rectangle
  Animation<RelativeRect> rectAnimation;

  UserModel _userModel;

  // Work Location
  TheLocation fromLocation;

  // Home Location
  TheLocation toLocation;
  //
  Animation<RelativeRect> rectTimePickerAnimation;
  bool showing = false;
  bool timePickerShowing = false;
  List<DateTime> selectedDates;
  ButtonState currentState;
  DateTime seclectedDate = DateTime.now();
  TimeOfDay _initTime = TimeOfDay.now();
  bool driving = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    selectedDates = getMondayFriday();

    super.initState();
  }



  List<DateTime> getMondayFriday() {
    List<DateTime> dates = [];
    var monday = 1;
    var now = new DateTime.now();

    while (now.weekday != monday) {
      now = now.subtract(new Duration(days: 1));
    }
    dates.add(now);
    dates.add(now.add(Duration(days: 4)));

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _viewModel = Provider.of<RidesViewModel>(context);

    final size = MediaQuery.of(context).size;
    final heightOfAppBar = size.height / 3.5 + 20;
    driving = _userModel.user.drivingState == DrivingState.Does_Not_Drive ? false:true;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "Schedule a Ride",
          style: TextStyle(color: Colors.black),
        ),
      ),//3123399145
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      DateTime date = await showDatePicker(
                          context: context,
                          initialDate: seclectedDate,
                          firstDate: DateTime.now().subtract(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 30)));
                        setState(() {
                          if(date != null){
                            seclectedDate = date;
                          }
                        });

                    },
                    child: Container(
                      height: MyUtils.buildSizeHeight(17),
                      width: Dimens.timeAndDateContainerWidth,
                      decoration: BoxDecoration(
                          color: timeAndDateContainerColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            seclectedDate.day.toString(),
                            style: TextStyle(
                                fontSize: MyUtils.fontSize(6),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(MyStrings.intToStringMonth[seclectedDate.month]),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      //playTimePickerAnimation(false);
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 5, minute: 0))
                          .then((time) {
                        if (time != null) {
                          setState(() {
                            _initTime = time;
                          });
                        }
                      });
                    },
                    child: Container(
                      height: MyUtils.buildSizeHeight(17),
                      width: Dimens.timeAndDateContainerWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          color: timeAndDateContainerColor),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            "${_initTime.hour < 10 ? "0${_initTime.hour.toString()}" : _initTime.hour.toString()}:${_initTime.minute < 10 ? "0${_initTime.minute.toString()}" : _initTime.minute.toString()}",
                            style: TextStyle(
                                fontSize: MyUtils.fontSize(6),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(_initTime.period == DayPeriod.am ? "AM" : "PM"),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap:widget.canEdit == true ? fromLocFunc:null,
                      child: new LocationTitleWidget(
                        address: fromLocation != null ? fromLocation.title : "",
                        size: size,
                        locationDirection: LocationDirection.FRO,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap:widget.canEdit == true ? toLocFunc :null,
                      child: new LocationTitleWidget(
                        address: toLocation != null ?  toLocation.title :"",
                        size: size,
                        locationDirection: LocationDirection.TO,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Spacer(),
              
              GestureDetector(
                onTap: () {
                  //handleCreatingRides();
                },
                child: _viewModel.state == PostState.POSTING
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                      )
                    : Container(
                        width: MyUtils.buildSizeWidth(50),
                        height: MyUtils.buildSizeHeight(6),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            print("i got clicked here");
                            handleCreatingRides();
                          },
                          child: Text(
                            "See Available Rides",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: accentColor,
                        )),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }

  void handleCreatingRides() async {
   var ride = ScheduledRide(
        dateinMilliseconds: DateTime.utc(
            seclectedDate.year,
            seclectedDate.month,
            seclectedDate.day,
            _initTime.hour,
            _initTime.minute)
            .millisecondsSinceEpoch,
        userId: _userModel.user.phoneNumber,
        userName: _userModel.user.fullName,
        userProfilePix: _userModel.user.workIdentityUrl,
        userRatings: _userModel.user.ratings,
        fromLocation: fromLocation,
        toLocation: toLocation,
        time: "${_initTime.hour}:${_initTime.minute}",
        invitedRiders: [],
        riders: [_userModel.user.phoneNumber],
        rideState: RideState.SCHEDULED,
        driveOrRide: _driveOrRide);
    print("got here");


    Navigator.push(context, MaterialPageRoute(builder: (_) => AvailableRidesScreen(scheduledRide: ride,)));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future toLocFunc() async {
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChooseLocationScreen(
              direction: LocationDirection.TO,
              save: false,
            )));
    if (loc != null) {
      setState(() {
        toLocation = loc;
      });

    } else {

    }
  }

  Future fromLocFunc() async {
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChooseLocationScreen(
              direction: LocationDirection.FRO,
              save: false,
            )));
    if (loc != null) {
      setState(() {
        fromLocation = loc;
      });

    } else {

    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      toLocation = widget.toLocation ??_userModel.user.workLocation;
      fromLocation = widget.fromLocation ??_userModel.user.homeLocation;
    });
  }
}
