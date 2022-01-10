import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/custom/modals.dart';
import 'package:provider/provider.dart';

class EmptyRideWidget extends StatelessWidget {
  const EmptyRideWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of(context);
    RidesViewModel ridesViewModel = Provider.of(context);
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          SizedBox(height: (MediaQuery.of(context).size.height/5),),
          SvgPicture.asset("assets/img/empty.svg"),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 220,
            child: Text(
              "You don't Have a scheduled ride",
              style:
              TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 250,
            child: Text(
              "Start riding today, by finding scheduled rides around you, and joining",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20,),
          ButtonTheme(
            minWidth: 250,
            height: 50,
            buttonColor: primaryColor,
            child: RaisedButton(
              child: Text("Schedule a ride", style: TextStyle(color: Colors.white),),
              onPressed: (){
                _seeAvailableRide(userModel,ridesViewModel,context);
              },
            ),
          )
        ],
      ),
    );
  }

  void _seeAvailableRide(UserModel userModel, RidesViewModel ridesViewModel, BuildContext context) {
    // isVerified(userModel.user) == true
    //     ? userModel.user.drivingState !=
    //     DrivingState.Does_Not_Drive
    //     ? goToDriverScheduleScreen(
    //     context, userModel, true)
    //     : goToRiderScheduleScreen(
    //     context, userModel, true)
    //     : Widgets.showCustomDialog(MyStrings.verifiedMessage,
    //     context, "Verification", "Ok", () {
    //       Navigator.of(context, rootNavigator: true).pop();
    //     });
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context1) {
          return TwoOptionBottomWidget(

            option1CallBack: ()async{
              goToRiderScheduleScreen(
                      context, userModel, true);
            },
            option2CallBack: () async{
              goToDriverScheduleScreen(
                      context, userModel, true);


            },
            option1: "I'm a rider",

            option2: "I'm a Driver",
          );
        });
  }

  void goToDriverScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
print("oooo");
    if (evening == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ScheduleRideDriver(
                driveOrRide: DriveOrRide.DRIVE,

                canEdit: true,
              )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                driveOrRide: DriveOrRide.DRIVE,

                canEdit: canEdit,
              )));
    }
  }

  void goToRiderScheduleScreen(BuildContext context, UserModel userModel,
      [bool canEdit = false, bool evening = false]) {
    if (evening == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(

                  canEdit: canEdit)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(

                  canEdit: canEdit)));
    }
  }
}