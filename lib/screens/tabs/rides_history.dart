import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/screens/ride_details.dart';
import 'package:mobi/screens/rides/ride_history_detail_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

import '../riders_available_widget.dart';

class RidesHistoryScreen extends StatefulWidget {
  RidesHistoryScreen({Key key}) : super(key: key);
  @override
  _RidesHistoryScreenState createState() => _RidesHistoryScreenState();
}

class _RidesHistoryScreenState extends State<RidesHistoryScreen>
    with AfterLayoutMixin<RidesHistoryScreen> {
  RidesViewModel _ridesViewModel;
  UserModel _userModel;
  bool _loading = true;
  List<ScheduledRide> _rides;
  List<ScheduledRide> _previousRides;
  List<ScheduledRide> _upcomingRides;
  List<ScheduledRide> _requestedRides;
  List<ScheduledRide> _invitedRides;

  @override
  void afterFirstLayout(BuildContext context) async {
    var rides = await _ridesViewModel.getAllRides(_userModel.user.phoneNumber);
    var invitedRides =
        await _ridesViewModel.getInvitedRides(_userModel.user.phoneNumber);
    var requestedRides =
        await _ridesViewModel.getRequestedRides(_userModel.user.phoneNumber);

    setState(() {
      _rides = rides;
      _previousRides = _rides
          .where((conect) =>
              ScheduledRide.convertFromRideState(conect.rideState) <=
              ScheduledRide.convertFromRideState(RideState.ENDED))
          .toList();
      _invitedRides = invitedRides
          .where((connect) =>
              ScheduledRide.convertFromRideState(connect.rideState) ==
              ScheduledRide.convertFromRideState(RideState.SCHEDULED))
          .toList();
      _requestedRides = requestedRides.data
          .where((connect) =>
      ScheduledRide.convertFromRideState(connect.rideState) ==
          ScheduledRide.convertFromRideState(RideState.SCHEDULED))
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    _userModel = Provider.of<UserModel>(context);
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Your Trips".toUpperCase(),
            style: TextStyle(fontSize: 16),
          ),
          bottom: TabBar(tabs: [
            Tab(
              child: Text("Previous Rides"),
            ),
            Tab(
              child: Text("Invited Rides"),
            ),
            Tab(
              child: Text("Ride Requests"),
            )
          ]),
        ),
        body: TabBarView(children: [
          _loading == true
              ? new LoadingWidget()
              : _previousRides.length > 0
                  ? ridesWidget(_previousRides, HistoryType.PREVIOUS)
                  : NoRides(
                      message: "You have no previous rides",
                    ),
          _loading == true
              ? new LoadingWidget()
              : _invitedRides.length > 0
                  ? ridesWidget(_invitedRides, HistoryType.INVITED)
                  : NoRides(
                      message: "You have no rides invitations",
                    ),
          _loading == true
              ? new LoadingWidget()
              : _requestedRides.length > 0
                  ? ridesWidget(_requestedRides, HistoryType.REQUESTED)
                  : NoRides(
                      message: "You have no upcoming rides",
                    ),
        ]),
      ),
      length: 3,
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        CircularProgressIndicator(),
        Spacer(),
      ],
    );
  }
}

class NoRides extends StatelessWidget {
  final String message;
  const NoRides({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
            elevation: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              width: double.infinity,
              height: 60,
              color: white,
            )),
        Spacer(),
      ],
    );
  }
}

Widget ridesWidget(List<ScheduledRide> rides, HistoryType type) {
  return Container(
    child: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: onTap(type, context, rides, index),
            child: IgnorePointer(
                child: AvailableRideWidget(
              ride: rides[index],
            )));
      },
      itemCount: rides.length,
    ),
  );
}

Function onTap(HistoryType type, BuildContext context,
    List<ScheduledRide> rides, int index) {
  if (type == HistoryType.INVITED) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RideDetailsScreen(
                    ride: rides[index],
                  )));
    };
  } else if (type == HistoryType.PREVIOUS) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RideHistoryDetailScreen(
                    ride: rides[index],
                  )));
    };
  } else if (type == HistoryType.REQUESTED) {
//    return () {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (_) => RideHistoryDetailScreen(
//                ride: rides[index],
//              )));
//    };
    return null;
  } else {
    return null;
  }
}
