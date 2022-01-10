import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';

class PromoWidget extends StatelessWidget {
  final Function closeFuction;
  final Function sendToWallet;

  const PromoWidget({Key key, this.closeFuction, this.sendToWallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        width: 300,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(7)),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              child: IconButton(onPressed: closeFuction,icon: Icon(Icons.clear, color: Colors.white,),),),
            Column(
              children: <Widget>[
                Spacer(),
                SvgPicture.asset(
                  "assets/img/giftbox.svg",
                  height: 50,
                 
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Hurray!! Credit alert",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "You have been credited with 200 naira as a welcome package for your use in your rides",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 30,),
                Container(width:200,child: FlatButton(onPressed: (){}, child: Text("View Wallet"),color: Colors.white,)),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
