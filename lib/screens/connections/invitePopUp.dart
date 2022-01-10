import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvitePopUp extends StatefulWidget {
  @override
  _InvitePopUpState createState() => _InvitePopUpState();
}

class _InvitePopUpState extends State<InvitePopUp> {
  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Column(children: <Widget>[
        SizedBox(height: 50,),
        SvgPicture.asset("assets/img/confetti.svg", height: 60,),
        SizedBox(height: 30,),
        Row(
          children: <Widget>[
            SizedBox(width: 10,),
            SvgPicture.asset("assets/img/jeep.svg", height: 30,),
            SizedBox(width: 10,),
            SizedBox(
              width: 250,
                child: Text("Send an invite to a car owner and both of you get NGN500 on his first ride",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)),
          ],
        ),
        SizedBox(height: 30,),
        Row(
          children: <Widget>[
            SizedBox(width: 10,),
            SvgPicture.asset("assets/img/pilot.svg", height: 30,),
            SizedBox(width: 10,),
            SizedBox(
              width: 250,
                child: Text("Send an invite to a rider and both of you get NGN200 on his first ride",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)),
          ],
        )
      ],),
    ));
  }
}
