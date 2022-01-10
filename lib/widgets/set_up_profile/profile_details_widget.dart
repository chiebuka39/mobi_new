import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final String title;
  final String url;
  final bool isUrl;
  const ProfileDetailsWidget({
    Key key, this.title, this.url, this.isUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: InkWell(
        onTap: (){
          print("url $url");
          if(isUrl == true){
            _launchURL(url);
          }
        },
        child: Container(
          child: Row(children: <Widget>[
            SvgPicture.asset("assets/img/green_check.svg"),
            SizedBox(width: 15,),
            Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),)

          ],),
        ),
      ),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
