import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/message_handler.dart' as MessageHandler1;
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/choose_location.dart';
import 'package:mobi/screens/update_profile/harry.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

import 'home_screen_2.dart';

class SetLocationsScreen extends StatefulWidget {
  final bool firstTimeUser;

  const SetLocationsScreen({Key key, this.firstTimeUser = false})
      : super(key: key);
  @override
  _SetLocationsScreenState createState() => _SetLocationsScreenState();
}

class _SetLocationsScreenState extends State<SetLocationsScreen> {
  UserModel _userModel;

  TheLocation _homeLocation;
  TheLocation _workLocation;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    final size = MediaQuery.of(context).size;
    pprint(size.height);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: size.height / 10,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Set Work and Home locations",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: white),
                  )),
            ),
            decoration: BoxDecoration(color: primaryColor),
          ),
          SizedBox(
            height: 60,
          ),
          Image.asset(
            "assets/img/adventure.png",
            scale: 1.5,
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () async {
                TheLocation loc = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocationSearchScreen(
                              direction: LocationDirection.FRO,
                              save: false,
                            )));
                if (loc != null) {
                  setState(() {
                    _homeLocation = loc;
                  });
                } else {}
              },
              child: Material(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "Home Location",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          _homeLocation == null
                              ? "Click to Search"
                              : _homeLocation.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () async {
                TheLocation loc = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocationSearchScreen(
                              direction: LocationDirection.TO,
                            )));
                            if (loc != null) {
                  setState(() {
                    _workLocation = loc;
                  });
                } else {}
              },
              child: Material(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "Work location",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          _workLocation == null
                              ? "Click to Search"
                              : _workLocation.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  onPressed: (_workLocation == null ||
                          _homeLocation == null)
                      ? null
                      : _updateUserLocations,
                  color: primaryColor,
                  child: _userModel.viewState == ViewState.IDLE
                      ? Text(
                          "Save and Proceed",
                          style: TextStyle(color: Colors.white),
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                )),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void _updateUserLocations() async {
    String response = await _userModel.updateUser(homeLocation: _homeLocation,workLocation: _workLocation);
    FirebaseMessaging.instance
        .subscribeToTopic(_userModel.user.phoneNumber.substring(1));
    //Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MessageHandler1.MessageHandler(
                  child: HomeTabs(
                    firstTimeUser: true,
                  ),
                )),
        (Route<dynamic> route) => false);
  }
}
