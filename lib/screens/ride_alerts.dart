import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/margins.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/search_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/riders_available_widget.dart';
import 'package:mobi/screens/update_profile/harry.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/custom/modals.dart';
import 'package:mobi/widgets/home/planned_rides_wid.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RideAlertScreen extends StatefulWidget {
  final User user;

  const RideAlertScreen({Key key, @required this.user})
      : super(key: key);
  @override
  _RideAlertScreenState createState() => _RideAlertScreenState();
}

class _RideAlertScreenState extends State<RideAlertScreen>
    with AfterLayoutMixin<RideAlertScreen> {
  RidesViewModel _ridesViewModel;
  List<ScheduledRide> _rides;
  List<DateTime> dates;
  bool _loading = false;
  int _selectedDay = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);



  void _onLoading() async{
    print("refresh moving");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    dates = [];

    super.initState();
  }



  @override
  void afterFirstLayout(BuildContext context) {
    //fetchRides(widget.user);
  }

  void fetchRides(User user) {
    setState(() {
      _loading= true;
    });
    _ridesViewModel.fetchSearchRides2(user, fromLoc: _fromLocation,toLoc: _toLocation).then((rides) {
      setState(() {
        _rides = rides;
        _loading = false;
      });
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TheLocation _fromLocation;
  TheLocation _toLocation;
  UserModel _userModel;
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:
      Text("Available Rides "
          "${MyUtils.getReadableDate(
          DateTime.now())}",style: TextStyle(fontSize: 14),),),
      body:
            Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LocationWidget(
                  screenWidth: screenWidth,
                  tag: _fromLocation == null ? "" : _fromLocation.title,
                  title: "Start Location",
                  onPressed: () {
                    _onSLocationPressed("");
                  },
                  content:
                  _fromLocation != null ? _fromLocation.title : "Select start location",
                  direction: LocationDirection.FRO,
                ),
              ),
              YMargin(34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LocationWidget(
                  tag: _toLocation == null ? "" : _toLocation.title,
                  screenWidth: screenWidth,
                  title: "Destination",
                  onPressed: () {
                    _onELocationPressed("dest");
                  },
                  content: _toLocation != null ? _toLocation.title : "",
                  direction: LocationDirection.TO,
                ),
              ),
              YMargin(20),

              _loading == true
                  ? loadingWidget(): _rides?.isEmpty ?? true ? ridesEmptyWidget() :  Expanded(
                child: ListView.builder(itemBuilder: (BuildContext context, int index){
                        //return AvailableRideWidget(ride: _rides[index],);
                  return GestureDetector(
                    onTap: (){
                      print(";;;;;;;;;${_rides[index].userId}----- ${_userModel.user.phoneNumber}");
                      if(_rides[index].userId == _userModel.user.phoneNumber){
                        showModalBottomSheet<Null>(
                            context: context,
                            builder: (BuildContext context) {
                              return NotLoggedInModal(
                                login: () {
                                  Navigator.pop(context);
                                  //Navigator.pushReplacement(context, SignInScreen.route(scheduledRide:ride));
                                },
                                btnTitle: "Continue",
                                title: "You can't click on your own ride",
                                content:
                                "Try selecting other rides to proceed",
                              );
                            });
                      }
                    },
                    child: PlannedRideWidgetSecondary(
                      horizontalMargin: 20,
                      ride: _rides[index],
                      user: null,
                      bgColor: blueLight,
                    ),
                  );

                }, itemCount: _rides.length,),
              ),
            ],
          ),
    );
  }
  
  Widget loadingWidget(){
    return Container(child: Center(child: CircularProgressIndicator(),),);
  }

  Widget ridesEmptyWidget(){
    return Container(child: Center(child: Column(
      children: <Widget>[
        YMargin(40),
        SvgPicture.asset("assets/img/riding.svg", width: 70,),
        SizedBox(height: 30,),
        Text("No Rides alert set today, Search to see rides", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        YMargin(30),


      ],
    ),),);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text(value)));
  }
  Widget ridesWidget(){
    return Container(
      child: ListView.builder(itemBuilder: (BuildContext context, int index){
        //return AvailableRideWidget(ride: _rides[index],);
        return PlannedRideWidgetSecondary(
          horizontalMargin: 20,
          ride: _rides[index],
          user: null,
          bgColor: blueLight,
        );
      }, itemCount: _rides.length,),
    );
  }
  void _onSLocationPressed(String type) async {
    print("hh");
    print("friday");
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                const LocationSearchScreen(
                  direction: LocationDirection.FRO,
                  save: false,
                )));
    if (loc != null) {
      setState(() {
        _fromLocation = loc;
      });

      if(_toLocation != null){
        fetchRides(widget.user);
      }
    } else {}
  }

  void _onELocationPressed(String type) async {
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                const LocationSearchScreen(
                  direction: LocationDirection.TO,
                  save: false,
                )));
    if (loc != null) {
      setState(() {
        _toLocation = loc;
      });
      if(_fromLocation != null){
        fetchRides(widget.user);
      }
    } else {}
  }
}
class AvailableRideWidget extends StatelessWidget {
  const AvailableRideWidget({
    Key key,
    @required this.ride,
  }) : super(key: key);

  final SearchRide ride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

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
                    "NGN 0",
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
                                ride.date)),

                        SizedBox(width: 20,),
                        SvgPicture.asset("assets/img/calendar.svg", color: Colors.black,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(MyUtils.getReadableDateWithWords(ride.date),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),

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