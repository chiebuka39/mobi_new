import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class RideRatingsScreen extends StatefulWidget {
  final ScheduledRide ride;

  const RideRatingsScreen({Key key, this.ride}) : super(key: key);
  @override
  _RideRatingsScreenState createState() => _RideRatingsScreenState();
}

class _RideRatingsScreenState extends State<RideRatingsScreen> with AfterLayoutMixin<RideRatingsScreen> {
  RidesViewModel _ridesViewModel;
  UserModel _userModel;
  ProgressDialog pr;

  @override
  void afterFirstLayout(BuildContext context) {
    print("jjj ${widget.ride.ratings.toFireStore()}");
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
  }

  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of(context);
    _userModel = Provider.of(context);


    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(child: Text("Skip", style: TextStyle(),), onPressed: (){
                    MyUtils.pushToHome(context);
                },),
                SizedBox(width: 10,)
              ],
            ),
            SizedBox(height: 70,),
          Center(
            child: SizedBox(
              width:270 ,
                child: Text("Your Trip just Concluded,"
                    "how do you feel about it?",
                  style: TextStyle(
                      fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),textAlign: TextAlign.center,)),
          ),
            SizedBox(height: 50,),
            RatingItemWidget(bgColor: loveColor,
              title: "Loved the trip",icon: "in-love",onPressed: (){
                handleRatingPresses(() => _ridesViewModel.submitRideRatings(
                    widget.ride.ratings..add(_userModel.user.phoneNumber, 4.0),
                    widget.ride));
              },),
            RatingItemWidget(bgColor: okayColor,
              title: "Trip was okay",icon: "smile",onPressed: (){
                handleRatingPresses(() => _ridesViewModel.submitRideRatings(
                    widget.ride.ratings..add(_userModel.user.phoneNumber, 3.0),
                    widget.ride));
              },),
            RatingItemWidget(bgColor: notSatisfiedColor,
              title: "Not satisfied",icon: "neutral",onPressed: (){
                handleRatingPresses(() => _ridesViewModel.submitRideRatings(
                    widget.ride.ratings..add(_userModel.user.phoneNumber, 2.0),
                    widget.ride));
              },),
            RatingItemWidget(bgColor: wrongTripColor,
              title: "Everything went wrong",icon: "sad1",onPressed: (){
                handleRatingPresses(() => _ridesViewModel.submitRideRatings(
                    widget.ride.ratings..add(_userModel.user.phoneNumber, 1.0),
                    widget.ride));
              },)
        ],),
      ),
    );
  }

  handleRatingPresses(Function sendRatings) async{
    pr.style(message: "");
    pr.show();
    var result = await sendRatings();
    print("pppfff");
    pr.hide();
    if(result.error == false){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MessageHandler(
                child: HomeTabs(),
              )),
              (Route<dynamic> route) => false);
    }else{
      showSimpleNotification(Text("An error, occured, please try again"), background: Colors.red);
    }
  }

  Future<Result<void>> hh() => _ridesViewModel.submitRideRatings(
        widget.ride.ratings.add(_userModel.user.phoneNumber, 4.0),
        widget.ride);


}

class RatingItemWidget extends StatelessWidget {
  const RatingItemWidget({
    Key key, this.bgColor, this.icon, this.title, this.onPressed,
  }) : super(key: key);

  final Color bgColor;
  final String icon;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        width: double.infinity,
        height: 73,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(children: <Widget>[
          SvgPicture.asset("assets/img/$icon.svg", height: 27,width: 27,),
          SizedBox(width: 20,),
          Text(title, style:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
        ],),
      ),
    );
  }
}
