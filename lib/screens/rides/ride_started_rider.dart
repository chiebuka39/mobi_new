import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';

class RideStartedRider extends StatefulWidget {
  final ScheduledRide ride;

  const RideStartedRider({Key key, this.ride}) : super(key: key);
  @override
  _RideStartedRiderState createState() => _RideStartedRiderState();
}

class _RideStartedRiderState extends State<RideStartedRider> with AfterLayoutMixin<RideStartedRider> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;

  @override
  void afterFirstLayout(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
