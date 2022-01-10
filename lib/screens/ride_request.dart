import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/rides/pickup_drop_screen.dart';
import 'package:mobi/screens/settings/wallet.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/approve_request_bottom_widget.dart';
import 'package:mobi/widgets/custom/ride_request_widget.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:mobi/widgets/set_up_profile/profile_details_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RideRequestScreen extends StatefulWidget {
  final ScheduledRide ride;

  const RideRequestScreen({Key key, this.ride}) : super(key: key);

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen>
    with AfterLayoutMixin<RideRequestScreen> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  bool _loading = false;
  bool _ownerLoading = false;
  User user;
  bool alreadyScheduled = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    User user1 = await _userModel.getAUser(widget.ride.userId);
    List answers = _ridesViewModel.scheduledRideList
        .where((ride) => ride.id == widget.ride.id)
        .toList();
    pprint("this is the answers $answers");
    if (answers.length > 0) {
      pprint("this is the second $answers");
      setState(() {
        alreadyScheduled = true;
        user = user1;
      });
    } else {
      setState(() {
        alreadyScheduled = false;
        user = user1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    pprint("ride request ${widget.ride.userId}");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Send ride Request to",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: _ownerLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : RideRequestWidget(
              ride: widget.ride,
              size: size,
              user: user,
              buttonTitle: "Send request",
              loading: _loading,
              handleFunctionPressed: sendRideRequest,
            ),
    );
  }

  sendRideRequest() async {
    if(_userModel.user.balance > widget.ride.price){
      setState(() {
        _loading = true;
      });
      var result = await _ridesViewModel.sendRideRequest(
          widget.ride, _userModel.user.phoneNumber);
      setState(() {
        _loading = false;
      });
      if (result == false) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Request Status"),
                content: Text("Your Request was not successful"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Request Status"),
                content: Text("Your Request was successful"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("ok"),
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
      }
    }else{
      showSimpleNotification(
          Text("You don't have enough balance"
              " to schedule this ride"),background: Colors.green,
      trailing: FlatButton(
        child: Text("Load wallet",
          style: TextStyle(color: Colors.white),),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen()));
        },),autoDismiss: false,slideDismiss: true);
    }

  }
}
