import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/screens/otp_screen.dart';

class VerifyNumberScreen extends StatefulWidget {
  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: size.height / 3.5,
          ),
          Center(child: Image.asset("assets/img/logo2.png")),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Verify your Number",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: size.width - 80,
              child: Text(
                "Your Phone Number is critical for you to take rides",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "phone number",
                    hintText: "0XXXXXXXXXX"),
              )),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ButtonTheme(
              minWidth: 200,
              height: 50,
              child: RaisedButton(
                color: primaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                },
                child: Text(
                  "GET OTP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
