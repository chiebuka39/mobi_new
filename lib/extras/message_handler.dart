import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class MessageHandler extends StatefulWidget {
  final Widget child;

  const MessageHandler({Key key,@required this.child}) : super(key: key);
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> with AfterLayoutMixin<MessageHandler>{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  StreamSubscription iosSubscription;
  UserModel _userModel;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return widget.child;
  }


  _saveDeviceToken() async {
    // Get the current user
    String uid = _userModel.user.phoneNumber;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to FireStore
    if (fcmToken != null) {
      print("this is my uid ${uid.substring(1)}");
      //_fcm.subscribeToTopic("$uid");
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print("-----3----3---3--3");
    if (Platform.isIOS) {
      _fcm.requestPermission();


    }else{
      _saveDeviceToken();
    }
  }
}
