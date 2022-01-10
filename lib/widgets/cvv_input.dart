import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi/extras/colors.dart';


class CVVInputSheet extends StatefulWidget {

  CVVInputSheet();

  @override
  _CVVInputSheetState createState() => _CVVInputSheetState();
}

class _CVVInputSheetState extends State<CVVInputSheet> {
  String error;
  String _amount;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Enter Amount',
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          new TextField(
            onChanged: onAmountChange,
            inputFormatters: [
              WhitelistingTextInputFormatter
                  .digitsOnly,
              new LengthLimitingTextInputFormatter(
                  6),
            ],
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: primaryColor)),
                labelText: 'Amount',

                errorMaxLines: 3,
                errorText: error),
            style: new TextStyle(color: primaryColor, fontSize: 15.0),
          ),
          new SizedBox(height: 30),
          new SizedBox(
            width: double.infinity,
            child: new RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(_amount);
              },
              color: thirdColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              child: new Text(
                'Pay Now',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onAmountChange(String value) {
   var ans = '';
   if(int.parse(value) < 1000){
      ans = "You must credit your wallet with atleast NGN1000";
   }

    setState(() {
      error = ans;
      _amount = value == null ? null:value;
    });
  }
}