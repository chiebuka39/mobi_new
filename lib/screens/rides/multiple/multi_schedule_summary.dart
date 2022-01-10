import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
 
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MultiScheduleSummary extends StatefulWidget {
  @override
  _MultiScheduleSummaryState createState() => _MultiScheduleSummaryState();
}

class _MultiScheduleSummaryState extends State<MultiScheduleSummary> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _ridesViewModel = Provider.of(context);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          FlatButton(onPressed: () async{
            pr.show();
            var result = await _ridesViewModel.createListOfSchedule(user: _userModel.user,
                multiRideModel: _userModel.multiRideModel);
            if(result['success'] == true){
              showSimpleNotification(Text("Schedule creation was successful"),
                  background: Colors.green);
              Future.delayed(Duration(seconds: 2));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageHandler(
                        child: HomeTabs(),
                      )),
                      (Route<dynamic> route) => false);
            }else{
              showSimpleNotification(Text("Schedule creation was not successful"),
                  background: Colors.red);
            }
            pr.hide();
          },child: Text("Create Schedule", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Selected Dates",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SvgPicture.asset("assets/img/edit.svg",height: 17,)
                ],
              ),
            ),
          SizedBox(height: 15,),
          SizedBox(
            height: 40,
            child: ListView.builder(scrollDirection: Axis.horizontal,
                itemCount: _userModel.multiRideModel.dates.length,
                itemBuilder: (context, index){
                  DateTime date = _userModel.multiRideModel.dates[index];
                  return Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 40,width: 100,
                    alignment: Alignment.center,
                    child: Text(MyUtils.getReadableDateOfMonthShort(date), style: TextStyle(color: Colors.white),),
                    decoration: BoxDecoration(
                        color: primaryColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    );
                }),
          ),
          SizedBox(height: 50,),
          FormSelectorSecondary(
            showTopBorder: true,
            value: null,

            title: Container(
              width: 200,
              child: Row(children: <Widget>[
                Icon(Icons.calendar_today, size: 20,),
                SizedBox(width: 5,),
                Text("Time to leave home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)

              ],),
            ),
            desc: Text(MyUtils.getReadableTime2(_userModel.multiRideModel.leaveForWork),
              style: TextStyle(fontWeight: FontWeight.w600),),
            onPressed: () async {
              TimeOfDay time = await showTimePicker(context: context, initialTime: _userModel.user.leaveForHome.toTimeOfDay());
              if(time != null){
                _userModel.multiRideModel = _userModel.multiRideModel..leaveForWork = TimeOfDayCustom.fromTimeOfDay(time);
              }
            },
          ),
          FormSelectorSecondary(
            value: null,

            title: Container(
              width: 200,
              child: Row(children: <Widget>[
                Icon(Icons.calendar_today, size: 20,),
                SizedBox(width: 5,),
                Text("Time to leave work", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)

              ],),
            ),
            desc: Text(MyUtils.getReadableTime2(_userModel.multiRideModel.leaveForHome),
              style: TextStyle(fontWeight: FontWeight.w600),),
            onPressed: () async {
              TimeOfDay time = await showTimePicker(context: context, initialTime: _userModel.user.leaveForWork.toTimeOfDay());
              if(time != null){
                _userModel.multiRideModel = _userModel.multiRideModel..leaveForHome = TimeOfDayCustom.fromTimeOfDay(time);
              }
            },
          ),
          FormSelectorSecondary(
            value: null,

            title: Container(
              width: 120,
              child: Row(children: <Widget>[
                Icon(Icons.location_searching, size: 20,),
                SizedBox(width: 5,),
                Text("Home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)

              ],),
            ),
            desc: Text(_userModel.multiRideModel.homeLocation.title,
              style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          FormSelectorSecondary(
            value: null,

            title: Container(
              width: 120,
              child: Row(children: <Widget>[
                Icon(Icons.location_searching, size: 20,),
                SizedBox(width: 5,),
                Text("Work", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)

              ],),
            ),
            desc: Text(_userModel.multiRideModel.workLocation.title.length > 35
                ? _userModel.multiRideModel.workLocation.title.substring(0,35): _userModel.multiRideModel.workLocation.title,
              style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          FormSelectorSecondary(
            value: null,

            title: Container(
              width: 150,
              child: Row(children: <Widget>[
                Icon(Icons.monetization_on, size: 20,),
                SizedBox(width: 5,),
                Text("Amount per ride", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)

              ],),
            ),
            desc: Text("NGN ${_userModel.multiRideModel.amount}",
              style: TextStyle(fontWeight: FontWeight.w600),),
            onPressed: () async {

              int result = await showDialog(
                  context: context,
                  builder: (context){
                    return DynamicAlertFormFormWidget(
                      title: "Ride Price",
                      value: _userModel.multiRideModel.amount.toString(),
                    );
                  },
              );
              if (result != null) {
                _userModel.multiRideModel = _userModel
                    .multiRideModel..amount = result;
              }
            },
          ),
        ],),
      ),
    );
  }
}
