import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../nearby_commutters.dart';

class UserConnections extends StatefulWidget {
  UserConnections({Key key}) : super(key: key);
  @override
  _UserConnectionsState createState() => _UserConnectionsState();
}

class _UserConnectionsState extends State<UserConnections> {
  UserModel _userModel;
  //List<Connection> connections;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    print("pppp ${_userModel.user.couponId}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Your Connections",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _userModel.connections.length == 0 ? NoConnection(couponId: _userModel.user.couponId,): new YourConnections(userModel: _userModel),
    );
  }
}

class YourConnections extends StatelessWidget {
  const YourConnections({
    Key key,
    @required UserModel userModel,
  }) : _userModel = userModel, super(key: key);

  final UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: MyUtils.buildSizeWidth(6),
                    right: MyUtils.buildSizeWidth(6),
                    top: MyUtils.buildSizeWidth(2),
                ),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Material(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                imageUrl: _userModel
                                    .connections[index].userProfilePix,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        _userModel.connections[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyUtils.fontSize(4.3)),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: _userModel.connections.length,
          ),
        ),
      ],
    );
  }
}

class NoConnection extends StatefulWidget {
  final String couponId;
  const NoConnection({
    Key key, this.couponId,
  }) : super(key: key);

  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {

  DynamicLinkParameters parameters;

  @override
  void initState() {
    parameters = DynamicLinkParameters(
      uriPrefix: 'https://mobiride.page.link',
      link: Uri.parse('https://mobirideng.com/?invite=${widget.couponId}'),
      androidParameters: AndroidParameters(
        packageName: 'me.mobbid.mobiride',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'me.mobbid.mobbidRide',
        minimumVersion: '1.1.0',
        appStoreId: '1481578143',
      )
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //print('https://mobirideng.com/?invite=${widget.couponId}');
    return Column(
      children: <Widget>[
        Spacer(),
        Center(child: SvgPicture.asset("assets/img/network.svg", width: 100)),
        SizedBox(
          height: 15,
        ),
        Text(
          "No Connections Yet",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 40,
        ),
        PrimaryButton(
          title: "View NearBy Commutters",
          handleClick: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => NearbyCommuters()));
          },
        ),
        SizedBox(
          height: 15,
        ),
        PrimaryButton(
          title: "Invite A friend",
          handleClick: () async{
            final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
            print("this is the link ${dynamicUrl.shortUrl}");
          },
          buttonColor: primaryColor,
        ),
        Spacer(
          flex: 2,
        )
      ],
    );
  }
}
