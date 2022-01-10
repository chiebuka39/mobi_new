import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/app_config.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/dimens.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/bar_item.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/riders_available_widget.dart';
import 'package:mobi/screens/schedule_ride.dart';
import 'package:mobi/screens/set_locations.dart';
import 'package:mobi/screens/view_profile_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/animated_bottom_bar.dart';
import 'package:mobi/widgets/location_title_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  DateTime _today = DateTime.now();
  bool built = false;
  bool built_ = false;


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);

    pprint("${AppConfig.blockSize} app config 2");


    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(size),
    );
  }


  SingleChildScrollView buildBody(Size size) {

    if (_ridesViewModel.scheduledRide != null) {
      if (built_ == false) {
        _ridesViewModel.fetchNearbyScheduledRides(_userModel.user);
        pprint("harry");
        built_ = true;
      }
      return buildscheduledTrip(size, _ridesViewModel.scheduledRide);
    } else if (_userModel.user.homeLocation.title != null) {
      if (built == false) {
        _ridesViewModel.fetchNearByCommutters(_userModel.user);
        built = true;
      }
      return buildSingleChildScrollViewForAlreadySetLocations(size);
    } else {
      return buildSingleChildScrollViewForNoRidesRequestedYet(size);
    }
  }


  SingleChildScrollView buildSingleChildScrollViewForAlreadySetLocations(
      Size size) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Welcome ${_userModel.user.fullName.split(" ").first}",
                  style: mainTitle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 300,
                width: size.width - 60,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "8:00 am",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      MyUtils.getReadableDate(_today),
                      style: TextStyle(color: Color(0xFFDDDDDD), fontSize: 17),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    new LocationTitleWidget(
                      address: _userModel.user.homeLocation.title,
                      size: size,
                      locationDirection: LocationDirection.FRO,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    new LocationTitleWidget(
                      address: _userModel.user.workLocation.title,
                      size: size,
                      locationDirection: LocationDirection.TO,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        FlatButton(
                          child: Text(
                            'Edit Schedule',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScheduleRideScreen()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {
//                              _ridesViewModel
//                                  .getNearByCommutters(_userModel.user);
                            },
                            child: Text('Create Schedule'),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 30),
            child: Row(
              children: <Widget>[
                Text("Commuters Around you",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5),
            child: SizedBox(
              height:
              _ridesViewModel.nearbyCommuttersState == ModelState.LOADING
                  ? 50
                  : 200,
              child: _ridesViewModel.nearbyCommuttersState == ModelState.LOADING
                  ? Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                ),
              )
                  : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _ridesViewModel.nearbyCommutters.length,
                  itemBuilder: (context, i) {
                    User comutter = _ridesViewModel.nearbyCommutters[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewProfileScreen(
                                  user: comutter,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height:100,
                              width: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Hero(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: comutter.avatar,
                                  ), tag: "${comutter.fullName}",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                    width: 15,
                                    child: Image.asset(
                                        "assets/img/sports-car.png")),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    "${MyUtils.getFirstWordInASentence(comutter.homeLocation.title)} to ${MyUtils.getFirstWordInASentence(comutter.workLocation.title)}")
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollViewForNoRidesRequestedYet(
      Size size) {
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "Welcome ${_userModel.user.fullName.split(" ").first}",
                    style: mainTitle,
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 1,
            ),
            Center(child: Image.asset('assets/img/mobile.png')),
            SizedBox(
              height: 70,
            ),
            Text(
              'Add favorite loactions',
              style: secondaryTitle,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                SizedBox(
                    width: 300,
                    child: Text(
                      'You would need to set your favorite locations to see other commutters around you',
                      textAlign: TextAlign.center,
                    )),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            new PrimaryButton(
              title: "Add Locations",
              handleClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetLocationsScreen()));
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildscheduledTrip(Size size, ScheduledRide ride) {
    DateTime date =
    DateTime.fromMillisecondsSinceEpoch(ride.dateinMilliseconds);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(date);
    pprint(ride.driveOrRide);


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: AppConfig.height / 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: AppConfig.blockSize * 6),
                child: Text(
                  "Welcome ${_userModel.user.fullName.split(" ").first}",
                  style: mainTitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("You have a Ride Scheduled"),
              )
            ],
          ),

          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Widgets.rowOfSourceNdDest(
                size, ride.fromLocation, ride.toLocation),
          ),
          SizedBox(
            height: 30,
          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 45),
//            child: Row(
//              children: <Widget>[
//                CircleAvatar(
//                  backgroundImage: AssetImage("assets/img/ebuka.png"),
//                  radius: 18,
//                ),
//                SizedBox(
//                  width: 10,
//                ),
//                CircleAvatar(
//                  backgroundImage: AssetImage("assets/img/ebuka.png"),
//                  radius: 18,
//                ),
//                SizedBox(
//                  width: 10,
//                ),
//                CircleAvatar(
//                  backgroundImage: AssetImage("assets/img/ebuka.png"),
//                  radius: 18,
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 30,
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: Dimens.timeAndDateContainerHeightSecondary,
                width: Dimens.timeAndDateContainerWidth,
                decoration: BoxDecoration(
                    color: timeAndDateContainerColorSecondary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontSize: fontSize(6.5),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      MyStrings.intToStringDayOfWeek[date.month],
                      style: TextStyle(color: Colors.white, fontSize: fontSize(3.5)),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: Dimens.timeAndDateContainerHeightSecondary,
                width: Dimens.timeAndDateContainerWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: timeAndDateContainerColorSecondary),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      "${timeOfDay.hourOfPeriod}:${timeOfDay.minute}",
                      style: TextStyle(
                          fontSize: fontSize(6.5),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      timeOfDay.period == DayPeriod.am ? "am" : "pm",
                      style: TextStyle(color: Colors.white, fontSize: fontSize(3.5)),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Requested Rides",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Text(
                  "More",
                  style: TextStyle(color: Colors.redAccent),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              new RidersAvailableWidget(),
            ],
          )
        ],
      ),
    );
  }

  double fontSize(double size) => AppConfig.blockSize * size;


}

