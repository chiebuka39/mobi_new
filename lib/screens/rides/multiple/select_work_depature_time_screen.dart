import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/screens/rides/multiple/multi_schedule_summary.dart';
import 'package:mobi/screens/rides/multiple/select_ride_amount_screen.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:provider/provider.dart';

class SelectWorkDepartureTime extends StatefulWidget {
  @override
  _SelectWorkDepartureTimeState createState() => _SelectWorkDepartureTimeState();
}

class _SelectWorkDepartureTimeState extends State<SelectWorkDepartureTime>
    with AfterLayoutMixin<SelectWorkDepartureTime> {
  UserModel _userModel;

  TimeOfDayCustom timeToLeaveWork = TimeOfDayCustom(minute: 00,hour: 5);

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      timeToLeaveWork = _userModel.user.leaveForHome;
    });

  }
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
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
              "When do you usually leave work?",
              style: rideTitle,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          FormSelectorSecondary(
            showTopBorder: true,
            value: null,

            title: Container(
              width: 150,
              child: Row(children: <Widget>[
                Icon(Icons.calendar_today, size: 20,),
                SizedBox(width: 5,),
                Text(MyUtils.getReadableTime2(timeToLeaveWork), style: TextStyle(fontWeight: FontWeight.w600),)
              ],),
            ),
            desc: Text("Edit", style: TextStyle(color: Colors.blue),),
            onPressed: () async {
              TimeOfDay time = await showTimePicker(context: context, initialTime: _userModel.user.leaveForHome.toTimeOfDay());
              if(time != null){
                  setState(() {
                    timeToLeaveWork = TimeOfDayCustom.fromTimeOfDay(time);
                  });
              }
            },
          ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width -100,
              child: Text("Selecting a time when you normally leave your  "
                  "work for home, you can always edit the time later if need be"),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  color: primaryColor,
                  child: Text(
                    "Next".toUpperCase(),
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
    _userModel.multiRideModel = _userModel.multiRideModel..leaveForHome = timeToLeaveWork;
    Navigator.push(context, MaterialPageRoute(builder: (_) => SelectRideAmount()));
  }
}
