import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/connections/invite.dart';
import 'package:mobi/screens/view_profile_screen.dart';
import 'package:mobi/screens/view_user_screen.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class NearbyCommuters extends StatefulWidget {
  NearbyCommuters({Key key}) : super(key: key);
  @override
  _NearbyCommutersState createState() => _NearbyCommutersState();
}

class _NearbyCommutersState extends State<NearbyCommuters>
    with AfterLayoutMixin<NearbyCommuters> {
  bool _loading = true;
  User _user;
  RidesViewModel _ridesViewModel;
  var randomGenerator = Random();
  List<Color> colors = [Color(0xFF4D7CF2).withOpacity(0.1),
  Color(0xFFF2804D).withOpacity(0.1)];

  @override
  void afterFirstLayout(BuildContext context) {
    _ridesViewModel.fetchNearByCommutters(_user).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    _user = _userModel.user;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Nearby Commuters", style: TextStyle(color: Colors.black),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(onPressed: (){},icon: SvgPicture.asset("assets/img/filter-list.svg"),)
          ],
        ),
        body: _loading == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _ridesViewModel.nearbyCommutters.length == 0
                ? Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 2,
                          ),
                          SvgPicture.asset(
                            "assets/img/sad.svg",
                            height: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "No Nearby Commutters",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ButtonTheme(
                              child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InviteFriend()));
                            },
                            child: Text(
                              "Invite a friend for a reward",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: primaryColor,
                          )),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.count(crossAxisCount: 2,  childAspectRatio: 1.0,
          padding: const EdgeInsets.all(1.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: List.generate(_ridesViewModel.nearbyCommutters.length, (index){
            User user = _ridesViewModel.nearbyCommutters[index];
            return CommuterWidget(user: user,color: colors[randomGenerator.nextInt(2)],);
          }),
        ));
  }


}

class CommuterWidget extends StatelessWidget {
  final User user;
  final Color color;
  const CommuterWidget({
    Key key,@required this.user, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("00jjjj ${user.idUrl}");
    UserModel _userModel = Provider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewUserScreen(
                      user: user,
                  viewProfile: true,
                    )));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color
        ),
        height: 160,
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: user.avatar,
                  fit: BoxFit.cover,
                  height: 53,
                  width: 53,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              tag: user.phoneNumber,
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              user.fullName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              user.jobDesc == "" ? "Not added": user.jobDesc,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            SmoothStarRating(
              size: 16,
              color: Colors.orange,
              borderColor: Colors.black,
              rating: 4,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
