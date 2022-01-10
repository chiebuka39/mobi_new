import 'package:flutter/material.dart';

class SettingUpProfile extends StatefulWidget {
  @override
  _SettingUpProfileState createState() => _SettingUpProfileState();
}

class _SettingUpProfileState extends State<SettingUpProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Your Profile is being setup"),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
