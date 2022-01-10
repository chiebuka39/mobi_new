import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/widgets/primary_button.dart';

class RideOrDriveWidget extends StatelessWidget {
  final Size size;
  final DrivingState drivingState;
  final Function changeToDrives;
  final Function changeToNotDrives;
  final Function onPressed;

  const RideOrDriveWidget(
      {Key key,
        @required this.size,
        @required this.drivingState,
        @required this.changeToDrives,
        @required this.changeToNotDrives, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "How Do you commute daily?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spacer(
            flex: 3,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: InkWell(
                          onTap: changeToDrives,
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                SvgPicture.asset(
                                  "assets/img/car.svg",
                                  width: 70,
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "I Drive",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        child: AnimatedOpacity(
                          child: Container(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor),
                          ),
                          duration: Duration(milliseconds: 300),
                          opacity: drivingState == DrivingState.Drives
                              ? 1.0
                              : 0.0,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: InkWell(
                          onTap: changeToNotDrives,
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                SvgPicture.asset(
                                  "assets/img/business-man.svg",
                                  width: 70,
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "I ride",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        child: AnimatedOpacity(
                          child: Container(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor),
                          ),
                          duration: Duration(milliseconds: 300),
                          opacity:
                          drivingState == DrivingState.Does_Not_Drive
                              ? 1.0
                              : 0.0,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Spacer(
            flex: 2,
          ),
          SecondaryButton(handleClick: (){
            onPressed();
          }, title: "Next",
            width: double.infinity,
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
