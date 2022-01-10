import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrafficTabScreen extends StatefulWidget {
  @override
  _TrafficTabScreenState createState() => _TrafficTabScreenState();
}

class _TrafficTabScreenState extends State<TrafficTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(flex: 2,),
              SvgPicture.asset("assets/img/traffic.svg"),
              Text(
                "Traffic Updates coming soon",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 250,
                child: Text(
                  "You would soon be able to  see all traffic updates as regards your route, real time",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(flex: 4,),
            ],
          ),
        ),
      ),
    );
  }
}
