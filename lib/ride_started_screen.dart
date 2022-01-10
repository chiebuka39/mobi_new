import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobi/screens/connections/connections_screen.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/view_profile_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'extras/colors.dart';
import 'extras/enums.dart';
import 'extras/message_handler.dart';
import 'extras/utils.dart';
import 'models/scheduled_ride.dart';
import 'models/user.dart';

class RideStartedScreen extends StatefulWidget {
  final ScheduledRide ride;

  const RideStartedScreen({Key key,@required this.ride}) : super(key: key);
  @override
  _RideStartedScreenState createState() => _RideStartedScreenState();
}

class _RideStartedScreenState extends State<RideStartedScreen> with AfterLayoutMixin<RideStartedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  bool _loading = true;
  List<User> members = List();
  ScheduledRide _ride;
  ProgressDialog pr;
  bool waiting = false;

  final StreamController<ScheduledRide> _rideController = StreamController<ScheduledRide>();

  Stream<ScheduledRide> get ride => _rideController.stream;

  void _rideUpdated(DocumentSnapshot snapshot){
    if(snapshot.data != null){
    _rideController.add(ScheduledRide.fromFirestore(snapshot.data()));
    }
  }

  @override
  void initState() {
    _ride = widget.ride;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context)async {
    print("999999 ${widget.ride.ridersState}");

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: "Please wait");

    if (_ride.riders.length > 0) {
      List<User> members1 =
          await _userModel.getAllUsers(_ride.riders);
      setState(() {
        members = members1;
      });

    }
    setState(() {
      _loading = false;
    });

    //handleUserAvailable();

    _ridesViewModel.getRide(widget.ride).listen(_rideUpdated);
    ride.listen((ride){
      print("ride --- ${ride.ridersState}");
      setState(() {
        _ride = ride;
      });
      if(_ride.rideState == RideState.ENDED){
        _ridesViewModel.delete(ride);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MessageHandler(child: HomeTabs(),)),
                (Route<dynamic> route) => false);
      }
      handleUserAvailable();
    });
  }

  void handleUserAvailable() {
    int index = widget.ride.riders.indexOf(_userModel.user.phoneNumber);
    if(_ride.ridersState[index] == 3){
      setState(() {
        waiting = true;
      });
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Spacer(),
              _userModel.user.phoneNumber == _ride.userId ? PrimaryButton(title: "End Ride", handleClick: (){
                showStartEndDialog(context);
              },):Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                FlatButton(child: Text("Cancel ride"),onPressed: (){

                },),
               waiting == false ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: PrimaryButton(title: "Available for pickup", handleClick: (){
                    //showStartRideDialog(context);
                  },width: 180,),
                ):Container()
              ],),
              Spacer(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: _loading == true
              ? Container(
            height: size.height,
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ConstrainedBox(
                      child: Text(
                        "Your ride has started",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      constraints: BoxConstraints(maxWidth: size.width / 3),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(40))),
                    width: size.width / 2,
                    height: 300,
                    child: Column(
                      children: <Widget>[
                      SizedBox(height: 100,),
                      Text("", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
                      SizedBox(height: 40,),
                      Text("", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),)
                    ],),
                  )
                ],
              ),
              SizedBox(height: 40,),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LocationTitleWidget(
                    address: _ride.fromLocation.title,
                    size: size,
                    locationDirection: LocationDirection.FRO,
                    color: Colors.black,
                  ),
                )
              ],),
              SizedBox(height: 50,),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LocationTitleWidget(
                    address: _ride.toLocation.title,
                    size: size,
                    locationDirection: LocationDirection.TO,
                    color: Colors.black,
                  ),
                )
              ],),
              SizedBox(height: 80,),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Other Riders", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                )
              ],),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                child: members.length == 0
                    ? Padding(
                  child:
                  Text("You do not have any fellow riders now"),
                  padding: EdgeInsets.symmetric(
                      horizontal: MyUtils.buildSizeWidth(6)),
                )
                    : ListView.builder(
                  itemBuilder: (context, index) {
                    if (members[index] != null) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: MyUtils.buildSizeWidth(6)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ViewProfileScreen(
                                      user: members[index],
                                    )));
                          },
                          child: Column(
                            children: <Widget>[
                              Hero(
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    width: 70,
                                    imageUrl: members[index].avatar,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                tag: members[index].phoneNumber,
                              ),
                              SizedBox(height:5),
                              ConstrainedBox(child: Text.rich(TextSpan(children: [
                                TextSpan(text: "${members[index].fullName}"),
                                buildTextSpan(index)
                              ])), constraints: BoxConstraints(minWidth: 70),)
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: MyUtils.buildSizeWidth(6)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ConnectionsScreen(
                                      mainConnections:
                                      _userModel.connections,
                                      connections:
                                      _userModel.connections,
                                    )));
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                BorderRadius.circular(5)),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: members.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ));
  }

  TextSpan buildTextSpan(int index) {
    try{
      if(_ride.ridersState[index] == 2){
        return TextSpan(text: "\nWaiting", style: TextStyle(color: Colors.yellow));
      }else if(_ride.ridersState[index] == 3){
        return TextSpan(text: "\nJoined", style: TextStyle(color: Colors.green));
      }else{
        return TextSpan(text: "\nCancelled", style: TextStyle(color: Colors.redAccent));
      }
    }catch(e){
      return TextSpan(text: '');
    }


  }

  void endRide() async {
    pr.show();
    bool result = await _ridesViewModel.setRideState(
        widget.ride, _userModel.user.phoneNumber, RideState.ENDED);
    pr.hide();

    if (result == true) {
      showInSnackBar("This ride has Ended");
      await Future.delayed(Duration(seconds: 2));
      //Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MessageHandler(child: HomeTabs(),)),
              (Route<dynamic> route) => false);
    } else {
      showInSnackBar("The ride could not be Ended, try again");
    }
  }

  void showStartEndDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text("You are about to End this ride"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    endRide();
                  },
                  child: new Text('Yes')),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('No'))
            ],
          );
        });
  }

  void showEndRideDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text("End this ride"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    cancelRide();
                  },
                  child: new Text('Yes')),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('No'))
            ],
          );
        });
  }

  void cancelRide() async {
    pr.show();
    bool result = await _ridesViewModel.setRideState(
        widget.ride, _userModel.user.phoneNumber, RideState.ENDED);
    pr.hide();

    if (result == true) {
      showInSnackBar("This ride has ended");
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MessageHandler(child: HomeTabs(),)),
              (Route<dynamic> route) => false);
    } else {
      showInSnackBar("The ride could not be put to an end, try again");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }
}
