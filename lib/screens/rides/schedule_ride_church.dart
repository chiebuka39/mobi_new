import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/available_rides.dart';
import 'package:mobi/screens/connections/connections_screen.dart';
import 'package:mobi/screens/rides/same_route_riders.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

import '../choose_location.dart';
import '../home_screen_2.dart';


class ScheduleRideChurch extends StatefulWidget {
  final TheLocation fromLocation;
  final TheLocation toLocation;
  final bool canEdit;
  final bool canChangeDriving;
  final ScheduledRide ride;
  final DriveOrRide driveOrRide;


  const ScheduleRideChurch(
      {Key key,
      this.fromLocation,
      this.toLocation,
      this.canEdit = false,
      this.ride, this.driveOrRide, this.canChangeDriving = false})
      : super(key: key);
  @override
  _ScheduleRideDriverState createState() => _ScheduleRideDriverState();
}

class _ScheduleRideDriverState extends State<ScheduleRideChurch>
    with AfterLayoutMixin<ScheduleRideChurch> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ScheduledRide _ride;
  String _date;
  DateTime _date1;
  String _time;
  DriveOrRide _driving;
  bool _scheduleWeeklyRide;
  TheLocation _fromLocation;
  TheLocation _toLocation;
  TimeOfDay _time1;
  String _visibillity;
  bool _visibillityMain;
  String _price;
  int _priceMain;
  String _seatsAvailable;
  int _seatsAvailableMain;
  List<User> _invitedRidersMain;
  String _invitedRiders;
  bool _loading = false;

  //View Models
  UserModel _userModel;
  RidesViewModel _rideModel;

  List<String> others = [
    'Ride Visibilly',
    'Ride \nPrice',
    'Seats Available',
    'Invited Riders',
  ];
  List<dynamic> otherValues = [];

  bool _error = false;

  @override
  void initState() {
    if (widget.ride == null) {
      _visibillity = "visible";
      _visibillityMain = true;
      _price = "NGN 0";
      _priceMain = 0;
      _seatsAvailable = "Zero [0]";
      _seatsAvailableMain = 0;
      _invitedRiders = "Zero [0]";
      _invitedRidersMain = [];
      _driving = DriveOrRide.RIDE;
    } else {

      _loading = true;
      _visibillityMain = true;
      _visibillity = "Visible";
      _priceMain = widget.ride.price.toInt();
      _price = "NGN ${widget.ride.price}";
      _seatsAvailableMain = widget.ride.seatsAvailable;
      _seatsAvailable = "${widget.ride.seatsAvailable} seats";
      _driving = widget.ride.driveOrRide;
      _invitedRiders = "Zero [0]";
    }
    if(widget.driveOrRide != null){
      _driving = widget.driveOrRide;
    }
    _scheduleWeeklyRide = false;
    otherValues = [_visibillity, _price, _seatsAvailable, _invitedRiders];
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      _toLocation = widget.toLocation ?? _userModel.user.workLocation;
      _fromLocation = widget.fromLocation ?? _userModel.user.homeLocation;
    });
    if(widget.ride != null){
      var riders = List.from(widget.ride.riders)
        ..remove(_userModel.user.phoneNumber);
      if (_loading == true && riders.length > 0) {
        try {
          var users = await _userModel.getAllUsers(riders);
          if (users.length > 0) {

            setState(() {
              _invitedRidersMain = users;
              _invitedRiders =
              "${MyStrings.numToString(users.length)} "
                  "[5]";
              otherValues[3] = "${MyStrings.numToString(users.length)} "
                  "[${users.length}]";
              print("kkkkkk ${users.length}");
              _loading = false;
              //_riders = users;
            });
          } else {
            _loading = false;
          }
        } catch (e) {
          setState(() {
            _error = true;
          });
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // initializing view models
    _userModel = Provider.of<UserModel>(context);
    _rideModel = Provider.of<RidesViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Schedule Ride",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LocationWidget(
                      screenWidth: screenWidth,
                      tag: _fromLocation == null ? "": _userModel.user.homeLocation.title == _fromLocation.title ? 'Home':'work',
                      title: "Start Location",
                      onPressed: (){
                        _onLocationPressed("start");
                      },
                      content:
                          _fromLocation != null ? _fromLocation.title : "",
                      direction: LocationDirection.FRO,
                    ),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LocationWidget(
                      tag: _toLocation == null ? "":  _userModel.user.workLocation.title == _toLocation.title ? 'Work':'Home',
                      screenWidth: screenWidth,
                      title: "Destination",
                      onPressed: (){
                        _onLocationPressed("dest");
                      },
                      content: _toLocation != null ? _toLocation.title : "",
                      direction: LocationDirection.TO,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FormSelector(
                    showTopBorder: true,
                    value: MyUtils.getReadableDate(_date1),
                    title: "Date",
                    desc: "Click to pick a date",
                    onPressed: () async {
                      DateTime result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(hours: 5)),
                          firstDate:
                              DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      if (result != null) {
                        setState(() {
                          _date = MyUtils.getReadableDate(result);
                          _date1 = result;
                        });
                      }
                    },
                  ),
                  FormSelector(
                    value: MyUtils.toTimeString(_time1),
                    title: "Time",
                    desc: "Click to pick a time",
                    onPressed: () async {
                      TimeOfDay result = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (result != null) {
                        setState(() {
                          _time = MyUtils.toTimeString(result);
                          _time1 = result;
                        });
                      }
                    },
                  ),
                  FormSelector(
                    value: widget.driveOrRide == null ? _driving == DriveOrRide.DRIVE ? "Yes" : "No":
                    widget.driveOrRide == DriveOrRide.DRIVE ? "Yes":"No",
                    title: "Driving?",
                    desc: "Click to proceed",
                    onPressed:()async{
                     // await onDrivingPressed(context);
                      showDrivngDialog(context);
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  AnimatedContainer(
                    child: Column(
                      children: <Widget>[
                        _driving == DriveOrRide.DRIVE
                            ? Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Others",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: _driving == DriveOrRide.DRIVE ? 20 : 0,
                        ),
                        _driving == DriveOrRide.DRIVE
                            ? Container(
                                height: 100,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: InkWell(
                                          onTap: () {
                                            _handlePressed(index);
                                          },
                                          child: Card(
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Column(
                                                children: <Widget>[
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 70,
                                                    child: Text(
                                                      others[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    otherValues[index],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : Container(),
                      ],
                    ),
                    duration: Duration(milliseconds: 1000),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SecondaryButton(
                      title: "Schedule Ride",
                      handleClick: _handleCreatingRides,
                      width: double.infinity,
                      loading:
                          _rideModel.state == PostState.POSTING ? true : false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }

  Future<Function> onDrivingPressed(BuildContext context) async {
    print("oo ggg ${_userModel.user.drivingState}");
    return (_userModel.user.drivingState ==
                              DrivingState.Drives) &&
                          _userModel.user.carDetails.licenseImageUrl != null
                      ? () async {
      print("oo ff");
                          await showDrivngDialog(context);
                        }
                      : null;
  }

  Future showDrivngDialog(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder:(c){
          return DrivingStatusFormWidget(
            driving: _driving,
          );
        });
    if (result != null) {
      setState(() {
        _driving = result;
      });
    }
  }

  void _onLocationPressed(String type){
    print("hh");
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Select Saved Locations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              if(type == "start"){
                setState(() {
                  _fromLocation = _userModel.user.homeLocation;
                });
              }else{
                setState(() {
                  _toLocation = _userModel.user.homeLocation;
                });
              }

              Navigator.pop(context);
            },
            child: Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20,),
                  SvgPicture.asset("assets/img/home.svg", height: 30,width: 30,color: Color(0XFF4D7CF2),),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                    Text("Home location", style: TextStyle(color: Color(0XFF4D7CF2)),),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                        child: Text(_userModel.user.homeLocation.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Spacer(),
                  ],),
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              if(type == "start"){
                setState(() {
                  _fromLocation = _userModel.user.workLocation;
                });
              }else{
                setState(() {
                  _toLocation = _userModel.user.workLocation;
                });
              }
              Navigator.pop(context);
            },
            child: Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20,),
                  SvgPicture.asset("assets/img/briefcase.svg", height: 30,width: 30,color: Color(0XFFE3560C),),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text("Work Address", style: TextStyle(color: Color(0XFFE3560C)),),
                      SizedBox(height: 5,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(_userModel.user.workLocation.title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Spacer(),
                    ],),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void _handlePressed(int index) async {
    if (index == 0) {
      bool result = await showDialog(
          context: context,
          builder: (c){
            return RidingVisibillityFormWidget(
              isVisible: true,
            );
          });
      if (result != null) {
        setState(() {
          _visibillityMain = result;
          if (_visibillityMain == true) {
            otherValues[0] = "Visible";
          } else {
            otherValues[0] = "Invisible";
          }
        });
      }
    } else if (index == 1) {
      int result = await showDialog(
          context: context,
          builder: (c){
            return DynamicAlertFormFormWidget(
              title: "Ride Price",
              value: _priceMain.toString(),
            );
          });
      if (result != null) {
        setState(() {
          _priceMain = result;
          otherValues[1] = "NGN $_priceMain";
        });
      }
    } else if (index == 2) {
      int result = await showDialog(
          context: context,
          builder: (c){
            return DynamicAlertFormFormWidget(
              title: "Available Seats",
              value: _seatsAvailableMain.toString(),
            );
          });
      //print("result $result");
      if (result != null) {
        setState(() {
          _seatsAvailableMain = result;
          otherValues[2] = "$_seatsAvailableMain Seats";
        });
      }
    } else if (index == 3) {
      if(_invitedRidersMain.length == 1){
        showSimpleNotification(Text("You can only invite on car owner at a time, "
            "invite more when ride is created"),background: Colors.green);
        return;
      }
      User result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SameRouteRidersScreen()));
      print("ebuja ${result.toString()}");
        if (result != null) {
          print("ebujja ${result.toString()}");
          setState(() {
            _invitedRidersMain = _invitedRidersMain..add(result);

            otherValues[3] =
                "${MyStrings.numToString(_invitedRidersMain.length)} [${_invitedRidersMain.length}]";
          });
        }

    } else {}
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
        _toLocation = loc;
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
        _fromLocation = loc;
      });
    } else {}
  }

  void _handleCreatingRides() async {


    if(_date1 == null || _time1 == null){

      showSimpleNotification(Text("Please pick a time and date for this ride"),background: Colors.redAccent );
    }else if(_toLocation.title == _fromLocation.title){
      showSimpleNotification(Text("Road block! you need cant be turning on your own na, "
          "choose two different locations to continue."),background: Colors.redAccent );
    }
    else{
      ScheduledRide ride = ScheduledRide(
          dateinMilliseconds: DateTime(_date1.year, _date1.month, _date1.day,
              _time1.hour, _time1.minute)
              .millisecondsSinceEpoch,
          userId: _userModel.user.phoneNumber,
          userName: _userModel.user.fullName,
          work: _userModel.user.work,
          userProfilePix: _userModel.user.avatar,
          userRatings: _userModel.user.ratings,
          fromLocation: _fromLocation,
          toLocation: _toLocation,
          price: _priceMain.toDouble(),
          time: "${_time1.hour}:${_time1.minute}",
          invitedRiders: _invitedRidersMain.length > 0
              ? _invitedRidersMain
              .map((connection) => connection.phoneNumber)
              .toList()
              : [],
          riders: [_userModel.user.phoneNumber],
          ridersRequest: [],
          ratings: Ratings(ratings: [],users: []),
          rideState: RideState.SCHEDULED,
          seatsAvailable: _seatsAvailableMain,
          driveOrRide: _driving);
      print("got here");
      if (_driving == DriveOrRide.DRIVE) {
        Map<String, dynamic> result =
        await _rideModel.makeRideRequest(ride, _userModel.user);
        if (result['success'] == true) {
          _userModel.addRideId(result['ride_id']);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder:(c){
                return AlertDialog(
                  title: Text("Success"),
                  content: Text(
                    "You have created a ride successfully",
                    style: TextStyle(fontSize: 17),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Continue",
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeTabs()),
                                (Route<dynamic> route) => false);
                      },
                    )
                  ],
                );
              });
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

  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
