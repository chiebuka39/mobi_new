import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/screens/schedule_ride.dart';
import 'package:mobi/screens/schedule_rides_commutters.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class ChooseASchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Container(
        height: MyUtils.buildSizeHeight(58),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Choose a schedule",
                style: firstLabelStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ModalMenuItem(
                    icon: "assets/img/plus.svg",
                    title: "Create your own Schedule",
                    onPressed: () {

                      isVerified(_userModel.user) == true
                          ? _userModel.user.drivingState !=
                                  DrivingState.Does_Not_Drive
                              ? goToDriverScheduleScreen(
                                  context, _userModel, true)
                              : goToRiderScheduleScreen(
                                  context, _userModel, true)
                          : Widgets.showCustomDialog(
                              MyStrings.verifiedMessage,
                              context,
                              "Verification",
                              "Ok", () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                    },
                  ),
                  ModalMenuItem(
                    icon: "assets/img/portfolio.svg",
                    title: "Morning Commutes",
                    onPressed: () {
                      isVerified(_userModel.user) == true
                          ? _userModel.user.drivingState !=
                                  DrivingState.Does_Not_Drive
                              ? goToDriverScheduleScreen(
                                  context, _userModel, false)
                              : goToRiderScheduleScreen(
                                  context, _userModel, false)
                          : Widgets.showCustomDialog(
                              MyStrings.verifiedMessage,
                              context,
                              "Verification",
                              "Ok", () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ModalMenuItem(
                    icon: "assets/img/portfolio.svg",
                    title: "Schedule Evening Commutes",
                    onPressed: () {
                      isVerified(_userModel.user) == true
                          ? _userModel.user.drivingState !=
                                  DrivingState.Does_Not_Drive
                              ? goToDriverScheduleScreen(
                                  context, _userModel, false, true)
                              : goToRiderScheduleScreen(
                                  context, _userModel, false, true)
                          : Widgets.showCustomDialog(
                              MyStrings.verifiedMessage,
                              context,
                              "Verification",
                              "Ok", () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                    },
                  ),
                  ModalMenuItem(
                    icon: "assets/img/destination.svg",
                    title: "Schedule your Travels",
                    onPressed: () {
                      Widgets.showCustomDialog(
                          "You need to be verified to schedule a ride",
                          context,
                          "Verification",
                          "Ok", () {
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void goToDriverScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    Navigator.pop(context);
    if (evening == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                    fromLocation: userModel.user.workLocation,
                    toLocation: userModel.user.homeLocation,
                    canEdit: canEdit,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                    fromLocation: userModel.user.homeLocation,
                    toLocation: userModel.user.workLocation,
                    canEdit: canEdit,
                  )));
    }
  }

  void goToRiderScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    Navigator.pop(context);
    if (evening == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                  toLocation: userModel.user.homeLocation,
                  fromLocation: userModel.user.workLocation,
                  canEdit: canEdit)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                  fromLocation: userModel.user.homeLocation,
                  toLocation: userModel.user.workLocation,
                  canEdit: canEdit)));
    }
  }
}

class ModalMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Function onPressed;

  const ModalMenuItem({Key key, this.icon, this.title, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Container(
          height: MyUtils.buildSizeHeight(16),
          width: MyUtils.buildSizeWidth(35),
          child: Column(
            children: <Widget>[
              Spacer(),
              SvgPicture.asset(icon),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MyUtils.buildSizeWidth(3.3),
                    fontWeight: FontWeight.w600),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
