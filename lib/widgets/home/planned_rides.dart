import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/ride_started_screen.dart';
import 'package:mobi/screens/ride_details.dart';
import 'package:mobi/services/dialogs/dialog_service.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/home/choose_a_schedule.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:mobi/extras/utils.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class PlannedRidesWidget extends StatefulWidget {
  final List<ScheduledRide> rideList;

  const PlannedRidesWidget({Key key, this.rideList}) : super(key: key);
  @override
  _PlannedRidesWidgetState createState() => _PlannedRidesWidgetState();
}

class _PlannedRidesWidgetState extends State<PlannedRidesWidget>  with AfterLayoutMixin<PlannedRidesWidget>{
  PageController _controller;
  RidesViewModel _ridesViewModel;
  UserModel _userModel;
  List<ScheduledRide> _rideList;
  int _page = 0;
  final pageIndexNotifier = ValueNotifier<int>(0);
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.88);
    if(widget.rideList != null){
      _rideList = widget.rideList;
      print("i am first ${_rideList.first.ridersState}");
    }
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context)async {
    print("I was ddd");
    List<String> expiredRide = [];

       _rideList.forEach((ride){
        DateTime data = DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds);
        if(ride.dateinMilliseconds < DateTime.now().millisecondsSinceEpoch){

          expiredRide.add(ride.id);
        }
        if(ride.rideState == RideState.STARTED){
          setState(() {
            expiredRide = [];
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => RideStartedScreen(ride: ride,)),
                  (Route<dynamic> route) => false);
        }
      });

    await Future.delayed(Duration(seconds: 2));
    if(expiredRide.length > 0){
      //showDDialog();
    }
  }

  void showDDialog() async{
    var dialogResult = await _dialogService.showDialog();
    print("dialog flosed");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    _userModel = Provider.of<UserModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
          child: Text(
            "Your Planned rides".toUpperCase(),
            style: TextStyle(
                fontSize: MyUtils.fontSize(3), fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        _pageView(),
        PageViewIndicator(
          pageIndexNotifier: pageIndexNotifier,
          length:  _rideList.length > 5 ? 5 : _rideList.length,
          normalBuilder: (animationController, index) => Circle(
            size: 8.0,
            color: secondaryGrey,
          ),
          highlightedBuilder: (animationController, index) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
            child: Circle(
              size: 8.0,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _pageView() => Container(
        decoration: BoxDecoration(color: Colors.transparent),
        height: MyUtils.buildSizeHeight(22),
        child: PageView.builder(
          onPageChanged: (index) => pageIndexNotifier.value = index,
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RideDetailsScreen(ride:_rideList[index],)));
              },
              child: PlannedRideWidget(ride: _rideList[index], user: _userModel.user,),
            );
        },itemCount: _rideList.length > 5 ? 5 : _rideList.length,
        ),
      );

  
}


class PlannedRideWidget extends StatelessWidget {
  const PlannedRideWidget({
    Key key,
    @required ScheduledRide ride, this.bgColor, this.textColor, this.iconColor,@required this.user,
  }) : _ride = ride, super(key: key);

  final ScheduledRide _ride;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final User user;

  @override
  Widget build(BuildContext context) {
    print(" kklolol w${_ride.ridersState}");
    var LocationTextStyle = TextStyle(fontSize: 14, color: textColor ?? Colors.black);
    return Card(
      elevation: 3,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: bgColor ?? Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 220,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MyUtils.buildSizeWidth(2),
                    height: MyUtils.buildSizeWidth(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.pink),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: MyUtils.buildSizeWidth(65),
                    child: Text(
                        MyUtils.getShortenedLocation(_ride.fromLocation.title, 60),
                        style: LocationTextStyle),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MyUtils.buildSizeWidth(2),
                    height: MyUtils.buildSizeWidth(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                      width: MyUtils.buildSizeWidth(65),
                      child: Text(
                        MyUtils.getShortenedLocation(_ride.toLocation.title, 60),
                        style: LocationTextStyle,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/img/clock.svg", color: iconColor ?? Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text(MyUtils.getReadableTime(DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds)),style: LocationTextStyle,)
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/img/calendar.svg", color: iconColor ?? Colors.black,),
                      SizedBox(
                        width: 10,
                      ),
                      Text(MyUtils.getReadableDateWithWords(DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds)), style: LocationTextStyle,)
                    ],
                  ),
                  Spacer(),
        (_ride.ridersRequest != null && _ride.userId == user.phoneNumber) ? _ride.ridersRequest.length > 0 ? Row(children: <Widget>[
                    Icon(Icons.notifications_active, color: primaryColor,),
                    SizedBox(width: 5,),
                    Text("${_ride.ridersRequest.length}")
                  ],):Container():Container(),
          _ride.dateinMilliseconds < DateTime.now().millisecondsSinceEpoch ? Row(children: <Widget>[
            Text("Ride Due", style: TextStyle(color: Colors.redAccent),)
          ],):Container()

                ],
              )

            ],
          )),
    );
  }
}