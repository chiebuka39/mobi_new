import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/margins.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/riders_available_widget.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AvailableRidesScreen extends StatefulWidget {
  final ScheduledRide scheduledRide;

  const AvailableRidesScreen({Key key, @required this.scheduledRide})
      : super(key: key);
  @override
  _AvailableRidesScreenState createState() => _AvailableRidesScreenState();
}

class _AvailableRidesScreenState extends State<AvailableRidesScreen>
    with AfterLayoutMixin<AvailableRidesScreen> {
  RidesViewModel _ridesViewModel;
  List<ScheduledRide> _rides;
  List<DateTime> dates;
  bool _loading = true;
  int _selectedDay = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    print("refresh loading");
    //await Future.delayed(Duration(milliseconds: 1000));
    _ridesViewModel.fetchAvailableRides(widget.scheduledRide).then((rides) {
      _refreshController.refreshCompleted();
      setState(() {

        _rides = rides;
      });
    });
    // if failed,use refreshFailed()

  }

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
    for(int i=1; i<=7; i++){
      dates.add(DateTime
          .fromMillisecondsSinceEpoch(
          widget.scheduledRide.dateinMilliseconds)
          .add(Duration(days: i)));
    }
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    fetchRides(widget.scheduledRide);
  }

  void fetchRides(ScheduledRide ride) {
    _ridesViewModel.fetchAvailableRides(ride).then((rides) {
      setState(() {
        _rides = rides;
        _loading = false;
      });
    });
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:
      Text("Available Rides "
          "${MyUtils.getReadableDate(
          DateTime.fromMillisecondsSinceEpoch(widget.scheduledRide.dateinMilliseconds))}",style: TextStyle(fontSize: 14),),),
      body: _loading == true
          ? loadingWidget()
          : _rides.length == 0 ? ridesEmptyWidget() : Column(
            children: <Widget>[

              Expanded(
                child: SmartRefresher(
        enablePullDown: true, controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(itemBuilder: (BuildContext context, int index){
                return AvailableRideWidget(ride: _rides[index],);
        }, itemCount: _rides.length,),
      ),
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
        Spacer(),
        SvgPicture.asset("assets/img/riding.svg", width: 70,),
        SizedBox(height: 30,),
        Text("No Rides available yet", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        YMargin(30),
        SecondaryButton(title: 'Create a ride alert', handleClick: () async{
          var result =
              await _ridesViewModel.createSearchRide(widget.scheduledRide);
          if (result.error == false) {

            showDialog(
                context: context,
                barrierDismissible: false,
                builder:(c){
                  return AlertDialog(
                    title: Text("Success"),
                    content: Text(
                      "You have created a ride alert successfully",
                      style: TextStyle(fontSize: 17),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Continue",
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeTabs()),
                                  (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  );
                } );
          } else {

            showInSnackBar("An error occured");
          }
        },

        ),
        Spacer()
      ],
    ),),);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text(value)));
  }
  Widget ridesWidget(){
    return Container(
      child: ListView.builder(itemBuilder: (BuildContext context, int index){
        return AvailableRideWidget(ride: _rides[index],);
      }, itemCount: _rides.length,),
    );
  }
}
