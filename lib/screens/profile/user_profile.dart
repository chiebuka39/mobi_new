
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobi/screens/profile/car_details.dart';
import 'package:mobi/screens/profile/personal.dart';
import 'package:mobi/screens/profile/ride_details.dart';

import 'package:mobi/widgets/form/buttomTabBar.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: BottomTabBar(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: [
                  PersonalTab(),
                  CarDetailsTab(),
                  RideDetailsTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

