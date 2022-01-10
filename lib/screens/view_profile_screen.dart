import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:math' as math;

class ViewProfileScreen extends StatefulWidget {
  final User user;
  final String userId;


  const ViewProfileScreen({Key key, this.user, this.userId}) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with AfterLayoutMixin<ViewProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  ProgressDialog pr;
  User user;
  bool connected = false;
  bool loading = false;

  @override
  void initState() {
    if(widget.user != null){
        user = widget.user;
    }else{
      loading = true;
    }


    
    super.initState();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: "Please wait");

    pprint("qqqqq ${widget.userId}");

    if(widget.user != null){
      pprint("qqqqq user is not null");
      var connected1 = _userModel.connections
          .where((connect) => connect.connectionId == widget.user.phoneNumber);
      //pprint("conne re ${connected1.first.connectionId}");
      if(connected1.toList().length > 0){

        setState(() {
          connected = true;
        });
      }
    }else{
      pprint("qqqqq user is null");
      User result = await _userModel.getAUser(widget.userId);

      var connected1 = _userModel.connections
          .where((connect) => connect.connectionId == result.phoneNumber);
      //pprint("conne re ${connected1.first.connectionId}");

      if(connected1.toList().length > 0){
        pprint("qqqqq set state");
        setState(() {
          user = result;
          connected = true;
          loading = false;
        });
      }else{
        setState(() {
          user = result;
          loading = false;
        });
      }

    }



  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleDistanceFromTop = (size.height / 1.3);
    final profileDistanceFromTop = (size.height - circleDistanceFromTop) / 2.5;
    _userModel = Provider.of<UserModel>(context);
    //pprint("connections user ${widget.user.idUrl}");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("User profile"),
      ),
      body: loading == true ? Container(child: Center(child: CircularProgressIndicator(),),) : CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: size.width - 40,
                    height: 170,
                    child: Hero(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: user.avatar,
                        ),
                      ),
                      tag: user.phoneNumber,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              user.fullName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            SmoothStarRating(
                              size: 16,
                              color: Colors.orange,
                              borderColor: Colors.black,
                              rating: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                    connected == false
                        ? RaisedButton(
                            color: primaryColor,
                            child: Text(
                              "Add Connection",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _addConnection,
                          )
                        : Text("Connected", style: TextStyle(color: Colors.green),)
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              user.drivingState == DrivingState.Does_Not_Drive
                  ? Container()
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Car Details",
                                  style: TextStyle(color: primaryColor),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Text(
                                        "Ahh-ghy",
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Popular routes",
                      style: TextStyle(color: primaryColor),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(user.homeLocation.title.length > 18 ? user.homeLocation.title.substring(0, 18): user.homeLocation.title),
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          "< -- >",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                    Text(user.workLocation.title.substring(0, 18)),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ]),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  void _addConnection() async {
    pr.show();
    var result = await _userModel.addConnection(Connection(
        userId: _userModel.user.phoneNumber,
        userProfilePix: widget.user.avatar,
        name: widget.user.fullName,
        connectionId: widget.user.phoneNumber,
        type: ConnectionType.CONNECTIONS));
    pr.hide();
    if (result['error'] == false) {

      setState(() {
        connected = true;
      });
      showInSnackBar('added connection');
    } else {
      showInSnackBar('Could not add connection');
    }
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
