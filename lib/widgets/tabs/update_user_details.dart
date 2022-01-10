import 'package:flutter/material.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/set_locations.dart';
import 'package:mobi/screens/update_profile/add_a_profile_url.dart';
import 'package:mobi/screens/update_profile/update_car_details.dart';
import 'package:mobi/viewmodels/user_view_model.dart';

class UpdateUserDetails extends StatelessWidget {
  const UpdateUserDetails({
    Key key,
    @required UserModel userModel,
  })  : _userModel = userModel,
        super(key: key);

  final UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return _userModel.user.drivingState != DrivingState.Does_Not_Drive
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: MyUtils.buildSizeWidth(6)),
                child: GestureDetector(
                  onTap: () {
                    if (_userModel.user.carDetails.plateNumber == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdateCarDetails()));
                    }
                  },
                  child: Material(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(MyUtils.buildSizeWidth(2)),
                        height: MyUtils.buildSizeHeight(8),
                        width: MyUtils.buildSizeWidth(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Text("Verify Your account",
                                style:
                                    TextStyle(fontSize: MyUtils.fontSize(3.3))),
                            Text(
                              _userModel.user.carDetails.plateNumber == null
                                  ? "Not verified"
                                  : "verified",
                              style: TextStyle(
                                  color:
                                      _userModel.user.carDetails.plateNumber ==
                                              null
                                          ? Colors.red
                                          : Colors.blueAccent,
                                  fontSize: MyUtils.fontSize(2.6)),
                            ),
                            Spacer()
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: MyUtils.buildSizeWidth(6)),
                child: GestureDetector(
                  onTap: () {
                    if(_userModel.user.homeLocation.title == null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetLocationsScreen()));
                    }

                  },
                  child: Material(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(MyUtils.buildSizeWidth(2)),
                        height: MyUtils.buildSizeHeight(8),
                        width: MyUtils.buildSizeWidth(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "Add Favorite Locations",
                              style: TextStyle(fontSize: MyUtils.fontSize(3.3)),
                            ),
                            Text(
                              _userModel.user.homeLocation.title == null
                                  ? "Not Added yet"
                                  : "Added Locations",
                              style: TextStyle(
                                  color:
                                      _userModel.user.homeLocation.title == null
                                          ? Colors.red
                                          : Colors.blueAccent,
                                  fontSize: MyUtils.fontSize(2.4)),
                            ),
                            Spacer()
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                      )),
                ),
              ),
            ],
          )
        : Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                child: GestureDetector(
                  onTap: () {
                    if(_userModel.user.homeLocation.title == null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetLocationsScreen()));
                    }
                  },
                  child: Material(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(MyUtils.buildSizeWidth(2)),
                        height: MyUtils.buildSizeHeight(8),
                        width: MyUtils.buildSizeWidth(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "Add Favorite Locations",
                              style: TextStyle(fontSize: MyUtils.fontSize(3.3)),
                            ),
                            Text(
                              _userModel.user.homeLocation.title == null
                                  ? "Not Added yet"
                                  : "Added Locations",
                              style: TextStyle(
                                  color:
                                      _userModel.user.homeLocation.title == null
                                          ? Colors.red
                                          : Colors.blueAccent,
                                  fontSize: MyUtils.fontSize(2.4)),
                            ),
                            Spacer()
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                      )),
                ),
              )
            ],
          );
  }
}
