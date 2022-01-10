import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/screens/rides/multiple/select_depature_time_screen.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:provider/provider.dart';

class ConfirmLocationScreen extends StatefulWidget {
  @override
  _ConfirmLocationScreenState createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  UserModel _userModel;
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    print("ebuka ${_userModel.multiRideModel.dates.length}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            child: Text(
              "Confirm work and home locations",
              style: rideTitle,
            ),
          ),
          SizedBox(
            height: 35,
          ),
            LocationWidget(
              screenWidth: MediaQuery.of(context).size.width,
              title: "Home Location",
              direction: LocationDirection.FRO,
              content: _userModel.user.homeLocation.title,
            ),
            SizedBox(
              height: 35,
            ),
            LocationWidget(
              screenWidth: MediaQuery.of(context).size.width,
              title: "Work Location",
              direction: LocationDirection.TO,
              content: _userModel.user.workLocation.title,
            ),
            SizedBox(
              height: 40,
            ),
            Text("The locations showed above is where "
                "we would schedule rides to and fro from"),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  color: primaryColor,
                  child: Text(
                    "Continue".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _goToNextScreen,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
        ],),
      ),
    );
  }

  void _goToNextScreen() {
    _userModel.multiRideModel = _userModel.multiRideModel
      ..workLocation = _userModel.user.workLocation
      ..homeLocation = _userModel.user.homeLocation;
    Navigator.push(context, MaterialPageRoute(builder: (_) => SelectHomeDepartureTime()));
  }
}
