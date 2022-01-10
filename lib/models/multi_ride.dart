import 'package:flutter/material.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';


class MultiRideModel{
  List<DateTime> dates;
  int amount;
  TheLocation homeLocation;
  TheLocation workLocation;
  TimeOfDayCustom leaveForWork;
  TimeOfDayCustom leaveForHome;

  MultiRideModel({this.leaveForWork, this.leaveForHome,
    this.workLocation, this.homeLocation, this.dates, this.amount});

}