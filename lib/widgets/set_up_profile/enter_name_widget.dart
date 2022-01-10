import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/widgets/primary_button.dart';

class EnterNameWidget extends StatefulWidget {
  final ReceiveNameDetails onPressed;
  final String coupon;

  const EnterNameWidget({Key key, this.onPressed, this.coupon})
      : super(key: key);
  @override
  _EnterNameWidgetState createState() => _EnterNameWidgetState();
}

class _EnterNameWidgetState extends State<EnterNameWidget> {
  var _key = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _firstName;
  String _lastName;

  String _coupon;

  @override
  void initState() {
    if(widget.coupon != null){
      _coupon = widget.coupon;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      autovalidate: _autoValidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Hello, We would love you to answer a few questions, to set up your profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
              onSaved: _saveFirstName,
              decoration: InputDecoration(
                  labelText: "First name",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14)),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              validator: _validateLastName,
              onSaved: _saveLastName,
              decoration: InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14)),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: _coupon ?? '',
              onSaved: (value){
                print("this is coupon $value");
                _coupon = value;
              },
              validator: (value){
                return null;
              },
              enabled: false,
              decoration: InputDecoration(
                  labelText: "Coupon Code",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14)),
            ),
            Spacer(
              flex: 3,
            ),
            SecondaryButton(
              handleClick: () {
                var form = _key.currentState;

                if(form.validate()){
                  form.save();
                  print("coupon isss $_coupon");
                  widget.onPressed("$_lastName $_firstName",_coupon);
                }else{
                  setState(() {
                    _autoValidate = true;
                  });
                  showSimpleNotification(Text("Fix the errors in red to proceed"), background: Colors.red);
                }

              },
              title: "Next",
              width: double.infinity,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _saveFirstName(value) {
              _firstName = value;
              _coupon = value;
            }

  void _saveLastName(value) {
    _lastName = value;
  }

  String _validateName(value) {
    if (value.trim().length > 3) {
      return null;
    } else {
      return "Your first name should be more than 3 characters";
    }
  }

  String _validateLastName(String value) {
    if (value.trim().length > 3) {
      return null;
    } else {
      return "Your Last name should be more than 3 characters";
    }
  }
}

typedef ReceiveNameDetails<T> = void Function(String firstname, String lastname);
