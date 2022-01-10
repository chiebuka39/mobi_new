import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/margins.dart';
import 'package:mobi/extras/utils.dart';

class TwoOptionBottomWidget extends StatelessWidget {
  final String option1;
  final String option2;
  final VoidCallback option1CallBack;
  final VoidCallback option2CallBack;

  const TwoOptionBottomWidget({Key key, this.option1, this.option2, this.option1CallBack, this.option2CallBack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20 ),
                  topRight: Radius.circular(20 ),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                YMargin(20),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,height: 25,
                        decoration: BoxDecoration(
                            color:Colors.grey,
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.clear,size: 16,color: secondaryGrey,),),
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: option1CallBack,
                    child: Container(
                      color: Colors.transparent,
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: Text(option1),
                    )),
                Divider(),
                InkWell(
                  onTap: option2CallBack,
                  child: Container(
                    color: Colors.transparent,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(option2),
                  ),
                ),
              ],),
            ),
          ),
        )
      ],),
    );
  }
}


class NotLoggedInModal extends StatelessWidget {
  const NotLoggedInModal({
    Key key, this.title,this.content, this.login, this.btnTitle = "Login"
  }) : super(key: key);

  final String title;
  final String content;
  final String btnTitle;
  final VoidCallback login;



  @override
  Widget build(BuildContext context) {


    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(children: [
        YMargin(10),
        Center(child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child: Row(children: [
              Spacer(),
              Icon(Icons.clear, size: 19,),
              XMargin(10),
              Text("Close"),
              Spacer(),
            ],),
          ),
        ),),
        YMargin(20),
        Expanded(child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(left: 30,right: 30,bottom: 30),
          decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(7)
          ),
          child: Column(
            children: [
              YMargin(30),
              Text(title, style: TextStyle(fontSize: 16,
                  ),),
              YMargin(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(content, style: TextStyle(fontSize: 14,
                    ),textAlign: TextAlign.center,),
              ),
              YMargin(15),
              PrimaryButtonSmall(
                width: 150,
                title: btnTitle,
                onTap: login,
              )

            ],
          ),
        ))
      ],),
    );

  }

}
class PrimaryButtonSmall extends StatelessWidget {
  const PrimaryButtonSmall({
    Key key, this.title, this.onTap, this.width = 96, this.vertical = 10,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final double width;
  final double vertical;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: vertical),
        decoration: BoxDecoration(
            color: onTap == null ? primaryColor.withOpacity(0.5) :primaryColor,
            borderRadius: BorderRadius.circular(7),

        ),
        child: Center(child: Text(title.toUpperCase(), style: TextStyle(fontSize: 11, color:Colors.white),)),
      ),
    );
  }
}