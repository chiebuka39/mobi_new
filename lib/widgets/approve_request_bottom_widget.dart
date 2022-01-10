import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class SendRequestBottomWidget extends StatelessWidget {
  final ScheduledRide ride;
  final Function handleSubmitted;
  final bool loading;
  const SendRequestBottomWidget({
    Key key,
    @required this.size, this.ride, this.handleSubmitted, this.loading,
  }) : super(key: key);

  final Size size;

  int getSeatsAvailable(List<String> riders, int availableSeats){
    print("llll ${riders.length} -- $availableSeats");
    if(availableSeats != null){
      return availableSeats - (riders.length -1);
    }
    return 1 - (riders.length - 1);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: size.height / 7,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: Row(
        children: <Widget>[
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Text(
                "Number of seats Available",
                style: TextStyle(
                    color: secondaryTitleColor, fontSize: MyUtils.fontSize(4)),
              ),
              Text(
                "${getSeatsAvailable(ride.riders, ride.seatsAvailable)} Seats",
                style: TextStyle(
                    color: white,
                    fontSize: MyUtils.fontSize(5),
                    fontWeight: FontWeight.w700),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          getSeatsAvailable(ride.riders, ride.seatsAvailable) < 1 ? Text("Ride is fully Booked") :FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            child: loading == true ? SizedBox(height:15,width:15,child:CircularProgressIndicator()): Text("Send Request"),
            onPressed:handleSubmitted,
          ),
          Spacer()
        ],
      ),
    );
  }
}
