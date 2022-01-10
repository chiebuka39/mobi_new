import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/styles.dart';
import 'package:mobi/extras/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/rides/multiple/multi_schedule_summary.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
 
import 'package:provider/provider.dart';

class SelectRideAmount extends StatefulWidget {
  @override
  _SelectRideAmountState createState() => _SelectRideAmountState();
}

class _SelectRideAmountState extends State<SelectRideAmount>
    with AfterLayoutMixin<SelectRideAmount> {
  UserModel _userModel;

  int _amount =0;

  @override
  void afterFirstLayout(BuildContext context) {


  }
  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            child: Text(
              "Whats are you likely to charge per ride?",
              style: rideTitle,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          FormSelectorSecondary(
            showTopBorder: true,
            value: "0",

            title: Container(
              width: 150,
              child: Row(children: <Widget>[
                Icon(Icons.monetization_on, size: 20,),
                SizedBox(width: 5,),
                Text("NGN ${_amount == null ? 0:_amount}", style: TextStyle(fontWeight: FontWeight.w600),)
              ],),
            ),
            desc: Text("Edit", style: TextStyle(color: Colors.blue),),
            onPressed: () async {
              int result = await showDialog(
                  context: context,
                   builder: (BuildContext context) {
                    return DynamicAlertFormFormWidget(
                      title: "Ride Price",
                      value: _amount.toString(),
                    );
              });
              if (result != null) {
                setState(() {
                  _amount = result;
                });
              }
            },
          ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width -100,
              child: Text("Selecting a time when you normally leave your  "
                  "work for home, you can always edit the time later if need be"),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  color: primaryColor,
                  child: Text(
                    "Next".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _goToNextScreen,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
        ],),
      ),
    );
  }

  void _goToNextScreen() {
    if(_amount == null){
      showSimpleNotification(Text("You need to enter an amount, even it it is zero"));
    }else{
      _userModel.multiRideModel = _userModel.multiRideModel..amount = _amount;
      Navigator.push(context, MaterialPageRoute(builder: (_) => MultiScheduleSummary()));
    }

  }
}
