import 'package:after_layout/after_layout.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/connections/invitePopUp.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class InviteFriend extends StatefulWidget {
  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend>
    with AfterLayoutMixin<InviteFriend> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserModel _userModel;
  User _user;
  String _promoId = "";
  DynamicLinkParameters parameters;
  ShortDynamicLink _shortLink;

  @override
  void afterFirstLayout(BuildContext context) async {
    _user = _userModel.user;
    setState(() {
      _promoId =
          "${_user.fullName.substring(0, 2)}${_user.phoneNumber.substring(_user.phoneNumber.length - 4)}";
    });

    parameters = DynamicLinkParameters(
      uriPrefix: 'https://mobbid.page.link',
      link: Uri.parse('https://www.mobing.com/$_promoId'),
      androidParameters: AndroidParameters(
        packageName: 'me.mobbid.mobiride',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'me.mobbid.mobbidRide',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
    );

    _shortLink = await parameters.buildShortLink();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Free trips"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 300,
              child: Text(
                "Sent Your friends free trips and bonuses",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: SizedBox(
              width: 300,
              child: Text(
                "Share love with friends and coleagues by sharing different coupons",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return InvitePopUp();
                    });
              },
              child: Text(
                "More details",
                style: TextStyle(fontSize: 14, color: primaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 50),
                child: Image.asset("assets/img/people.png"),
              )
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 55,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    _promoId,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                                text: _shortLink.shortUrl.toString()))
                            .then((_) {
                          showInSnackBar("Url copied");
                        });
                      },
                      child: SvgPicture.asset("assets/img/download.svg")),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
                width: double.infinity,
                height: 55,
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: () {
                    Share.share(
                        "hey, use this link ${_shortLink.shortUrl.toString()} to get NGN1000,"
                        "for any ride, after you have carpooled with others using mobiride");
                  },
                  child: Text(
                    "Invite friends",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
