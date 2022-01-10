import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/rides/multiple/confirm_locations.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
 
import 'package:provider/provider.dart';

class ChooseDaysScreen extends StatefulWidget {
  @override
  _ChooseDaysScreenState createState() => _ChooseDaysScreenState();
}

class _ChooseDaysScreenState extends State<ChooseDaysScreen>
    with AfterLayoutMixin<ChooseDaysScreen> {
  List<DateTime> selectableDates = [];
  List<bool> selected = [false, false, false, false, false, false, false];
  RidesViewModel _ridesViewModel;
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    DateTime time;
    if (_ridesViewModel.scheduledRideList.length > 0) {
      print("iiiiiii length ${_ridesViewModel.scheduledRideList.length}");
      _ridesViewModel.scheduledRideList.forEach((ride){
        print("ooooo ${ride.id}");
      });
      time = DateTime.fromMillisecondsSinceEpoch(
          _ridesViewModel.scheduledRideList.last.dateinMilliseconds);
    } else {
      print("iiiiiii lenght is empty ${_ridesViewModel.scheduledRideList.length}");
      time = DateTime.now();
    }
    for (int i = 1; i <= 7; i++) {
      selectableDates.add(time.add(Duration(days: i)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _ridesViewModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: selectableDates.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      "Select days for next week work commute",
                      style: rideTitle,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ActionSelectableWidget(date: selectableDates[6], onPressed: (){
                        setState(() {
                          for(int i = 0; i < 7; i++){
                            if(selectableDates[i].weekday != 6 && selectableDates[i].weekday != 7 ){
                              selected[i] = true;
                            }
                          }
                        });
                      },),
                      DateSelectableWidget(
                        date: selectableDates[0],
                        onPressed: selectableDates[0].weekday == 6
                            || selectableDates[0].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }: () {
                          setState(() {
                            selected[0] = !selected[0];
                          });
                        },
                        selected: selected[0],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DateSelectableWidget(
                        date: selectableDates[1],
                        onPressed: selectableDates[1].weekday == 6
                            || selectableDates[1].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }: () {
                          setState(() {
                            selected[1] = !selected[1];
                          });
                        },
                        selected: selected[1],
                      ),
                      DateSelectableWidget(
                        date: selectableDates[2],
                        onPressed: selectableDates[2].weekday == 6
                            || selectableDates[2].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }:(){
                          print(selectableDates[2].weekday);
                          _hadleDatePressed(2);
                        },
                        selected: selected[2],
                      ),
                      DateSelectableWidget(
                        date: selectableDates[3],
                        onPressed:selectableDates[3].weekday == 6
                            || selectableDates[3].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }: () {
                          setState(() {
                            selected[3] = !selected[3];
                          });
                        },
                        selected: selected[3],
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DateSelectableWidget(
                        date: selectableDates[4],
                        onPressed: selectableDates[4].weekday == 6
                            || selectableDates[4].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }:() {
                          setState(() {
                            selected[4] = !selected[4];
                          });
                        },
                        selected: selected[4],
                      ),
                      DateSelectableWidget(
                        date: selectableDates[5],
                        onPressed: selectableDates[5].weekday == 6
                            || selectableDates[5].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        } : () {
                          setState(() {
                            selected[5] = !selected[5];
                          });
                        },
                        selected: selected[5],
                      ),
                      DateSelectableWidget(
                        date: selectableDates[6],
                        onPressed: selectableDates[6].weekday == 6
                            || selectableDates[6].weekday == 7 ? (){
                          showSimpleNotification(Text("You cant schedule multiple "
                              "rides on any weekend"));
                        }:() {
                          setState(() {
                            selected[6] = !selected[6];
                          });
                        },
                        selected: selected[6],
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Selecting the  number  of days you want to "
                      "create a scedule for and we will help you creare them"),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                        color: primaryColor,
                        child: Text(
                          "Next".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _handleNextClicked,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
    );
  }

  _handleNextClicked(){
    if(selected.contains(true)){
      List<DateTime> ds = [];
      selected.asMap().forEach((index,value){
        if(value == true){
          ds.add(selectableDates[index]);
        }
      });
      _userModel.multiRideModel = _userModel.multiRideModel..dates = ds;
      Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmLocationScreen()));
    }else{
      showSimpleNotification(Text("You need to select a date to proceed"),background: Colors.blue);
    }

  }

  _hadleDatePressed(int i) {
    setState(() {
      selected[i] = !selected[i];
    });
  }
}

class DateSelectableWidget extends StatelessWidget {
  final DateTime date;
  final Function onPressed;
  final bool selected;
  const DateSelectableWidget({
    Key key,
    this.date,
    this.onPressed,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width / 4,
        height: 38,
        decoration: BoxDecoration(
            color: selected != true ? Colors.transparent : primaryColor,
            border: Border.all(
                color: selected == true ? Colors.transparent : primaryColor),
            borderRadius: BorderRadius.circular(3)),
        child: Center(
          child: Text(
            MyUtils.getReadableDateOfMonthShort(date),
            style: TextStyle(
                color: selected == true ? Colors.white : Colors.black),
          ),
        ),
        duration: Duration(milliseconds: 300),
      ),
    );
  }
}

class ActionSelectableWidget extends StatelessWidget {
  final DateTime date;
  final Function onPressed;
  const ActionSelectableWidget({
    Key key,
    this.date, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 38,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(3)),
        child: Center(
          child: Text("Select Monday - fridy "),
        ),
      ),
    );
  }
}
