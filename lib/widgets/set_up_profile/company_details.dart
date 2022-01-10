import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/widgets/primary_button.dart';

class WorkDetailsWidget extends StatefulWidget {
  final ReceiveCompanyDetails onPressed;

  const WorkDetailsWidget({Key key, this.onPressed}) : super(key: key);
  @override
  _WorkDetailsWidgetState createState() => _WorkDetailsWidgetState();
}

class _WorkDetailsWidgetState extends State<WorkDetailsWidget> {
  var _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  
  String _companyName;
  String _emailAddress;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _key,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                "To Improve your chances of getting rides, We would love to know where you work",
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
              validator: _validateCompanyName,
              onSaved: (value){
                _companyName = value;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Name of company you work for?",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14)),
            ),
            SizedBox(
              height: 10,
            ),

            TextFormField(
           onSaved: (value){
             _emailAddress = value;
           },
              validator: (value){
             if(value.isNotEmpty){
               var result = EmailValidator.validate(value);
               if(result == true){
                 return null;
               }else{
                 return "Enter a valid email";
               }
             }
             return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Work Email (optional)",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14)),
            ),
            SizedBox(
              height: 10,
            ),
            Spacer(
              flex: 2,
            ),
            SecondaryButton(handleClick: (){
              var form = _key.currentState;
              if(form.validate()){
                form.save();
                widget.onPressed(_companyName, _emailAddress);
              }else{
                showSimpleNotification(
                    Text("Fix the errors in red"), background: Colors.red);              }

            }, title: "Next",
              width: double.infinity,
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  String _validateCompanyName(value){
              if (value.trim().length > 2) {
                return null;
              } else {
                return "Your company name should be more than 2 characters";
              }
            }
}

typedef ReceiveCompanyDetails<T> = void Function(String workplace, String email);
