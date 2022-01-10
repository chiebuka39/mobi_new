import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/dimens.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/location_search_delegate.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/available_rides.dart';
import 'package:mobi/screens/connections/connections_screen.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/animated_button.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'choose_location.dart';
import 'home_screen_2.dart';

class ScheduleRideScreen extends StatefulWidget {
  final TheLocation fromLocation;
  final TheLocation toLocation;
  final bool canEdit;

  const ScheduleRideScreen(
      {Key key, this.fromLocation, this.toLocation, this.canEdit = false})
      : super(key: key);
  @override
  _ScheduleRideState createState() => _ScheduleRideState();
}

class _ScheduleRideState extends State<ScheduleRideScreen>
    with TickerProviderStateMixin, AfterLayoutMixin<ScheduleRideScreen> {
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
  String fromAddress;

  LocationModel _locationModel;

  // Home Location
  TheLocation toLocation;
  String toAddress;
  //
  Animation<RelativeRect> rectTimePickerAnimation;
  bool showing = false;
  bool timePickerShowing = false;
  List<DateTime> selectedDates;
  ButtonState currentState;
  DateTime seclectedDate = DateTime.now();
  TimeOfDay _initTime = TimeOfDay.now();
  bool driving = true;
  List<Connection> connections = [];
  var controller = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',');

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      toLocation = widget.toLocation ?? _userModel.user.workLocation;
      fromLocation = widget.fromLocation ?? _userModel.user.homeLocation;
    });
  }

  @override
  void initState() {
    selectedDates = getMondayFriday();
//    fromLocation = widget.fromLocation;
//    toLocation = widget.toLocation;
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
    _locationModel = Provider.of<LocationModel>(context);

    final size = MediaQuery.of(context).size;
    final heightOfAppBar = size.height / 3.5 + 20;
    final firstcontainerHeight = heightOfAppBar / 1.9;
    //print("this is a ride screen");
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
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MyUtils.buildSizeHeight(100),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/img/sports-car.png"),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      "Driving",
                      style: firstLabelStyle,
                    ),
                    Spacer(
                      flex: 4,
                    ),
                    Switch(
                      onChanged: (bool value) {
                        setState(() {
                          driving = value;
                          if (driving == false) {
                            _driveOrRide = DriveOrRide.RIDE;
                          } else {
                            _driveOrRide = DriveOrRide.DRIVE;
                          }
                        });
                      },
                      value: driving,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Tfare for this ride",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SvgPicture.asset(
                      "assets/img/naira.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 100,
                      child: new TextField(
                        keyboardType: TextInputType.number,
                        controller: controller,
                        decoration: InputDecoration(hintText: "200,000"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      //playAnimation();
//                      List<DateTime> dates =
//                          await DateRagePicker.showDatePicker(
//                              context: context,
//                              initialFirstDate: selectedDates[0],
//                              initialLastDate: selectedDates[1],
//                              firstDate: new DateTime(2018),
//                              lastDate: new DateTime(2022));
//
//                              if (selectedDates.length == 2) {
//                                setState(() {
//                                  selectedDates = dates;
//                                });
//                              }
                      DateTime date = await showDatePicker(
                          context: context,
                          initialDate: seclectedDate,
                          firstDate: DateTime.now().subtract(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 30)));
                      setState(() {
                        if (date != null) {
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
                              initialTime: TimeOfDay(hour: _initTime.hour, minute: _initTime.minute))
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
                      onTap: widget.canEdit == true ? fromLocFunc : null,
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
                      onTap: widget.canEdit == true ? toLocFunc : null,
                      child: new LocationTitleWidget(
                        address: toLocation != null ? toLocation.title : "",
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
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.visibility),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        "Visibillity",
                        style: firstLabelStyle,
                      ),
                      Spacer(
                        flex: 4,
                      ),
                      Text(
                        "Visible to all",
                        style: faintTextStyle,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: GestureDetector(
                  onTap: () async {
                    List<Connection> result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ConnectionsScreen(
                                  mainConnections: _userModel.connections,
                                  connections: connections,
                                )));
                    if (result != null) {
                      if (result.length > 0) {
                        setState(() {
                          connections = result;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: <Widget>[
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Invited",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MyUtils.buildSizeWidth(4))),
                          TextSpan(text: "\n\n"),
                          TextSpan(
                              text: "for this ride",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6))),
                        ])),
                        Spacer(),
                        Text(
                          connections.length == 0
                              ? "None"
                              : "${connections.length} users",
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
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
                            //print("i got clicked here");
                            handleCreatingRides();
                            //widget.onPressed()
                          },
                          child: Text(
                            "Create Schedule",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: accentColor,
                        )),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
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
    } else {}
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
    } else {}
  }

  void handleCreatingRides() async {
    ScheduledRide ride = ScheduledRide(
        dateinMilliseconds: DateTime(
                seclectedDate.year,
                seclectedDate.month,
                seclectedDate.day,
                _initTime.hour,
                _initTime.minute)
            .millisecondsSinceEpoch,
        userId: _userModel.user.phoneNumber,
        userName: _userModel.user.fullName,
        work: _userModel.user.work,
        userProfilePix: _userModel.user.avatar,
        userRatings: _userModel.user.ratings,
        fromLocation: fromLocation,
        toLocation: toLocation,
        price: controller.numberValue,
        time: "${_initTime.hour}:${_initTime.minute}",
        invitedRiders: connections.length > 0
            ? connections.map((connection) => connection.connectionId).toList()
            : [],
        riders: [_userModel.user.phoneNumber],
        ridersRequest: [],
        rideState: RideState.SCHEDULED,
        driveOrRide: _driveOrRide);
    pprint("got here");

    if (driving == true) {
      Map<String, dynamic> result =
          await _viewModel.makeRideRequest(ride, _userModel.user);
      if (result['success'] == true) {
        _userModel.addRideId(result['ride_id']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeTabs()),
            (Route<dynamic> route) => false);
      } else {
        print(result['error']);
        showInSnackBar("An error occured");
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AvailableRidesScreen(
                    scheduledRide: ride,
                  )));
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}

class MyRaisedButton extends StatefulWidget {
  final Function onPressed;

  const MyRaisedButton({Key key, this.onPressed}) : super(key: key);
  @override
  _MyRaisedButtonState createState() => _MyRaisedButtonState();
}

class _MyRaisedButtonState extends State<MyRaisedButton> {
  var controller = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () {
        //print("i got clicked here");
        //handleCreatingRides(context);
        //widget.onPressed()
      },
      child: Text(
        "Set Ride amount",
        style: TextStyle(color: Colors.white),
      ),
      color: accentColor,
    );
  }
}
