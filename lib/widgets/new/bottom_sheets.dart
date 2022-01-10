import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/margins.dart';
import 'package:mobi/models/bank.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:toast/toast.dart';

class UpcomingFeature extends StatelessWidget {
  const UpcomingFeature({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    

    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(children: [
        YMargin(10),
        Center(child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
          ),
        ),),
        YMargin(20),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
              )
          ),
          child: Column(
            children: [
              YMargin(30),
              Text("Feature coming soon", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              YMargin(20),
              SizedBox(
                  width: 300,
                  child: Text('We would inform you when this '
                      'feature is available for use',style:TextStyle(height: 1.7),textAlign: TextAlign.center,)),
              YMargin(30),
              PrimaryButton(
                title: 'Okay',
                handleClick: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ))
      ],),
    );

  }
}
class ShowBankDetailsWidget extends StatelessWidget {
  const ShowBankDetailsWidget({
    Key key, this.bank,
  }) : super(key: key);

  final Bank bank;



  @override
  Widget build(BuildContext context) {


    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(children: [
        YMargin(10),
        Center(child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
          ),
        ),),
        YMargin(20),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
              )
          ),
          child: Column(
            children: [
              YMargin(30),
              Text("Fund your wallet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              YMargin(20),
              GestureDetector(
                onTap: (){
                  Clipboard.setData(new ClipboardData(text: bank.accountNum)).then((value) {

                    Toast.show("Account number copied", context,
                        duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  });

                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: secondaryGrey,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YMargin(10),
                    Text("Copy to fund your wallet", style: TextStyle(fontSize: 13),),
                      YMargin(11),
                      Row(
                        children: [
                          Column(

                            children: [
                              Text(bank.bankName.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                              YMargin(2),
                              Text(bank.accountNum.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                              YMargin(2),
                              Text(bank.accountName.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                            ],crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          Spacer(),
                          Icon(Icons.copy_rounded)
                        ],
                      ),

                  ],),
                ),
              ),
              YMargin(15),
              SizedBox(
                  width: 300,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:TextSpan(
                    children: [
                      TextSpan(text: 'Sending money to the company account enters your mobiride wallet, ',
                          style:TextStyle(height: 1.7, color: Colors.black54)),
                      TextSpan(text: 'in 1-3 hours,',style:TextStyle(height: 1.7, fontWeight: FontWeight.w600, color: Colors.black)),
                      TextSpan(text: 'and if your',style:TextStyle(height: 1.7,color: Colors.black54)),
                      TextSpan(text: ' Mobiride Name matches your account name',
                          style:TextStyle(height: 1.7, fontWeight: FontWeight.bold, color: Colors.black),),
                    ]
                  ),)),

            ],
          ),
        ))
      ],),
    );

  }
}

