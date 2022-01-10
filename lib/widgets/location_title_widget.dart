import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';



class LocationTitleWidget extends StatelessWidget {
  final String address;
  final LocationDirection locationDirection;
  final Color color;
  final double widthFromUp;

  const LocationTitleWidget(
      {Key key,
        @required this.size,
        @required this.locationDirection,
      this.color = Colors.white, this.address = "", this.widthFromUp})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var width;
    if(size.width > 450){
      width = size.width- 120;
    }else{
      width = size.width - 140;
    }
    return Row(
      children: <Widget>[
        Container(
            width: 15,
            height: 15,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDAF2FF)),
            child: Center(
              child: Container(
                width: 5,
                height: 5,
                decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryColor),
              ),
            )),
        SizedBox(
          width: 10,
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {

            return  SizedBox(
              width: widthFromUp == null? width : widthFromUp,
              child: RichText(
                text: TextSpan(children: [
                locationDirection == LocationDirection.NONE ? TextSpan():  TextSpan(
                      text:  locationDirection == LocationDirection.FRO
                          ? "From \n"
                          : "To \n",
                      style: TextStyle(color: Colors.grey)),
                  TextSpan(
                      text: address,
                      style: TextStyle(fontSize: 15, color: color))
                ]),
              ),
            );
        },
        )
      ],
    );
  }
}
