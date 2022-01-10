import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class BottomTabBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(110);
}

class _BottomTabBarState extends State<BottomTabBar> {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: <Widget>[
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10,),
              Text(
                "(${_userModel.user.phoneNumber})",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TabBar(
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: secondaryTitleColor,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(
              text: "PERSONAL",
            ),
            Tab(
              text: "Car details".toUpperCase(),
            ),
            Tab(
              text: "Ride Details".toUpperCase(),
            ),
          ],
        ),
      ],
    );
  }
}