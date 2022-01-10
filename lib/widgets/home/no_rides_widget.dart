import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';

class NoRidesYetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        elevation: 3,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              height: MyUtils.buildSizeHeight(15),
          width: MyUtils.buildSizeWidth(88),
          child: Column(children: <Widget>[
            Spacer(),
            SvgPicture.asset("assets/img/empty-square.svg"),
            SizedBox(height: MyUtils.buildSizeHeight(1),),
            Text(MyStrings.noPlannedRides, style: firstLabelStyle,),
            Spacer()
          ],),
        ),
      ),
    );
  }
}