import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/widgets/primary_button.dart';

class RatingsScreen extends StatefulWidget {
  @override
  _RatingsScreenState createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _buildRatingsWidget(),
    );
  }

  Column _buildReasons() {
    return Column(children: <Widget>[
      Text("You rated the carpool",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      RatingBar.builder(
        initialRating: 0,
        onRatingUpdate: (double value) {  },
        minRating: 1,
        itemSize: 30,
        direction: Axis.horizontal,
        allowHalfRating: true,
        unratedColor: Colors.grey,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
      ),
      SizedBox(height: 20,),
      Container(
        padding: EdgeInsets.only(left:30),
        height: 90,
        color: secondaryGrey,
        child: Row(children: <Widget>[
          SvgPicture.asset("assets/img/cookie.svg"),
          SizedBox(width: 20,),
          Text("Ride Arrived late", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
        ],),
      )
    ],);
  }

  Widget _buildRatingsWidget() {
    return Center(
      child: Column(children: <Widget>[
        Spacer(),
        Text("How waw the carpool?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
        RatingBar.builder(
          initialRating: 0,
          onRatingUpdate: (double value) {  },
          minRating: 1,
          itemSize: 45,
          direction: Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.grey,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SecondaryButton(
            title: "Submit",
            width: double.infinity,
            handleClick: (){

          },),
        ),
        SizedBox(height: 20,)
      ],),
    );
  }
}
