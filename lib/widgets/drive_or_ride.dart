import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/styles.dart';

class DriveOrRideWidget extends StatelessWidget {
  final DriveOrRide driveOrRide;
  final bool selected;
  const DriveOrRideWidget({
    @required this.driveOrRide,
    @required this.selected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 100,
      height: 50,
      decoration: selected == true ? MyBoxDecorations.selectedBoxDecoration : MyBoxDecorations.unselectedBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(driveOrRide == DriveOrRide.RIDE
              ? "assets/img/pedestrian-walking.png"
              : "assets/img/sports-car.png", color: getContainerColor(selected)),
          Text( getRideString(driveOrRide), style: TextStyle(color: getContainerColor(selected)),)
        ],
      ), duration: Duration(milliseconds: 300),
    );
  }

  String getRideString(DriveOrRide driveOrRide){
    return driveOrRide ==  DriveOrRide.DRIVE ? "Drive" :"Ride";
  }

  Color getContainerColor(bool selected){
    return selected == true ? Colors.white : primaryColor;
  }


}
