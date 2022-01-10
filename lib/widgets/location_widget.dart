import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';

class LocationWidget extends StatelessWidget {
  final String title;
  final String content;
  final String tag;
  final LocationDirection direction;
  final Function onPressed;
  const LocationWidget({
    Key key,
    @required this.screenWidth, this.title, this.content, this.direction, this.onPressed,
    this.tag = "",
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        child: Row(children: <Widget>[
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: direction== LocationDirection.FRO ?   Colors.greenAccent:Colors.redAccent,
                shape: BoxShape.circle
            ),
          ),
          SizedBox(width: 24,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 12),),
              SizedBox(height: 7,),
              SizedBox(
                  width: screenWidth /1.5,
                  child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: content, style: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.w500),),
                      TextSpan(text: tag.isEmpty ? "":"   ($tag)", style: TextStyle(fontSize: 12),)
                    ]
                  )))
            ],)
        ],),
      ),
    );
  }
}


