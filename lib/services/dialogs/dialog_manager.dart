import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/notify.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/extras/notify.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/ride_details.dart';
import 'package:mobi/screens/view_profile_screen.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/promo_widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({Key key,@required this.child}) : super(key: key);
  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> with AfterLayoutMixin<DialogManager> {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  DialogService _dialogService = locator<DialogService>();
  UserModel _usermodel;
  int userLoggedIn = 0;
  String message = "this is a dummy message";
  String title = "this is a dummy title";
  Function notifFunction = () => {print("notif function")};

  @override
  void initState() {


    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerPromoCodeListener(_showPromoDialog);
    _dialogService.registerNotificationListener(_showNotificationDialog);
    configFcm();

    super.initState();
  }
  Future<void> _retrieveDynamicLink() async {

  }



  void configFcm() {
    // FirebaseMessaging.onMessage (onMessage: (Map<String, dynamic> message) async {
    //   print("On Configure $message");
    //   _parseNotification2(message, true);
    // }, onLaunch: (Map<String, dynamic> message) async {
    //   print("On launch $message");
    //   _parseNotification(message, true);
    // }, onResume: (Map<String, dynamic> message) async {
    //   print("On resume $message");
    //
    //   _parseNotification(message, true);
    // });

    FirebaseMessaging.onBackgroundMessage((message) => _parseNotification(message.data, true));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      _parseNotification2(message.data, true);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    _usermodel = Provider.of<UserModel>(context);
    return widget.child;
  }

  _parseNotification(Map<String, dynamic> notification, bool navigate) async{
    print("Got here to parse Notif");
    var isIos = Platform.isIOS;

    if(isIos == true){
      String typeFromMessaging = notification['type'];

      NotificationType type = Notify.getTypeFromInt(typeFromMessaging);
      print("Notify ${type}");
      print("Notify second ${notification['id']}");
     // keytool -exportcert -list -v \-alias key.jks -keystore /Users/mac/Documents/o/mobiride
      switch(type){
        case NotificationType.RIDE_INVITE:
          print("hhhhhh");
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          break;
        case NotificationType.USER_CONNECTED:
          Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(userId: notification['id'],)));
          break;
        case NotificationType.RIDE_ACCEPTED:
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          break;
        case NotificationType.RIDE_REQUEST:
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          break;
        case NotificationType.RANDOM:
          message = notification['content'];
          _dialogService.showNotificationDialog();
          break;
        default:
          break;
      }
    }else{
      String typeFromMessaging = notification['data']['type'];

      NotificationType type = Notify.getTypeFromInt(typeFromMessaging);
      print("Notify ${type}");
      print("Notify second ${notification['data']['id']}");

      switch(type){
        case NotificationType.USER_CONNECTED:
          Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(userId: notification['data']['id'],)));
          break;
        case NotificationType.RIDE_ACCEPTED:
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          break;
        case NotificationType.RIDE_INVITE:
          print("hhhh4hh");
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          break;
        case NotificationType.RIDE_REQUEST:
          Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          break;
        case NotificationType.RANDOM:
          message = notification['data']['content'];
          _dialogService.showNotificationDialog();
          break;
        default:
          break;
      }
    }

    

    //print("data $data");

  }
  _parseNotification2(Map<String, dynamic> notification, bool navigate) async{
    print("Got here to parse Notif");
    var isIos = Platform.isIOS;

    if(isIos == true){
      String typeFromMessaging = notification['type'];

      NotificationType type = Notify.getTypeFromInt(typeFromMessaging);
      message = notification['notification']['desc'];
      title = notification['notification']['title'];
      print("Notify ${type}");
      print("Notify second ${notification['id']}");
      print("Notify ff $message");
      print("Notify second ff $title");

      switch(type){
        case NotificationType.RIDE_INVITE:
          print("hhhhhh");
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.USER_CONNECTED:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(userId: notification['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RIDE_ACCEPTED:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RIDE_REQUEST:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RANDOM:
          message = notification['content'];
          _dialogService.showNotificationDialog();
          break;
        default:
          break;
      }
    }else{
      String typeFromMessaging = notification['data']['type'];

      NotificationType type = Notify.getTypeFromInt(typeFromMessaging);
      print("Notify ${type}");
      print("Notify second ${notification['data']['id']}");
      message = notification['data']['desc'];
      title = notification['data']['title'];
      print("Notify ${type}");
      print("Notify second ${notification['id']}");
      print("Notify ff $message");
      print("Notify second ff $title");

      switch(type){
        case NotificationType.USER_CONNECTED:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(userId: notification['data']['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RIDE_ACCEPTED:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RIDE_INVITE:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RIDE_REQUEST:
          notifFunction = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(rideId: notification['data']['id'],)));
          _dialogService.showNotificationDialog();
          break;
        case NotificationType.RANDOM:
          message = notification['data']['content'];
          _dialogService.showNotificationDialog();
          break;
        default:
          break;
      }
    }



    //print("data $data");

  }

  void _showDialog() {
    Alert(context: context,
        title: 'Some Rides are due',
      desc: "You would need to cancel some rides that are due, click on a due ride and cancel",
      closeFunction: () => _dialogService.dialogComplete(),
      buttons: [
        DialogButton(child: Text("OK"),onPressed: (){
          _dialogService.dialogComplete();
          Navigator.of(context).pop();
        },)
      ]
    ).show();
  }

  void _showNotificationDialog() {
    Alert(context: context,
        title: title,
        desc: message,
        closeFunction: () => _dialogService.dialogComplete(),
        buttons: [
          DialogButton(child: Text("OK"),onPressed: (){
            _dialogService.dialogComplete();
            Navigator.of(context).pop();
            notifFunction();
          },)
        ]
    ).show();
  }

  void _showPromoDialog() {
    showDialog(context: context,
    barrierDismissible: false,
        builder: (context) =>
            PromoWidget(
              closeFuction: () {
                _dialogService.dialogComplete();
                Navigator.of(context).pop();
              },
              sendToWallet: (){},
            ));

  }

  @override
  void afterFirstLayout(BuildContext context) {
    MyUtils.initDynamicLinks((String couponId)async{
      User couponConsumer = _usermodel.user;
       _usermodel.coupon = couponId;
    });
    _retrieveDynamicLink();

    fetchUserConnections();
  }

  void fetchUserConnections() {
    _usermodel.getConnections();


  }

//  void listenToUser() {
//    if(userLoggedIn == 1){
//      print("--------------------");
//      print("--------------------");
//      _usermodel.listenForUser(_usermodel.user.phoneNumber). .listen((event) {
//        print("/////////");
//        print("/////--${event.phoneNumber}////");
//        print("/////////");
//      });
//      print("--------------------");
//    }
//  }
}

//{notification: {title: New Connection, body: precious ken connected with you}, data: {userId: +2348100001112}}

//On resume {notification: {}, data: {collapse_key: me.mobbid.mobiride, google.original_priority: high, google.sent_time: 1569322507602, google.delivered_priority: high, google.ttl: 2419200, from: 416750575094, type: 1, userId: +2348100001112, google.message_id: 0:1569322507619547%8b64a79f8b64a79f}}