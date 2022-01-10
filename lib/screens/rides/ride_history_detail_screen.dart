import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/rides/ratings_screen.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

class RideHistoryDetailScreen extends StatefulWidget {
  final ScheduledRide ride;

  const RideHistoryDetailScreen({Key key, this.ride}) : super(key: key);
  @override
  _RideHistoryDetailScreenState createState() =>
      _RideHistoryDetailScreenState();
}

class _RideHistoryDetailScreenState extends State<RideHistoryDetailScreen> with
    AfterLayoutMixin<RideHistoryDetailScreen> {

  ScheduledRide _ride;
  List<User> _riders;
  bool _loading = true;
  bool _error = false;
  DateTime _date;

  //View Models
  UserModel _userModel;


  @override
  void initState() {
    _ride = widget.ride;
    _date = DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds );
    print("ddjjd ${_ride.dateinMilliseconds}");
    //print("ddjjd ${_date.toIso8601String()}");
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    if(_ride.riders.length > 0){
      try{
        var users = await _userModel.getAllUsers(_ride.riders);
        if(users.length > 0){
          setState(() {
            _loading = false;
            _riders = users;
          });
        }else{
          _loading = false;
        }
      }catch(e){
        setState(() {
          _error = true;
        });
      }

    }

  }
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print("height : $screenHeight");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Ride Detail", style: TextStyle(color: Colors.black),),
      ),
      body: _loading == true ?
      Container(child: Center(child: CircularProgressIndicator(),),) :
      _error == true ?  Container(child: Center(child: Text("An error has occured"),),): SingleChildScrollView(
        child: Column(
          children: <Widget>[
              SizedBox(height: 34,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LocationWidget(
                  screenWidth: screenWidth,
                  title: "From",
                  content: _ride.fromLocation.title,
                  direction: LocationDirection.FRO,
                ),
              ),
            SizedBox(height: 34,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LocationWidget(
                screenWidth: screenWidth,
                title: "Destination",
                content: _ride.toLocation.title,
                direction: LocationDirection.TO,
              ),
            ),
            SizedBox(height: 20,),
            Row(children: <Widget>[
              SizedBox(width: 20,),
              Text("Riders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],),
            SizedBox(height: 20,),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        clipper: CircleClipper(),
                        child: CachedNetworkImage(
                          imageUrl: _riders[index].avatar,
                          height:
                          MyUtils.buildSizeWidth(20),
                          fit: BoxFit.cover,
                          width:
                          MyUtils.buildSizeWidth(20),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(_riders[index].fullName.split(" ").first)
                    ],
                  ),
                );
              }, itemCount: _riders.length,),
            ),

            SizedBox(height: 20,),

            FormSelector(title: "Date",
              value: MyUtils.getReadableDate(_date),
              desc: "",onPressed: null,showTopBorder: true,),

            SizedBox(height: 20,),

            FormSelector(
                value: MyUtils.toTimeString(TimeOfDay.fromDateTime(_date)),
                //value: MyUtils.getReadableTime(DateTime.fromMicrosecondsSinceEpoch(  widget.ride.dateinMilliseconds)),
                desc: "",title:"Time",
                onPressed: null),
            SizedBox(height: 30,),
            screenHeight < 700 ? SizedBox(height: 100,): SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryButton(handleClick: (){
                showDialog(context: context,
                    builder:(c){
                  return AlertDialog(
                    title: Text("ReSchedule"),
                    content: Text("You are about to reschedule this trip"),
                    actions: <Widget>[
                      FlatButton(child: Text("Cancel"),onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                      },),
                      FlatButton(child: Text("Reschedule"),onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleRideDriver(fromLocation: _ride.fromLocation,
                          toLocation: _ride.toLocation,
                          canEdit: false,
                          ride: _ride,
                        )));
                      },)
                    ],
                  );
                    });

              }, title: "reschedule".toUpperCase(),width: double.infinity,),
            )
          ],
        ),
      ),
    );
  }
}
