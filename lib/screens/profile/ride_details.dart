import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/profile/church_details_screen.dart';
import 'package:mobi/screens/profile/work_details_screen.dart';
import 'package:mobi/screens/update_profile/harry.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/new/bottom_sheets.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

class RideDetailsTab extends StatefulWidget {
  @override
  _RideDetailsTabState createState() => _RideDetailsTabState();
}

class _RideDetailsTabState extends State<RideDetailsTab> with AfterLayoutMixin {
  final ProfileRepository _repo = locator<ProfileRepository>();
  UserModel _userModel;
  TheLocation _homeLocation;
  TheLocation _workLocation;
  TimeOfDayCustom _leaveForHome;
  TimeOfDayCustom _leaveForWork;

  bool _loading = false;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _homeLocation = _userModel.user.homeLocation;
      _workLocation = _userModel.user.workLocation;
      _leaveForWork = _userModel.user.leaveForWork;
      _leaveForHome = _userModel.user.leaveForHome;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return _homeLocation == null ? Container(): LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        print("llll ${constraint.maxHeight}");
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: fromLocFunc,
                  child: Material(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: secondaryGrey),
                              bottom: BorderSide(color: secondaryGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Home Location",
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              (_homeLocation != null && _homeLocation.title != null)
                                  ? _homeLocation.title.length > 20? _homeLocation.title.substring(0, 20)
                                  :_homeLocation.title: "click to set Home location",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: toLocFunc,
                  child: Material(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: secondaryGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Work Location",
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              (_workLocation != null && _workLocation.title != null)
                                  ? _workLocation.title.length > 20? _workLocation.title.substring(0, 20)
                                  :_workLocation.title: "click to set work location",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    showModalBottomSheet < Null > (context: context, builder: (BuildContext context) {
                      return UpcomingFeature();
                    });
                    //Navigator.push(context, MaterialPageRoute(builder: (_) => ChurchDetailsScreen()));
                  },
                  child: Material(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: secondaryGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Church Locations",
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                               "Click to set church location",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _pickTimeToLeaveHome,
                  child: Material(
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(

                              bottom: BorderSide(color: secondaryGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "When do you usually leave home?",
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              MyUtils.getReadableTime2(_leaveForWork),
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _pickTimeToLeaveWork,
                  child: Material(
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: secondaryGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "When do you usually leave work?",
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(MyUtils.getReadableTime2(_leaveForHome),
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
               constraint.maxHeight < 500 ? SizedBox(height: 50,): SizedBox(height: constraint.maxHeight-490,),
                SecondaryButton(
                  handleClick: _saveChanges,
                  title: "save changes".toUpperCase(),
                  width: double.infinity,
                  horizontalPadding: 20,
                  loading: _loading,
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        );
      },

    );
  }

  _saveChanges() async {
    if (_homeLocation.title != _userModel.user.homeLocation.title ||
        _workLocation.title != _userModel.user.workLocation.title ||
        _leaveForHome.toString() != _userModel.user.leaveForHome.toString() ||
        _leaveForWork.toString() != _userModel.user.leaveForWork.toString()
    ) {
      setState(() {
        _loading = true;
      });
      String result =
          await _userModel.updateUser2(_homeLocation, _workLocation,_leaveForHome, _leaveForWork);
      if (result.isEmpty) {
        showDialog(
            context: context,
            builder:(c){
              return AlertDialog(
                title: Text("Success"),
                content: Text("You have successfully updated your locations"),
              );
            });
      }
      setState(() {
        _loading = false;
      });
    } else {
      showSimpleNotification(Text("You have not mad any changes yet"),
          background: Colors.red,
          contentPadding: EdgeInsets.only(left: 30, right: 30));
    }
  }

  fromLocFunc() async {
    print("friday");
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LocationSearchScreen(
                  direction: LocationDirection.FRO,
                  save: false,
                )));
    if (loc != null) {
      setState(() {
        _homeLocation = loc;
      });
    } else {}

  }

  Future toLocFunc() async {
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LocationSearchScreen(
                  direction: LocationDirection.TO,
                  save: false,
                )));
    if (loc != null) {
      setState(() {
        _workLocation = loc;
      });
    } else {}
  }

  void _pickTimeToLeaveHome() async{
    TimeOfDay time1 = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    var time = TimeOfDayCustom(hour: time1.hour,minute: time1.minute);
    if(time != null){
      setState(() {
        _leaveForWork = time;
      });

    }
  }
  void _pickTimeToLeaveWork() async{
    TimeOfDay time1 = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    var time = TimeOfDayCustom(hour: time1.hour,minute: time1.minute);
    if(time != null){
      setState(() {
        _leaveForHome = time;
      });

    }
  }
}
