import 'package:flutter/material.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/tabs/tab_1.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/home/planned_rides.dart';
import 'package:mobi/widgets/tabs/placeholder_action.dart';
import 'package:mobi/widgets/tabs/update_user_details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'no_rides_widget.dart';
import 'package:after_layout/after_layout.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with AfterLayoutMixin<Header> {
  UserModel _userModel;

  RidesViewModel _ridesViewModel;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    return getHeaderWidget2();
  }

  Widget getHeaderWidget() {
    return _ridesViewModel.scheduledRideList == null
        ? NoRidesYetWidget()
        : _ridesViewModel.scheduledRideList.length > 0
            ? PlannedRidesWidget()
            : NoRidesYetWidget();
  }

  Widget getHeaderWidget2() {
    return StreamBuilder(
      stream:
          _ridesViewModel.getActiveRidesAndSave3(_userModel.user.phoneNumber),

      builder: (BuildContext context, AsyncSnapshot<List<ScheduledRide>> snapshot) {
        if(!snapshot.hasData){
          //print("jjjjj ${snapshot.connectionState}
          return Container(
              height: 220.0,
              child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(8, (index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        margin: EdgeInsets.only(right: 5.0, left: 30.0),
                        height: 220.0,
                        width: 230.0,
                        color: Colors.white,
                      ),
                    );
                  })));
        }else{
          pprint("ghfks -- ${snapshot.hasData}");
          if(snapshot.data.length > 0){
            return PlannedRidesWidget(rideList: snapshot.data,);
          }else{
            return NoRidesYetWidget();
          }
        }
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //_ridesViewModel.fetchAvailableRides(_ridesViewModel.scheduledRideList.first);
  }
}
