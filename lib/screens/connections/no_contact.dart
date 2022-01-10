import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:share/share.dart';

class NoContact extends StatelessWidget {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://mobbid.page.link',
    link: Uri.parse('https://mobbid.me/new_user'),
    androidParameters: AndroidParameters(
      packageName: 'me.mobbid.mobi',
      minimumVersion: 125,
    )
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          SvgPicture.asset("assets/img/blank-rounded.svg"),
          SizedBox(
            height: 20,
          ),
          Container(
              width: MyUtils.buildSizeWidth(50),
              child: Text(
                "You have not added anyone to this group yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: MyUtils.fontSize(4)),
              )),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Container(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Send an Invite",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()async {
                      // open contact picker from native
                      final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
                      Share.share(dynamicUrl.shortUrl.toString());
                    },
                    color: primaryColor,
                  )),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}