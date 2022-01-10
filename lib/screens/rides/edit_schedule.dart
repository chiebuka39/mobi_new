import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/available_rides.dart';
import 'package:mobi/screens/connections/connections_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

import '../choose_location.dart';
import '../home_screen_2.dart';


class EditSchedule extends StatefulWidget {

  final ScheduledRide ride;

  const EditSchedule(
      {Key key,
      this.ride})
      : super(key: key);
  @override
  _EditScheduleState createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule>
    with AfterLayoutMixin<EditSchedule> {
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
  List<Connection> _invitedRidersMain;
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
//      _date1 = DateTime.fromMillisecondsSinceEpoch( widget.ride.dateinMilliseconds);
//      _time1 = TimeOfDay.fromDateTime(_date1);
      _loading = true;
      _visibillityMain = true;
      _visibillity = "Visible";
      _priceMain = widget.ride.price.toInt();
      _price = "NGN ${widget.ride.price}";
      _seatsAvailableMain = widget.ride.seatsAvailable;
      _seatsAvailable = "${widget.ride.seatsAvailable} seats";
      _driving = widget.ride.driveOrRide;
      _invitedRiders = "Zero [0]";
      _ride = widget.ride;
    }

    _scheduleWeeklyRide = false;
    otherValues = [_visibillity, _price, _seatsAvailable, _invitedRiders];
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      _toLocation = _ride.toLocation;
      _fromLocation = _ride.fromLocation;
    });
    if(widget.ride != null){
      var riders = List.from(widget.ride.riders)
        ..remove(_userModel.user.phoneNumber);
      if (_loading == true && riders.length > 0) {
        try {
          var users = await _userModel.getAllUsers(riders);
          if (users.length > 0) {
            List<Connection> connects = [];
            users.forEach((user) {
              connects.add(Connection(
                  userId: _userModel.user.phoneNumber,
                  connectionId: user.phoneNumber,
                  name: user.fullName,
                  userProfilePix: user.avatar,
                  type: ConnectionType.CONNECTIONS));
            });

            setState(() {
              _invitedRidersMain = connects;
              _invitedRiders =
              "${MyStrings.numToString(connects.length)} "
                  "[5]";
              otherValues[3] = "${MyStrings.numToString(connects.length)} "
                  "[${connects.length}]";
              print("kkkkkk ${connects.length}");
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
                        //_onLocationPressed("start");
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
                    child: InkWell(
                      onTap: (){
                        //_onLocationPressed("dest");
                      },
                      child: LocationWidget(
                        tag: _toLocation == null ? "":  _userModel.user.workLocation.title == _toLocation.title ? 'Work':'Home',
                        screenWidth: screenWidth,
                        title: "Destination",
                        content: _toLocation != null ? _toLocation.title : "",
                        direction: LocationDirection.TO,
                      ),
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
                  SizedBox(
                    height: 40,
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
      ScheduledRide ride = _ride;
      print("got here");
      if (_driving == DriveOrRide.DRIVE) {
        Map<String, dynamic> result =
        await _rideModel.makeRideRequest(ride, _userModel.user);
        if (result['success'] == true) {
          _userModel.addRideId(result['ride_id']);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (c){
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
