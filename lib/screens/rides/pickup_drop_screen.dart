import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PickNDropScreen extends StatefulWidget {
  @override
  _PickNDropScreenState createState() => _PickNDropScreenState();
}

class _PickNDropScreenState extends State<PickNDropScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Select Saved Locations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){

            },
            child: Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20,),
                  SvgPicture.asset("assets/img/home.svg", height: 30,width: 30,color: Color(0XFF4D7CF2),),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text("Pickup point", style: TextStyle(color: Color(0XFF4D7CF2)),),
                      SizedBox(height: 5,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text("Click to select pickup point",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Spacer(),
                    ],),
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){

            },
            child: Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20,),
                  SvgPicture.asset("assets/img/briefcase.svg", height: 30,width: 30,color: Color(0XFFE3560C),),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text("Drop off point", style: TextStyle(color: Color(0XFFE3560C)),),
                      SizedBox(height: 5,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text("click to select drop off point",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Spacer(),
                    ],),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
