import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/ride_request.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/chat_screen.dart';
import 'package:mobi/screens/rides/edit_ride_screen.dart';
import 'package:mobi/screens/rides/ride_history_detail_screen.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/screens/view_user_screen.dart';
import 'package:mobi/widgets/form/form_selector.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/view_profile_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/home/planned_rides.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'connections/connections_screen.dart';
import 'ride_started/ride_started_screen.dart';

class RideDetailsScreen extends StatefulWidget {
  final ScheduledRide ride;
  final String rideId;

  const RideDetailsScreen({Key key, this.ride, this.rideId}) : super(key: key);

  @override
  _RideDetailsScreenState createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen>
    with AfterLayoutMixin<RideDetailsScreen> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  User rideOwner;
  bool loading = false;
  ScheduledRide ride;

  int index;

  @override
  void afterFirstLayout(BuildContext context) {
    if (loading = true && widget.rideId != null) {
      _ridesViewModel.getRemoteRide(widget.rideId).then((result) {
        pprint("this is result error ${result}");
        if (result['error'] == false) {
          setState(() {
            ride = result['ride'];
            loading = false;
            index = ride.riders.indexOf(_userModel.user.phoneNumber);
          });
        } else {
          pprint("this is result error ${result['error']}");
          setState(() {
            loading = false;
          });
        }
      });
    }else{
      index = ride.riders.indexOf(_userModel.user.phoneNumber);
      setState(() {

      });
    }

  }

  @override
  void initState() {
    if (widget.ride == null) {
      pprint("ride is null ${widget.rideId}");

      loading = true;
    } else {
      pprint("ride is not null ${widget.ride.ridersState}");
      ride = widget.ride;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    _userModel = Provider.of<UserModel>(context);

    return loading == true
        ? Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : index == null ? Container()
        : ride.rideState == RideState.STARTED && ride.ridersState[index] == 4
            ? RideStartedScreen2(
                ride: ride,
                shouldEdit: false,
              )
            : _CarOrRiderScaffold();
  }



  StatefulWidget _CarOrRiderScaffold() {
    return ride.userId == _userModel.user.phoneNumber
        ? CarOwnerRideDetails(
            ride: ride,
          )
        : RiderRideDetails(
            ride: ride,
            rideOwner: rideOwner,
          );
  }
}

class CarOwnerRideDetails extends StatefulWidget {
  final ScheduledRide ride;

  const CarOwnerRideDetails({
    Key key,
    @required this.ride,
  }) : super(key: key);

  @override
  _CarOwnerRideDetailsState createState() => _CarOwnerRideDetailsState();
}

class _CarOwnerRideDetailsState extends State<CarOwnerRideDetails>
    with AfterLayoutMixin<CarOwnerRideDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  List<User> members = List();
  List<User> invitations = [];
  List<User> requests = [];
  bool _loading = true;
  ProgressDialog pr;
  ScheduledRide ride;

  @override
  void afterFirstLayout(BuildContext context) async {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    if (widget.ride.riders.length > 1) {
      List<User> members1 =
          await _userModel.getAllUsers(widget.ride.riders.sublist(1));
      setState(() {
        members = members1;
      });
    }
    if (widget.ride.ridersRequest != null) {
      if (widget.ride.ridersRequest.length > 0) {
        pprint("this is not empty");
        List<User> requests1 =
            await _userModel.getAllUsers(widget.ride.ridersRequest);
        pprint("this is not ${requests1.length}");
        setState(() {
          requests = requests1;
        });
      }
    }
    if (widget.ride.invitedRiders.length > 0) {
      pprint(" invited riders this is not empty ${widget.ride.invitedRiders}");
      List<User> invitations1 =
          await _userModel.getAllUsers(widget.ride.invitedRiders.sublist(0));
      setState(() {
        invitations = invitations1;
      });
    }
    setState(() {
      members = List.from(members)..add(null);
      _loading = false;
    });
  }

  @override
  void initState() {
    ride = widget.ride;
    super.initState();
  }

  void _handleDeclineUser(int num) async {
    var result = await _ridesViewModel.acceptOrDeclineRide(
        widget.ride, requests[num].phoneNumber, false);

    if (result['success'] == true) {
      setState(() {
        requests = List.from(requests)..removeAt(num);
      });
    } else {
      pprint("an error occured ${result['message']}");
    }
  }

  void _handleAcceptUser(int num) async {
    var result = await _ridesViewModel.acceptOrDeclineRide(
        widget.ride, requests[num].phoneNumber, true);

    if (result['success'] == true) {
      setState(() {
        User user = requests[num];
        requests = List.from(requests)..removeAt(num);
        members = List.from(members)..insert(0, user);
      });
      print("ppppnnn $requests--- $members");
    } else {
      pprint("an error occured ${result['message']}");
    }
  }

  void cancelRide() async {
    pr.show();
    bool result = await _ridesViewModel.setRideState(
        widget.ride, _userModel.user.phoneNumber, RideState.CANCELLED);
    pr.hide();

    if (result == true) {
      showInSnackBar("This ride has been cancelled");
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    } else {
      showInSnackBar("The ride could not be cancelled, try again");
    }
  }

  void startRide() async {
    pr.show();
    bool result = await _ridesViewModel.setRideState(
        widget.ride, _userModel.user.phoneNumber, RideState.STARTED);
    pr.hide();

    if (result == true) {
      showInSnackBar("This ride has started");
      await Future.delayed(Duration(seconds: 2));
      //Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => RideStartedScreen2(
                    ride: widget.ride,
                  )),
          (Route<dynamic> route) => false);
    } else {
      showInSnackBar("The ride could not be started, try again");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Ride Details Screen",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDeleteRideDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async{
              if(members.length == 1){
                DateTime result =await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditRideScreen(ride: widget.ride)));
                if(result != null){
                  ride.dateinMilliseconds = result.millisecondsSinceEpoch;
                  setState(() {

                  });
                }
              }else{
                showSimpleNotification(Text("You already have co riders, "
                    "you cant reschedule"), background: Colors.red);
              }

            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => RideChatScreen(ride: ride,)));
            },
          )
        ],
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: _loading == true
            ? Container(
                height: size.height,
                color: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MyUtils.buildSizeWidth(5)),
                    child: PlannedRideWidget(
                      user: _userModel.user,
                      ride: ride,
                      bgColor: primaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MyUtils.buildSizeWidth(6)),
                    child: Text("Members*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyUtils.buildSizeWidth(4.2))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
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
                                              builder: (_) => ViewUserScreen(viewProfile: true,user: members[index],)
                                          ));
                                    },
                                    child: Hero(
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          width: 70,
                                          imageUrl: members[index].avatar,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      tag: members[index].phoneNumber,
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
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MyUtils.buildSizeWidth(6)),
                    child: Text("Pending Invitations*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyUtils.buildSizeWidth(4.2))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: invitations.length == 0
                        ? Padding(
                            child: Text("You do not have any invitation now"),
                            padding: EdgeInsets.symmetric(
                                horizontal: MyUtils.buildSizeWidth(6)),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: MyUtils.buildSizeWidth(6)),
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    width: 70,
                                    imageUrl: invitations[index].avatar,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            },
                            itemCount: invitations.length,
                            scrollDirection: Axis.horizontal,
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MyUtils.buildSizeWidth(6)),
                    child: Text(
                      "Ride Requests*",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: requests.length == 0
                        ? Padding(
                            child: Text("You do not have any Request  now"),
                            padding: EdgeInsets.symmetric(
                                horizontal: MyUtils.buildSizeWidth(6)),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return RideRequestWidget(
                                request: requests[index],
                                ride: widget.ride,
                                handleAcceptClicked: () {
                                  _handleAcceptUser(index);
                                },
                                handleDeclineClicked: () {
                                  _handleDeclineUser(index);
                                },
                              );
                            },
                            itemCount: requests.length,
                            scrollDirection: Axis.horizontal,
                          ),
                  ),
                  getMainActionButton(context),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
      ),
    );
  }

  SecondaryButton getMainActionButton(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.ride.dateinMilliseconds);
    var diff = date.difference(DateTime.now()).inMinutes;
    SecondaryButton button;
    print("diff $diff");
    if(diff > 30 ){
      button = SecondaryButton(
        horizontalPadding: 20,
        width: double.infinity,
        title: "Cancel Ride",
        handleClick: () {
          showDeleteRideDialog(context);
        },
      );
    }else if(diff < -30){
      button = SecondaryButton(
        horizontalPadding: 20,
        width: double.infinity,
        title: "Delete Ride".toUpperCase(),
        handleClick: () {
          showDeleteRideDialog(context);
        },
      );
    }
    else{
     button = SecondaryButton(
        horizontalPadding: 20,
        width: double.infinity,
        title: "Start Ride",
        handleClick: () {
          DateTime now = DateTime.now();
          DateTime rideTime =
          DateTime.fromMillisecondsSinceEpoch(
              widget.ride.dateinMilliseconds);
          Duration diff = rideTime.difference(now);
          if (diff.inHours > 1) {
//                                  showSimpleNotification(Text("This ride can\'t be started cos, scheduled time is not close yet"),
//                                      background: Colors.red, contentPadding: EdgeInsets.only(left: 30, right: 30));
//                                  pprint(
//                                      "Date time is still far ${diff.inHours}");
            showStartRideDialog(context);
          } else {
            pprint("Date time is not far ${diff.inHours}");
            showStartRideDialog(context);
          }
        },
      );
    }
    return button;
  }

  void showDeleteRideDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text("Delete this ride"),
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

  void showStartRideDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text("You are about to start this ride"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    startRide();
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
}

class RideRequestWidget extends StatefulWidget {
  final User request;
  final ScheduledRide ride;

  const RideRequestWidget(
      {Key key,
      @required this.request,
      @required this.ride,
      this.handleAcceptClicked,
      this.handleDeclineClicked})
      : super(key: key);

  final Function handleAcceptClicked;
  final Function handleDeclineClicked;

  @override
  _RideRequestWidgetState createState() => _RideRequestWidgetState();
}

class _RideRequestWidgetState extends State<RideRequestWidget> {
  bool acceptLoading = false;
  bool declineLoading = false;

  @override
  Widget build(BuildContext context) {
    RidesViewModel ridesViewModel = Provider.of<RidesViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: MyUtils.buildSizeWidth(6)),
      child: Card(
        child: Container(
          height: 150,
          width: MyUtils.buildSizeWidth(86),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder:
                                (_) => ViewUserScreen(
                                  user: widget.request,
                                  viewProfile: true,
                                )
                            ));
                          },
                          child: Material(
                            elevation: 3,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                    imageUrl: widget.request.avatar, width: 70)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.request.fullName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MyUtils.fontSize(4.5))),
                            SizedBox(
                              height: 10,
                            ),
                            Text(widget.request.phoneNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: MyUtils.fontSize(3))),
                          ],
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Spacer(),
                  ButtonTheme(
                    minWidth: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      color: Colors.blueAccent,
                      child: acceptLoading == false
                          ? Text(
                              "Accept",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            )
                          : Container(
                              width: 5,
                              height: 5,
                              child: CircularProgressIndicator()),
                      onPressed: () {
                        setState(() {
                          acceptLoading = true;
                        });
                        widget.handleAcceptClicked();
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        color: Colors.redAccent,
                        child: declineLoading == false
                            ? Text(
                                "Decline",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              )
                            : Container(
                                width: 5,
                                height: 5,
                                child: CircularProgressIndicator()),
                        onPressed: widget.handleDeclineClicked),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RiderRideDetails extends StatefulWidget {
  final ScheduledRide ride;
  final User rideOwner;

  const RiderRideDetails(
      {Key key, @required this.ride, @required this.rideOwner})
      : super(key: key);

  @override
  _RiderRideDetailsState createState() => _RiderRideDetailsState();
}

class _RiderRideDetailsState extends State<RiderRideDetails>
    with AfterLayoutMixin<RiderRideDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;
  UserModel _userModel;
  RidesViewModel _rideModel;
  int index = -99;
  int index2 = -99;
  int riderState = 0;

  bool waiting;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {

    pprint("rider state  ${widget.ride.ridersState}");
    index = widget.ride.riders.indexOf(_userModel.user.phoneNumber);
    index2 = widget.ride.invitedRiders.indexOf(_userModel.user.phoneNumber);
    pprint("index $index -- ${widget.ride.riders}");
    pprint("index2 $index2 --");
    riderState = widget.ride.ridersState[index];
    if (index != -1) {
      if (widget.ride.ridersState[index] == 3) {
        setState(() {
          waiting = true;
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _rideModel = Provider.of<RidesViewModel>(context);
    pprint("got here ${widget.ride.ridersState}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          widget.ride.ridersRequest.contains(_userModel.user.phoneNumber)
              ?  FlatButton(
                  child: Text("Cancel Ride"),
                  onPressed: _handleCancelRide,
                ): SizedBox()
              ,
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => RideChatScreen(ride: widget.ride,)));

            },
          )
        ],
        title: Text(
          widget.ride.invitedRiders.contains(_userModel.user.phoneNumber)
              ? "Ride Invitations"
              : "Ride Details",
          style: TextStyle(
              color: Colors.black,
              fontSize: MyUtils.fontSize(4.5),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      //body: new CarOwnerRideDetails(members: members, invitations: invitations, requests: requests),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircularProfileAvatar(
                    widget.ride.userProfilePix,
                    radius: 44,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    child: Text(
                      widget.ride.invitedRiders.contains(_userModel.user.phoneNumber) ? "Pending Invitation":
                       widget.ride.riders
                                  .contains(_userModel.user.phoneNumber)
                              ? "Waiting for pickup"
                          :riderState == 1?"Trip Ended":riderState == 0?"Trip Canceled" : "Available for pickup",
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: getStatusCOlor(),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 190,
                child: Text(
                  "${widget.rideOwner == null ? "Rider" : widget.rideOwner.fullName} has not Approved Your request yet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Widgets.rowOfSourceNdDest(MediaQuery.of(context).size,
                  widget.ride.fromLocation, widget.ride.toLocation),
            ),
            SizedBox(
              height: 10,
            ),
            FormSelector(
              showTopBorder: true,
              value: MyUtils.getReadableDate(
                  DateTime.fromMillisecondsSinceEpoch(
                      widget.ride.dateinMilliseconds)),
              title: "Date",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: MyUtils.getReadableTime(
                  DateTime.fromMillisecondsSinceEpoch(
                      widget.ride.dateinMilliseconds)),
              title: "Time",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: widget.ride.price.toString(),
              title: "Ride Cost",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: widget.ride.seatsAvailable.toString(),
              title: "Seate Available",
              desc: "Click to pick a date",
            ),
            SizedBox(
              height: 30,
            ),
            bottomNavigationBar(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusCOlor() {
    if(widget.ride.ridersRequest.contains(_userModel.user.phoneNumber)){
      return riderState <= 1?Colors.redAccent: riderState == 3 ? Colors.green.withOpacity(0.6):Colors.brown.withOpacity(0.6);
    }else if(widget.ride.invitedRiders.contains(_userModel.user.phoneNumber)){
      return Colors.green.withOpacity(0.6);
    }else{
      return Colors.indigo.withOpacity(0.6);
    }

  }

  Widget bottomNavigationBar() {
    if (widget.ride.invitedRiders.contains(_userModel.user.phoneNumber)) {
      return SecondaryButton(
        horizontalPadding: 20,
        title: "Accept Ride Invitation",
        width: double.infinity,
        handleClick: () {
          //setRiderState(_userModel.user, widget.ride, _rideModel);
          _handleAcceptingRide();
        },
        loading: _loading,
      );
    } else {
      if(index != -99){
        if (widget.ride.ridersState[index] == 2) {
          return SecondaryButton(
            horizontalPadding: 20,
            width: double.infinity,
            title: "Available for pickup",
            handleClick: () {
              setRiderState(_userModel.user, widget.ride, _rideModel, 3);
            },
            loading: _loading,
          );
        }else if(widget.ride.ridersState[index] == 1){
          return Center(child: Text("Trip Ended"));
        }
        else if(widget.ride.ridersState[index] == 0){
          return Center(child: Text("Trip Cancelled"));
        }
        else {
          return SecondaryButton(
            horizontalPadding: 20,
            width: double.infinity,
            title: "Join ride",
            handleClick: () {
              print("${widget.ride.rideState}");
              if (widget.ride.rideState != RideState.STARTED) {
                showSimpleNotification(
                    Text("You cant join yet, "
                        "User has not started this ride"),
                    background: Colors.blue);
              } else {
                _userModel.newRide = true;
                setRiderStateJoin(_userModel.user, widget.ride, _rideModel,4);
              }
            },
            loading: _loading,
          );
        }
      }else{
        return SizedBox();
      }

    }
  }

  void _handleCancelRide() async {
    setState(() {
      _loading = true;
    });
    var result = await _rideModel.cancelRide(
        widget.ride, _userModel.user.phoneNumber, false);
    setState(() {
      _loading = false;
    });

    if (result['success'] == true) {
      pprint("this was a success");
      Navigator.pop(context);
    } else {
      pprint("an error occured ${result['message']}");
    }
  }

  void _handleAcceptingRide() async {
    setState(() {
      _loading = true;
    });
    var result = await _rideModel.acceptRideInvitation(
        widget.ride, _userModel.user.phoneNumber, true);
    setState(() {
      _loading = false;
    });

    if (result['success'] == true) {
      pprint("this was a success");
      Navigator.pop(context);
    } else {
      pprint("an error occured ${result['message']}");
    }
  }

  void setRiderStateJoin(
      User user, ScheduledRide ride, RidesViewModel model, int num) async {
    int index = ride.riders.indexOf(user.phoneNumber);
    //set to waiting
    ride.ridersState[index] = num;
    setState(() {
      _loading = true;
    });
    var result =
        await model.setRiderStateToJoin(ride, user, ride.ridersState);
    setState(() {
      _loading = false;
      if (result.error == false) {
        index = index++;
      }
    });
    if (result.error == true) {
      showInSnackBar("An error occured, try again");
    } else {
      showInSnackBar("Your request was successful");
    }
  }

  void setRiderState(
      User user, ScheduledRide ride, RidesViewModel model, int num) async {
    int index = ride.riders.indexOf(user.phoneNumber);
    //set to waiting
    ride.ridersState[index] = num;
    setState(() {
      _loading = true;
    });
    bool result =
    await model.setRiderState(ride, user.phoneNumber, ride.ridersState);
    setState(() {
      _loading = false;
      if (result == true) {
        index = index++;
      }
    });
    if (result == false) {
      showInSnackBar("An error occured, try again");
    } else {
      showInSnackBar("your request was successful");
    }
  }

  _call(String num) async {
    var url = 'tel:$num';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //throw 'Could not launch $url';
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
