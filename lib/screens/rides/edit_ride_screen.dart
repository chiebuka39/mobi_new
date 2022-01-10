import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/rides/ratings_screen.dart';
import 'package:mobi/screens/rides/schedule_ride_driver.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

class EditRideScreen extends StatefulWidget {
  final ScheduledRide ride;

  const EditRideScreen({Key key, this.ride}) : super(key: key);
  @override
  _EditRideScreenState createState() =>
      _EditRideScreenState();
}

class _EditRideScreenState extends State<EditRideScreen> with
    AfterLayoutMixin<EditRideScreen> {

  ScheduledRide _ride;
  List<User> _riders;
  bool _loading = true;
  bool _saveLoading = false;
  bool _error = false;
  String _date;
  DateTime _date1;
  String _time;
  TimeOfDay _time1;

  //View Models
  UserModel _userModel;
  RidesViewModel _ridesViewModel;


  @override
  void initState() {
    _ride = widget.ride;
    _date1 = DateTime.fromMillisecondsSinceEpoch(_ride.dateinMilliseconds );
    print("ddjjd ${_ride.dateinMilliseconds}");
    _time1 = TimeOfDay.fromDateTime(_date1);
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
    _ridesViewModel = Provider.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print("height : $screenHeight");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Edit Ride", style: TextStyle(color: Colors.black),),
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

            FormSelector(
              showTopBorder: true,
              value: MyUtils.getReadableDate(_date1),
              title: "Date",
              desc: "Click to pick a date",
              onPressed: () async {
                DateTime result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(hours: 5)),
                    firstDate:
                    DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)));
                if (result != null) {
                  setState(() {
                    _date = MyUtils.getReadableDate(result);
                    _date1 = result;
                  });
                }
              },
            ),
            FormSelector(
              value: MyUtils.toTimeString(_time1),
              title: "Time",
              desc: "Click to pick a time",
              onPressed: () async {
                TimeOfDay result = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (result != null) {
                  setState(() {
                    _time = MyUtils.toTimeString(result);
                    _time1 = result;
                  });
                }
              },
            ),
            SizedBox(height: 30,),
            screenHeight < 700 ? SizedBox(height: 100,): SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryButton(handleClick: (){
                showDialog(context: context,
                    builder:(c){
                  return AlertDialog(
                    title: Text("Edit Ride"),
                    content: Text("You are about to Edit this trip"),
                    actions: <Widget>[
                      FlatButton(child: Text("Cancel"),onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                      },),
                      FlatButton(child: Text("Continue"),onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                        updateRideTime();
                      },)
                    ],
                  );
                    });

              }, title: "Save Edit".toUpperCase(),width: double.infinity,loading: _saveLoading,),
            )
          ],
        ),
      ),
    );
  }

  updateRideTime() async{
    setState(() {
      _saveLoading = true;
    });
    DateTime editedTime = DateTime(_date1.year, _date1.month, _date1.day,
        _time1.hour, _time1.minute);
    var result = await _ridesViewModel.updateRide(widget.ride.userId, widget.ride.id, editedTime);
    setState(() {
      _saveLoading = false;
    });
    if(result.error == false){
      showSimpleNotification(Text("Edit Ride Successful"),background: Colors.green);
      Future.delayed(Duration(seconds: 2)).then((value) => Navigator.pop(context,editedTime));
    }else{
      showSimpleNotification(Text("Edit Ride could not be completed"),background: Colors.red);
    }
  }
}
