import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';

TextStyle locationNick = TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600);

TextStyle locationDescription = TextStyle(fontSize: 12.0, color: Colors.black);

TextStyle textBold = TextStyle( fontWeight: FontWeight.w700);

TextStyle locationStyle = TextStyle(fontSize: MyUtils.buildSizeWidth(3.5));

TextStyle mainTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w800);
TextStyle secondaryTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
TextStyle rideTitle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

EdgeInsets locationIconInsets = const EdgeInsets.fromLTRB(0,0,6,0);

TextStyle firstLabelStyle = TextStyle(fontSize: MyUtils.fontSize(4), fontWeight: FontWeight.w600);

TextStyle faintTextStyle = TextStyle(fontSize: MyUtils.fontSize(3), fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5));
TextStyle faintTextStyle1 = TextStyle(fontSize: MyUtils.fontSize(3), fontWeight: FontWeight.w500, color: Colors.grey[300]);

class MyBoxDecorations {
  static BoxDecoration selectedBoxDecoration =  BoxDecoration(
      color: primaryColor, borderRadius: BorderRadius.circular(5));
  static BoxDecoration unselectedBoxDecoration = BoxDecoration(
      border: Border.all(color: primaryColor),
      color: Colors.white, borderRadius: BorderRadius.circular(5));
}