import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/widgets/location_widget.dart';


class Widgets {
  static Widget rowOfSourceNdDest(
      Size size, TheLocation fromLocation, TheLocation toLocation) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: LocationWidget(
            screenWidth: size.width,
            tag: '',
            title: "Start Location",
            content:fromLocation.title,
            direction: LocationDirection.FRO,
          ),
        ),
        SizedBox(
          height: 34,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: LocationWidget(
            tag: "",
            screenWidth:size.width,
            title: "Destination",
            content: toLocation.title,
            direction: LocationDirection.TO,
          ),
        ),
      ],
    );
  }

  static void showCustomDialog(String content, BuildContext context, String title,
      String actionTitle, Function handleActionClicked) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(actionTitle),
              onPressed: handleActionClicked,
            ),
          ],
        );
      },
    );
  }
}
