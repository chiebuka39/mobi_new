import 'dart:math';

import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mobi/api/profile_api.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:overlay_support/overlay_support.dart';



import 'app_config.dart';

class MyUtils {
  final ProfileApi _api = locator<ProfileApi>();


  static void pushToHome(BuildContext context){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MessageHandler(
              child: HomeTabs(),
            )),
            (Route<dynamic> route) => false);
  }

  static String getReadableDate(DateTime date) {
    if(date == null){
      return null;
    }
    String month = MyStrings.intToStringMonth[date.month];
    String dayOfWeek = MyStrings.intToStringDayOfWeek[date.weekday];
    String dayOfMonth = MyStrings.dayOfmonth(date.day);

    return "$dayOfWeek, $dayOfMonth $month";
  }

  static String getDateTitle(DateTime time){
    if(time.day == DateTime.now().day){
      return "Today";
    }else{
      return "${DateTimeFormat.relative(DateTime.now(),relativeTo: time)} ago";
    }
  }

  static String getReadableDate2(DateTime date) {
    if(date == null){
      return null;
    }
    String month = MyStrings.intToStringMonth[date.month];
    String dayOfWeek = MyStrings.intToStringDayOfWeek[date.weekday];
    String dayOfMonth = MyStrings.dayOfmonth(date.day);

    return "$month $dayOfMonth, ${date.year}";
  }
  static String toTimeString(TimeOfDay time) {
    if(time == null){
      return null;
    }
    String hourLabel = addLeadingZeroIfNeeded(time.hourOfPeriod);
    if(time.hourOfPeriod == 0){
      hourLabel = "12";
    }
    final String minuteLabel = addLeadingZeroIfNeeded(time.minute);


    return '$hourLabel:$minuteLabel ${time.period == DayPeriod.pm ? 'PM':'AM'}';
  }

  static String addLeadingZeroIfNeeded(int value) {
    if (value < 10)
      return '0$value';
    return value.toString();
  }


  static void initDynamicLinks(Function handleDeepLink) async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {

      String value = deepLink.queryParameters['invite'];
      print("deep link is available harrrrr");
      handleDeepLink(value);
      showSimpleNotification(Text("deep link available $value"),
          background: Colors.green);
    }
    print("deep link is not available 2");

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            String value = deepLink.queryParameters['invite'];
            print("deep link is secondarily available harrrrr");
            handleDeepLink(value);
            showSimpleNotification(Text("deep link available $value"),
                background: Colors.green);
            //Navigator.pushNamed(context, deepLink.path);
          }else{
            print("deep link is not available 3");
            showSimpleNotification(Text("deep link not available 11"),background: Colors.black);
          }
        },
        onError: (OnLinkErrorException e) async {
          showSimpleNotification(Text("not available"),background: Colors.red);
          print('onLinkError');
          print(e.message);
        }
    );
  }

  static String getReadableDateOfMonth(DateTime date) {
    String month = MyStrings.intToStringMonth[date.month];
    String dayOfMonth = MyStrings.dayOfmonth(date.day);

    return "$dayOfMonth $month";
  }

  static String getReadableDateOfMonthShort(DateTime date) {
    String month = MyStrings.intToStringDayOfWeekShort[date.weekday];
    String dayOfMonth = MyStrings.dayOfmonth(date.day);

    return "$month $dayOfMonth";
  }

  static String getReadableTimeOfDat(DateTime date) {
//    String month = MyStrings.intToStringMonth[date.month];
//    String dayOfMonth = MyStrings.dayOfmonth(date.day);

    return TimeOfDay.fromDateTime(date).hour.toString();
  }

  static String getReadableAddress(String addr) {
    List<String> mainAddress = addr.split(" ");

    if(mainAddress.length > 7){
      var addre = "";
      for(int i = 0; i < 8;  i++){
        addre = addre+ mainAddress[i];
      }
      return addre;
    }else{
      return mainAddress.join("");
    }

  

  }


  static String getFirstWordInASentence(String word){
    return word.split(" ").first;
  }

  static String getReadableTime(DateTime date){
    var time = TimeOfDay.fromDateTime(date);

    var timeString = "${addPreceedingZero(time.hourOfPeriod.toString(),hour: true)}:${addPreceedingZero(time.minute.toString())}${time.period == DayPeriod.pm ? ' PM': ' AM'}";

    return timeString;

  }
  static String getReadableTime2(TimeOfDayCustom time){


    var timeString = "${addPreceedingZero(time.hourOfPeriod.toString())}:"
        "${addPreceedingZero(time.minute.toString())}${time.period == DayPeriod.pm ? ' PM': ' AM'}";

    return timeString;

  }

  static String addTimeOfDayMinutes(TimeOfDayCustom time, int min){
    int hour = time.hour;
    int miute = time.minute;
    int added = miute + min;
    if(added > 59){
      hour = hour + 1;
      miute = added - 59;
    }else{
      miute = added;
    }

    return  getReadableTime2(TimeOfDayCustom(hour: hour,minute: miute));

  }

  static String addPreceedingZero(String data, {bool hour = false}){
    if(data == "0" && hour == true){
      return "12";
    }else if(data.length == 1){
      return "0$data";
    }else{
      return data;
    }
  }

  static String getShortenedLocation(String location, int length){
    if(location.length < length){
      return location;
    }else{
      return "${location.substring(0,length)}...";
    }
  }


  static String getReadableDateWithWords(DateTime date){
    var today = DateTime.now();
    var diff = today.difference(date);
    if(diff == Duration(days: 1)){
      return "Tommorrow";
    }else if(diff == Duration(days: 2)){
      return "Next tommorrow";
    }else if(diff == Duration(days: 0)){
      return "Today ${getReadableDateOfMonth(date)}";
    }else{
      return getReadableDateOfMonth(date);
    }





//    var timeString = "${time.hourOfPeriod}:${time.minute}${time.period == DayPeriod.pm ? 'pm': 'am'}";
//
//    return timeString;

  }

  static void setUpAppConfig(BuildContext context) {
    AppConfig.height = MediaQuery.of(context).size.height;
    AppConfig.width = MediaQuery.of(context).size.width;
    AppConfig.blockSize = AppConfig.width / 100;
    AppConfig.blockSizeVertical = AppConfig.height / 100;
  }

  static double fontSize(double size) => AppConfig.blockSize * size;

  static double buildSizeWidth(double size) => AppConfig.blockSize * size;
  static double buildSizeHeight(double size) {
    if(AppConfig.height < 700){
      
      return (AppConfig.blockSizeVertical * size) * 1.3;
    }else{
      return AppConfig.blockSizeVertical * size;
    }
  }

}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    pprint(size.width);
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.height, size.width) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

bool get isInDebugModeMain {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

bool isVerified(User user) {
  if(user.drivingState == DrivingState.Drives && user.carDetails.carImageUrl ==null ){
    return false;
  }
  return true;
}

void pprint(dynamic value){
  if(isInDebugModeMain){
    print(value);
  }else{

  }

}



//https://mobiride.page.link/FxJRVWmS6PMCGyyG7