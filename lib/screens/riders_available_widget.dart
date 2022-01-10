import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/screens/ride_request.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:provider/provider.dart';

class RidersAvailableWidget extends StatelessWidget {
  const RidersAvailableWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RidesViewModel _ridesViewModel = Provider.of<RidesViewModel>(context);
    return Container(
      height: _ridesViewModel.nearbyCommuttersState == ModelState.LOADING
          ? 250
          : 250,
      width: size.width,
      child: Row(
        children: <Widget>[
          _ridesViewModel.nearbyRidersState == ModelState.LOADING
              ? Container(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                  ),
                )
              : Container(
                  height: 220,
                  width: size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _ridesViewModel.nearbyRides.length,
                    itemBuilder: (BuildContext context, int index) {
                      ScheduledRide ride = _ridesViewModel.nearbyRides[index];
                      return new AvailableRideWidget(ride: ride);
                    },
                  ),
                )
        ],
      ),
    );
  }
}

class AvailableRideWidget extends StatelessWidget {
  const AvailableRideWidget({
    Key key,
    @required this.ride,
  }) : super(key: key);

  final ScheduledRide ride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RideRequestScreen(
                      ride: ride,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
        child: Container(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: MyUtils.buildSizeHeight(25),
          width: MyUtils.buildSizeWidth(40),
          color: primaryColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  ClipOval(
                    clipper: CircleClipper(),
                    child: CachedNetworkImage(
                      imageUrl: ride.userProfilePix,
                      height: MyUtils.buildSizeWidth(10),
                      fit: BoxFit.cover,
                      width: MyUtils.buildSizeWidth(10),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ride.userName,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "4.2 stars",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "NGN ${ride.price}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blueAccent),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                      width: MyUtils.buildSizeWidth(70),
                      child: Text(MyUtils.getShortenedLocation(ride.fromLocation.title, 60))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.redAccent),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                      width: MyUtils.buildSizeWidth(70),
                      child: Text(MyUtils.getShortenedLocation(ride.toLocation.title, 60))),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset("assets/img/clock.png"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(MyUtils.getReadableTime(
                            DateTime.fromMillisecondsSinceEpoch(
                                ride.dateinMilliseconds))),

                        SizedBox(width: 20,),
                        SvgPicture.asset("assets/img/calendar.svg", color: Colors.black,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(MyUtils.getReadableDateWithWords(DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds)),
                          )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset(ride.driveOrRide == DriveOrRide.DRIVE
                        ? "assets/img/sports-car.png"
                        : "assets/img/pedestrian-walking.png"),
                  ],
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
