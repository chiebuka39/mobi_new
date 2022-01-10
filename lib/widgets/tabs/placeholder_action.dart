import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/utils.dart';
import 'package:share/share.dart';

class PlaceHolderAction extends StatelessWidget {
  final DateTime dateOfLaunch;
  final DateTime currentDay;
  Uri dynamicUrl;

  DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://mobbid.page.link',
    link: Uri.parse('https://mobbid.me/'),
    androidParameters: AndroidParameters(
      packageName: 'me.mobbid.mobiride',
      minimumVersion: 1,
    ),
//    iosParameters: IosParameters(
//      bundleId: 'me.mobbid.mobiride',
//      minimumVersion: '1.0.1',
//      appStoreId: '123456789',
//    ),
  );

  PlaceHolderAction({
    Key key,@required this.dateOfLaunch,@required this.currentDay,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    parameters.buildUrl().then((uri){
      dynamicUrl = uri;
    });
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
      child: Row(
        children: <Widget>[
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: MyUtils.buildSizeHeight(12),
              width: MyUtils.buildSizeWidth(42),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 3,
                  ),
                  Text(
                    "${dateOfLaunch.difference(currentDay).inDays} Days",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MyUtils.fontSize(5)),
                  ),
                  Text(
                    "To Launch",
                    style: TextStyle(fontSize: MyUtils.fontSize(3)),
                  ),
                  Spacer(
                    flex: 3,
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: ()async{

                Share.share("Hey, Transform your rides to work by riding with others, click on the link to get Started $dynamicUrl");

              },
              child: Container(
                height: MyUtils.buildSizeHeight(12),
                width: MyUtils.buildSizeWidth(42),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: <Widget>[
                    Spacer(
                      flex: 3,
                    ),
                    SvgPicture.asset(
                      "assets/img/invitation.svg",
                      width: MyUtils.buildSizeWidth(5),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Invite Friends",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MyUtils.buildSizeWidth(4)),
                    ),
                    Spacer(
                      flex: 3,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}