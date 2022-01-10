import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/screens/rides/multiple/select_work_depature_time_screen.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:provider/provider.dart';

class SelectHomeDepartureTime extends StatefulWidget {
  @override
  _SelectHomeDepartureTimeState createState() => _SelectHomeDepartureTimeState();
}

class _SelectHomeDepartureTimeState extends State<SelectHomeDepartureTime>
    with AfterLayoutMixin<SelectHomeDepartureTime> {
  UserModel _userModel;
  TimeOfDayCustom timeToLeaveHome = TimeOfDayCustom(minute: 00,hour: 5);

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      timeToLeaveHome = _userModel.user.leaveForWork;
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
              "When do you usually leave home?",
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
                Text(MyUtils.getReadableTime2(timeToLeaveHome), style: TextStyle(fontWeight: FontWeight.w600),)
              ],),
            ),
            desc: Text("Edit", style: TextStyle(color: Colors.blue),),
            onPressed: () async {
              TimeOfDay time = await showTimePicker(context: context, initialTime: _userModel.user.leaveForWork.toTimeOfDay());
              if(time != null){
                setState(() {
                  timeToLeaveHome = TimeOfDayCustom.fromTimeOfDay(time);
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
                  "home for work, you can always edit the time later if need be"),
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
    _userModel.multiRideModel = _userModel.multiRideModel..leaveForWork = timeToLeaveHome;
    Navigator.push(context, MaterialPageRoute(builder: (_) => SelectWorkDepartureTime()));
  }
}
