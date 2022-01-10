import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/rides/multiple/choose_days.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
 
import 'package:provider/provider.dart';

class ScheduleOptionDriver extends StatefulWidget {
  @override
  _ScheduleOptionDriverState createState() => _ScheduleOptionDriverState();
}

class _ScheduleOptionDriverState extends State<ScheduleOptionDriver> {


  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of(context);
    RidesViewModel _ridesViewModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text("Schedule Options",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ScheduleItem(bgColor: blueLight,title: "Schedule Next week rides",content: "Schedule more than one rides at a time, "
                "this would come in handy scheduling "
                "your weekly rides",onPressed: (){
              if(_ridesViewModel.scheduledRideList.length <= 2){
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChooseDaysScreen()));
              }else{
                showSimpleNotification((Text("You have many other pending rides")),background: Colors.red);
              }
            },
              iconBgColor: Color(0xff84E2FF),icon: "multiple",),

              ScheduleItem(bgColor: orangeLight,title: "Schedule single ride",content: "Schedule more than one rides at a time, "
                  "this would come in handy scheduling "
                  "your weekly rides",iconBgColor: Color(0xffFFAFAF),icon: "multiple",
                onPressed: () {
                  isVerified(userModel.user) == true ? schedulSingleRide(context, userModel):Widgets.showCustomDialog(MyStrings.verifiedMessage,
                      context, "Verification", "Ok", () {
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                }
              ),

              ScheduleItem(bgColor: Color(0xffC8FFE4),title: "Search for rides",
                onPressed: (){
                  searchForRides(context, userModel);
                },
                content: "Schedule more than one rides at a time, "
                  "this would come in handy scheduling "
                  "your weekly rides",iconBgColor: Color(0xff69F0AE),icon: "multiple",),
              SizedBox(height: 30,),
          ],),
        ),
      ),
    );
  }

  void schedulSingleRide(BuildContext context, UserModel userModel) {

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScheduleRideDriver(
                driveOrRide: DriveOrRide.DRIVE,
                fromLocation: userModel.user.homeLocation,
                toLocation: userModel.user.workLocation,
                canEdit: true,
              )));

  }

  void searchForRides(BuildContext context, UserModel userModel) {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ScheduleRideDriver(
              driveOrRide: DriveOrRide.RIDE,
              fromLocation: userModel.user.homeLocation,
              toLocation: userModel.user.workLocation,
              canEdit: true,
            )));

  }
}

class ScheduleItem extends StatelessWidget {
  final Color bgColor;
  final Color iconBgColor;
  final String title;
  final String content;
  final String icon;
  final Function onPressed;
  const ScheduleItem({
    Key key, this.bgColor, this.iconBgColor, this.title, this.content, this.icon, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

          CircleIndicator(color: iconBgColor,icon: icon,),
            SizedBox(height: 25,),
            SizedBox(
              width: 250,
              child: Text(title,
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 10,),
            Text(content, style: TextStyle(),)
        ],),
      ),
    );
  }
}

class CircleIndicator extends StatelessWidget {
  final Color color;
  final String icon;
  const CircleIndicator({
    Key key, this.color, this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:40,
      height:40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color
      ),
      child: Center(
        child: SvgPicture.asset("assets/img/$icon.svg"),
      ),
    );
  }
}
