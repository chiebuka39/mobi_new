import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          SvgPicture.asset("assets/img/logo_onboarding.svg"),
          SizedBox(
            height: 150,
          ),
          SvgPicture.asset("assets/img/drive.svg"),
          Text("For your"),
          Text("Rides to work"),
        ],
      ),
    );
  }
}
