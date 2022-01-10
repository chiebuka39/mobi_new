import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/animations/fade_in.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/set_up_profile/profile_details_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:math' as math;

class ViewUserScreen extends StatefulWidget {
  final User user;
  final String userId;
  final bool viewProfile;

  const ViewUserScreen(
      {Key key, this.user, this.userId, this.viewProfile = false})
      : super(key: key);

  @override
  _ViewUserScreenState createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen>
    with AfterLayoutMixin<ViewUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  ProgressDialog pr;
  User user;
  bool connected = false;
  bool loading = false;

  @override
  void initState() {
    if (widget.user != null) {
      user = widget.user;
    } else {
      loading = true;
    }

    super.initState();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: "Please wait");

    pprint("qqqqq ${widget.userId}");

    if (widget.user != null) {
      pprint("qqqqq user is not null");
      var connected1 = _userModel.connections
          .where((connect) => connect.connectionId == widget.user.phoneNumber);
      //pprint("conne re ${connected1.first.connectionId}");
      if (connected1.toList().length > 0) {
        setState(() {
          connected = true;
        });
      }
    } else {
      pprint("qqqqq user is null");
      User result = await _userModel.getAUser(widget.userId);
      pprint("qqqqq user is null ${result.emailAddress}");
      var connected1 = _userModel.connections
          .where((connect) => connect.connectionId == result.phoneNumber);
      //pprint("conne re ${connected1.first.connectionId}");

      if (connected1.toList().length > 0) {
        pprint("qqqqq set state");
        setState(() {
          user = result;
          connected = true;
          loading = false;
        });
      } else {
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
    //pprint("connections user ${user.workIdentityUrl}");

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: 250,
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
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: FadeIn(
                1.0,
                Container(
                  height: MediaQuery.of(context).size.height - 170,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 20, left: 30, right: 30),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "${user.fullName}".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${user.jobDesc.isEmpty ? "None added" : user.jobDesc}"
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: myJobDescColor, fontSize: 11),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "${user.jobDesc.isEmpty ? "I love to play video games "
                                      "and hangout a lot with my friends, "
                                      "i wouldnt reject a lpate of isi-ewu "
                                      "if iam given one" : user.jobDesc}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: myJobDescColor, fontSize: 11),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                connected == true && widget.viewProfile == true
                                    ? Text(
                                        "Connected",
                                        style: TextStyle(color: primaryColor),
                                      )
                                    : ButtonTheme(
                                        minWidth: 140,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: FlatButton(
                                          color: primaryColor,
                                          onPressed: widget.viewProfile == true
                                              ? _addConnection
                                              : () {
                                                  print(
                                                      "ebuja jha ${user.toString()}");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, user);
                                                },
                                          child: Text(
                                            widget.viewProfile == true
                                                ? "Add Connection"
                                                : "Send invitation request"
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
//                                Divider(),
//                                Expanded(
//                                  child: Row(
//                                    children: <Widget>[
//                                      ProfileStatWidget(
//                                        title: "total rides",
//                                        content: "45",
//                                      ),
//                                      Container(
//                                        width: .1,
//                                        color: Colors.black,
//                                      ),
//                                      ProfileStatWidget(
//                                        title: "Average ratings",
//                                        content: "4.3",
//                                      )
//                                    ],
//                                  ),
//                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Text("Profile details"),
                        ],
                      ),
                      if(user.workIdentityUrl?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Work Id Verified",),
                      if(user.accounts.twitter?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Twitter URL added",isUrl: true,url: user.accounts.twitter,),
                      if(user.accounts.fb?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Facebook URL added",isUrl: true,url: user.accounts.fb),
                      if(user.accounts.instagram?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Instagram URL added",isUrl: true,url: user.accounts.instagram),
                      if(user.accounts.linkedIn?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Linkedin URL added",isUrl: true,url: user.accounts.linkedIn),
                      if(user.carDetails.licenseImageUrl?.isNotEmpty ?? false)
                        ProfileDetailsWidget(title: "Drivers License is added",),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 40,
              child: Container(
                height: 40,
                width: 40,

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Center(
                  child: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
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

class ProfileStatWidget extends StatelessWidget {
  final String title;
  final String content;
  const ProfileStatWidget({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title.toUpperCase(),
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              content,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            )
          ],
        ),
      ),
    );
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
