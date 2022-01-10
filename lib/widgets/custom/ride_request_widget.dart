import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:mobi/widgets/set_up_profile/profile_details_widget.dart';

class RideRequestWidget extends StatelessWidget {
  const RideRequestWidget({
    Key key,
    @required this.ride,
    @required this.size, this.user, this.handleFunctionPressed, this.loading, this.buttonTitle,
  }) : super(key: key);

  final ScheduledRide ride;
  final Size size;
  final User user;
  final Function handleFunctionPressed;
  final bool loading;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            CircularProfileAvatar(
              ride.userProfilePix,
              radius: 44,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ride.userName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18)),
                    Text(
                      "14 total rides",
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context){
                      return BottomSheet(user: user);
                    });
                  },
                  child: Row(children: <Widget>[
                    SvgPicture.asset("assets/img/shield_1.svg"),
                    SizedBox(width: 10,),
                    SizedBox(
                        width: 130,
                        child: Text("Click to view security ratings"))
                  ],),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Widgets.rowOfSourceNdDest(
                size, ride.fromLocation,ride.toLocation),
            SizedBox(
              height: 30,
            ),
            FormSelector(
              showTopBorder: true,
              value: MyUtils.getReadableDate(DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds)),
              title: "Date",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: MyUtils.getReadableTime(DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds)),
              title: "Time",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: ride.price.toString(),
              title: "Ride Cost",
              desc: "Click to pick a date",
            ),
            FormSelector(
              showTopBorder: false,
              value: ((ride.seatsAvailable - ride.riders.length) + 1).toString(),
              title: "Seate Available",
              desc: "Click to pick a date",
            ),
            SizedBox(
              height: 20,
            ),
            SecondaryButton(
              loading: loading,
              width: double.infinity,
              title: buttonTitle,
              handleClick: handleFunctionPressed,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Security ratings"),
            ),
            SizedBox(height: 20,),
            if(user.workIdentityUrl.isNotEmpty)
            ProfileDetailsWidget(title: "Work Id Verified",),
            if(user.accounts.twitter.isNotEmpty)
              ProfileDetailsWidget(title: "Twitter URL added",isUrl: true,url: user.accounts.twitter,),
            if(user.accounts.fb.isNotEmpty)
              ProfileDetailsWidget(title: "Facebook URL added",isUrl: true,url: user.accounts.fb),
            if(user.accounts.instagram.isNotEmpty)
              ProfileDetailsWidget(title: "Instagram URL added",isUrl: true,url: user.accounts.instagram),
            if(user.accounts.linkedIn.isNotEmpty)
              ProfileDetailsWidget(title: "Linkedin URL added",isUrl: true,url: user.accounts.linkedIn),
            if(user.carDetails.licenseImageUrl.isNotEmpty)
              ProfileDetailsWidget(title: "Drivers License is added",),

          ],),
      ),
    );
  }
}