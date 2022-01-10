import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/schedule.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/profile/user_profile.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ViewDailyRideDetails extends StatefulWidget {
  final Schedule schedule;

  const ViewDailyRideDetails({Key key,@required this.schedule}) : super(key: key);
  @override
  _ViewDailyRideDetailsState createState() => _ViewDailyRideDetailsState();
}

class _ViewDailyRideDetailsState extends State<ViewDailyRideDetails>  with
    AfterLayoutMixin<ViewDailyRideDetails>{
  RidesViewModel _ridesViewModel;
  UserModel _userModel;
  Schedule schedule;
  ScheduledRide _ride;
  List<User> _users = [];
  DriveOrRide _driveOrRide;

  @override
  void initState() {
    
    if(widget.schedule != null){
      schedule = widget.schedule;
    }
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    var num = DateTime(schedule.time.year,
        schedule.time.month,schedule.time.day, 
        _userModel.user.leaveForWork.hour, 
        _userModel.user.leaveForWork.minute).millisecondsSinceEpoch;
    List<ScheduledRide> rides =
        _ridesViewModel.scheduledRideList.where((ride) => ride.dateinMilliseconds == num).toList();

    fetchRidersWithSameRoute(rides);
    var t =_userModel.user.drivingState == DrivingState.Drives;
  }


  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of(context);
    _userModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          HeaderWidget(schedule: schedule,),
          _users.length == 0 ?EmptyWidget():UserGridWidget(users: _users,schedule: schedule,)
        ],
      ),
    );
  }
  void fetchRidersWithSameRoute(List<ScheduledRide> rides) {
    _ridesViewModel.getRidersWithSameRoute(
        fromLocation: _userModel.user.homeLocation,
        toLocation: _userModel.user.workLocation,
        time: DateTime.now()
    ).then((users) {
      print("harryryrr ${users.length}");
//      print("harryryrr ${users.first.fullName}");
      setState(() {

        _users = users;
        if(rides.length > 0){
          _ride = rides.first;
        }
      });
    });
  }

}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          SizedBox(height: (MediaQuery.of(context).size.height/8),),
          SvgPicture.asset("assets/img/empty.svg"),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 220,
            child: Text(
              MyStrings.noOne,
              style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 250,
            child: Text(
              MyStrings.help,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20,),
          ButtonTheme(
            minWidth: 250,
            height: 50,
            buttonColor: primaryColor,
            child: RaisedButton(
              child: Text("Invite Friends", style: TextStyle(color: Colors.white),),
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final Schedule schedule;
  const HeaderWidget({
    Key key, this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of(context);
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${MyStrings.intToStringDayOfWeek[schedule.time.weekday]}, 07:30 AM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text("Home"),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(Icons.arrow_forward),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Work"),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            userModel.user.drivingState == DrivingState.Drives ?"Driving":"Riding",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              SvgPicture.asset("assets/img/share1.svg")
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          height: 69,
          child: ListView.builder(itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UserProfileScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Stack(
                  children: <Widget>[
                    Material(
                      elevation: 3,
                      shape: CircleBorder(),
                      child: ClipOval(
                        clipper: CircleClipper(),
                        child: CachedNetworkImage(
                          imageUrl: userModel.user.avatar,
                          width: 69,
                          height: 69,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.timelapse,size: 10,color: Colors.white,),),
                      ),
                    )

                  ],
                ),
              ),
            );
          },
            itemCount: 5,
            scrollDirection: Axis.horizontal,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Drivers On your route",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ]),
    );
  }
}

class UserGridWidget extends StatelessWidget {
  final List<User> users;
  final Schedule schedule;
  const UserGridWidget({
    Key key, this.users, this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: .85),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            )),
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  )),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:
                        users.first.avatar,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  users.first.fullName.split(" ").first,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                      size: 13,
                      color: Colors.orange,
                      rating: 4,
                      borderColor: Colors.orange,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "20 Rides",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Software Developer",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        );
      }, childCount: 4),
    );
  }
}
// Check if driving or rieing
// if driving, fetch all commuters with same route
// Check if there is any request received or any invite sent out
// show a list of all with different indicators
