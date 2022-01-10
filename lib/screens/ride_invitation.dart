import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/dimens.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:provider/provider.dart';

class RideInvitation extends StatefulWidget {
  @override
  _RideInvitationState createState() => _RideInvitationState();
}

class _RideInvitationState extends State<RideInvitation> {final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  RidesViewModel _viewModel;
  // Work Location
  TheLocation fromLocation;

  // Home Location
  TheLocation toLocation;

  DateTime seclectedDate = DateTime.now();
  TimeOfDay _initTime = TimeOfDay.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _viewModel = Provider.of<RidesViewModel>(context);
    toLocation = _userModel.user.workLocation;
    fromLocation = _userModel.user.homeLocation;
    final size = MediaQuery.of(context).size;
    final heightOfAppBar = size.height / 3.5 + 20;
    final firstcontainerHeight = heightOfAppBar / 1.9;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar:  AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: white,
            elevation: 0,
            title: Text(
              "Ride Invitation",
              style: TextStyle(color: Colors.black),
            ),
          ),
      body: SingleChildScrollView(
      
              child: Container(
                height: MyUtils.buildSizeHeight(100),
                child: Column(
          
          children: <Widget>[
            SizedBox(
                height: 20,
            ),
            Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/img/sports-car.png"),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      "Accept Ride",
                      style: firstLabelStyle,
                    ),
                    Spacer(
                      flex: 4,
                    ),
                    Switch(
                      onChanged: (bool value) {},
                      value: false,
                    )
                  ],
                ),
            ),
            SizedBox(
                height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MyUtils.buildSizeHeight(17),
                    width: Dimens.timeAndDateContainerWidth,
                    decoration: BoxDecoration(
                        color: timeAndDateContainerColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          "17 - 22",
                          style: TextStyle(
                              fontSize: MyUtils.fontSize(6),
                              fontWeight: FontWeight.w700),
                        ),
                        Text(MyStrings.intToStringMonth[seclectedDate.month]),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      //playTimePickerAnimation(false);
                      showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 5, minute: 0));
                    },
                    child: Container(
                      height: MyUtils.buildSizeHeight(17),
                      width: Dimens.timeAndDateContainerWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          color: timeAndDateContainerColor),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            "${_initTime.hourOfPeriod < 10 ? "0${_initTime.hourOfPeriod.toString()}" : _initTime.hourOfPeriod.toString()}:${_initTime.minute < 10 ? "0${_initTime.minute.toString()}" : _initTime.minute.toString()}",
                            style: TextStyle(
                                fontSize: MyUtils.fontSize(6),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(_initTime.period == DayPeriod.am ? "am" : "pm"),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            ),
            SizedBox(
                height: 30,
            ),
            Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    new LocationTitleWidget(
                      address: fromLocation.title,
                      size: size,
                      locationDirection: LocationDirection.FRO,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
            ),
            SizedBox(
                height: 35,
            ),
            Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Row(
                  children: <Widget>[
                    new LocationTitleWidget(
                      address: toLocation.title,
                      size: size,
                      locationDirection: LocationDirection.TO,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
            ),
            SizedBox(
                height: 30,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text.rich(TextSpan(children: [
                        TextSpan(text: "Invited", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MyUtils.buildSizeWidth(4))),
                        TextSpan(text: "\n\n"),
                        TextSpan(text: "for this ride", style: TextStyle(color: Colors.white.withOpacity(0.6))),
                      ])),
                        Text("3 others", style:TextStyle(color: Colors.white))
                      
                      
                    ],),
                  ),
            ),
            Expanded(
                child: Container(),
            ),
            InkWell(
                onTap: () {
                  // if (showing == true) {
                  //   playAnimation();
                  // } else if (timePickerShowing == true) {
                  //   playTimePickerAnimation(true);
                  // } else {
                  //   handleCreatingRides();
                  // }
                },
                child: _viewModel.state == PostState.POSTING
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                      )
                    : Container(
                        width: MyUtils.buildSizeWidth(50),
                        height: MyUtils.buildSizeHeight(6),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {},
                          child: Text(
                            "Create Schedule",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: accentColor,
                        )),
            ),
            Expanded(
                child: Container(),
            ),
          ],
        ),
              ),
      ),
    );
  }
}