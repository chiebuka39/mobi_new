import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';

class PlannedRideWidgetSecondary extends StatelessWidget {
  const PlannedRideWidgetSecondary({
    Key key,
    @required ScheduledRide ride,
    this.bgColor, this.textColor,
    this.iconColor,@required this.user,
    this.height = 170, this.horizontalMargin = 0,

  }) : _ride = ride, super(key: key);

  final ScheduledRide _ride;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final User user;
  final double height;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    print(" kklolol w${_ride.ridersState}");
    var LocationTextStyle = TextStyle(fontSize: 14, color: textColor ?? Colors.black);
    return Padding(
      padding: EdgeInsets.only(left: horizontalMargin,right: horizontalMargin, bottom: 10),
      child: Card(
        elevation: 3,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: bgColor ?? Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: height,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MyUtils.buildSizeWidth(2),
                      height: MyUtils.buildSizeWidth(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.pink),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MyUtils.buildSizeWidth(65),
                      child: Text(
                          MyUtils.getShortenedLocation(_ride.fromLocation.title, 60),
                          style: LocationTextStyle),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MyUtils.buildSizeWidth(2),
                      height: MyUtils.buildSizeWidth(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                        width: MyUtils.buildSizeWidth(65),
                        child: Text(
                          MyUtils.getShortenedLocation(_ride.toLocation.title, 60),
                          style: LocationTextStyle,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/img/clock.svg", color: iconColor ?? Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(MyUtils.getReadableTime(DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds)),style: LocationTextStyle,)
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/img/calendar.svg", color: iconColor ?? Colors.black,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(MyUtils.getReadableDateWithWords(DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds)),
                          style: LocationTextStyle,)
                      ],
                    ),
                    Spacer(),
                    (_ride.ridersRequest != null && _ride.userId == user?.phoneNumber ??"") ? _ride.ridersRequest.length > 0 ? Row(children: <Widget>[
                      Icon(Icons.notifications_active, color: primaryColor,),
                      SizedBox(width: 5,),
                      Text("${_ride.ridersRequest.length}")
                    ],):Container():Container(),
                    _ride.dateinMilliseconds < DateTime.now().millisecondsSinceEpoch ? Row(children: <Widget>[
                      Text("Ride Due", style: TextStyle(color: Colors.redAccent),)
                    ],):Container()

                  ],
                )

              ],
            )),
      ),
    );
  }
}