import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:mobi/extras/analytics.dart';
import 'package:mobi/extras/app_config.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/secondary_state.dart';
import 'package:mobi/screens/settings/coupon.dart';
import 'package:mobi/screens/connections/users_connections.dart';
import 'package:mobi/screens/settings/faq.dart';
import 'package:mobi/screens/settings/wallet.dart';
import 'package:mobi/screens/sign_in_screen.dart';
import 'package:mobi/screens/update_profile/update_car_details.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserModel _userModel;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://mobbid.page.link',
      link: Uri.parse('https://www.mobirideng.com/app'),
      androidParameters: AndroidParameters(
        packageName: 'me.mobbid.mobiride',
        minimumVersion: 125,
      )
  );

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    print(_userModel.user.avatar);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: MyUtils.buildSizeHeight(25),
            width: double.infinity,
            decoration: BoxDecoration(color: primaryColor),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: MyUtils.buildSizeHeight(5),
                  right: MyUtils.buildSizeWidth(-20),
                  child: Container(
                    width: MyUtils.buildSizeWidth(70),
                    height: MyUtils.buildSizeWidth(70),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle),
                  ),
                ),
                Positioned(
                  top: MyUtils.buildSizeHeight(-5),
                  right: MyUtils.buildSizeWidth(-20),
                  child: Container(
                    width: MyUtils.buildSizeWidth(40),
                    height: MyUtils.buildSizeWidth(40),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle),
                  ),
                ),
                Positioned(
                  top: MyUtils.buildSizeHeight(10),
                  left: MyUtils.buildSizeWidth(-20),
                  child: Container(
                    width: MyUtils.buildSizeWidth(50),
                    height: MyUtils.buildSizeWidth(50),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MyUtils.buildSizeHeight(7),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MyUtils.buildSizeWidth(7)),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyUtils.fontSize(6.5),
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: MyUtils.buildSizeHeight(2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MyUtils.buildSizeWidth(7), top: 0),
                      child: Row(
                        children: <Widget>[
                          ClipOval(
                            clipper: CircleClipper(),
                            child: CachedNetworkImage(
                              imageUrl: _userModel.user.avatar,
                              width: MyUtils.buildSizeWidth(10),
                              height: MyUtils.buildSizeWidth(10),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            _userModel.user.fullName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MyUtils.fontSize(4),
                                color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MyUtils.buildSizeWidth(100),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: ListView(
                children: <Widget>[
                  new SettingsItemWidget(
                    icon: "assets/img/info.svg",
                    title: "FAQ",
                    onClick: () {

                      Navigator.of(context).push( MaterialPageRoute(builder: (_){
                        return FaqScreen();
                      }));
                    },
                  ),
                  new SettingsItemWidget(
                    icon: "assets/img/share.svg",
                    title: "Invite Friends",
                    onClick: () async{
                      final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
                      Share.share(dynamicUrl.shortUrl.toString());
                    },
                  ),
                  new SettingsItemWidget(
                    icon: "assets/img/connections.svg",
                    title: "Your Connections",
                    onClick: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UserConnections()));
                    },
                  ),
                  ///Users/NCKtech/Documents/flutter  export PATH="$PATH:Users/NCKtech/Documents/flutter/bin"
                  new SettingsItemWidget(
                    icon: "assets/img/message.svg",
                    title: "Coupons",
                    onClick: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RedeemCoupon(couponId: _userModel.user.couponId,)));
                    },
                  ),
                  new SettingsItemWidget(
                    icon: "assets/img/info.svg",
                    title: "Rate The App",
                    onClick: () {
                      _openLink(MyStrings.appStoreLink());
                    },
                  ),
                  new SettingsItemWidget(
                    icon: "assets/img/logout.svg",
                    title: "Sign Out",
                    onClick: () {
                      _showConfirmLogoutDialog();
                    },
                  ),
                  new SettingsItemWidget(
                    icon: "assets/img/shield.svg",
                    showBorder: false,
                    title: "Privacy Policy",
                    onClick: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCarDetails()));
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showConfirmLogoutDialog() {
    var content = new Text('Do you want to log out');
    if (Platform.isIOS) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new CupertinoAlertDialog(
              content: content,
              actions: <Widget>[
                new CupertinoDialogAction(
                    child: const Text('Yes'),
                    isDestructiveAction: true,
                    onPressed: () {
                      _logout();

                    }),
                new CupertinoDialogAction(
                  child: const Text('No'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              content: content,
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      _logout();
                    },
                    child: new Text('Yes')),
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('No'))
              ],
            );
          });
    }
  }

  void _logout() {
    final box = Hive.box(MyStrings.state);
    box.put("user", null);
    box.put("state", SecondaryState(false));

    FirebaseAuth.instance.signOut();

    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route<dynamic> route) => false);
  }

  _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar("Some thing went wrong");
    }
  }

  void showSnackBar(String str) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(str)));
  }
}

class SettingsItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function onClick;
  final bool showBorder;

  const SettingsItemWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onClick,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
        child: Container(
          height: 70,
          width: MyUtils.buildSizeWidth(76),
          decoration: BoxDecoration(
              border: showBorder
                  ? Border(
                      bottom: BorderSide(color: Colors.black.withOpacity(0.2)))
                  : null),
          child: Row(
            children: <Widget>[
              Container(
                width: MyUtils.buildSizeWidth(8),
                height: MyUtils.buildSizeWidth(8),
                decoration:
                    BoxDecoration(color: secondaryGrey, shape: BoxShape.circle),
                child: Center(
                    child: SvgPicture.asset(
                  icon,
                  width: MyUtils.buildSizeWidth(4),color: primaryColor,
                )),
              ),
              SizedBox(
                width: MyUtils.buildSizeWidth(5),
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: MyUtils.fontSize(4)),
              )
            ],
          ),
        ),
      ),
    );
  }
}


//api key : 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
