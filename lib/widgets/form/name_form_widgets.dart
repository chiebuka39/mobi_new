import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';


class DynamicAlertFormFormWidget extends StatefulWidget {
  final String value;
  final String title;

  const DynamicAlertFormFormWidget({Key key, this.value, this.title,}) : super(key: key);
  @override
  _DynamicAlertFormFormWidgetState createState() => _DynamicAlertFormFormWidgetState();
}

class _DynamicAlertFormFormWidgetState extends State<DynamicAlertFormFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.value != null){
      _text.text = widget.value == null ? 0:widget.value;
    }
    _text.addListener(() {
      var result = _validateWorkPlace();
      setState(() {
        _errorMessage = result;
      });

    });
    super.initState();
  }



  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 205,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _text,
              decoration: InputDecoration(
                labelText: widget.title,
                errorText: _errorMessage,
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_errorMessage == null && _text.text.length != 0 ? _handleOkClicked: null,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  String _validateWorkPlace() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "${widget.title} must not be less then 1".toUpperCase();
    } else if (value.trim().length < 1) {
      return "${widget.title} must not be less then 1".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, int.parse(_text.text));
  }
}

class DynamicAlertFormWidget extends StatefulWidget {
  final String value;
  final String title;

  const DynamicAlertFormWidget({Key key, this.value, this.title,}) : super(key: key);
  @override
  _DynamicAlertFormWidgetState createState() => _DynamicAlertFormWidgetState();
}

class _DynamicAlertFormWidgetState extends State<DynamicAlertFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.value != null){
      _text.text = widget.value == null ? 0:widget.value;
    }
    _text.addListener(() {
      var result = _validateWorkPlace();
      setState(() {
        _errorMessage = result;
      });

    });
    super.initState();
  }



  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 205,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _text,
              decoration: InputDecoration(
                labelText: widget.title,
                errorText: _errorMessage,
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_errorMessage == null && _text.text.length != 0 ? _handleOkClicked: null,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  String _validateWorkPlace() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "${widget.title} must not be less then 1".toUpperCase();
    } else if (value.trim().length < 1) {
      return "${widget.title} must not be less then 1".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}

class NameFormWidget extends StatefulWidget {
  final String fullName;

  const NameFormWidget({Key key, this.fullName}) : super(key: key);
  @override
  _NameFormWidgetState createState() => _NameFormWidgetState();
}

class _NameFormWidgetState extends State<NameFormWidget> with AfterLayoutMixin {
  final _text = TextEditingController();
  bool _validate = false;
  String _errorMessage;

  @override
  void initState() {
    if(widget.fullName != null){
      _text.text = widget.fullName;
    }
    _text.addListener(() {
      var result = _validateFullName();
      setState(() {
        _errorMessage = result;
      });

    });
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _validate = true;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 205,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Full name",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Full name',
                errorText: _errorMessage,
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_errorMessage == null && _text.text.length != 0 ? _handleOkClicked: null,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  String _validateFullName() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Full name must not be empty";
    } else if (!value.trim().contains(" ")) {
      return "First Name and Last name Required";
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}




class WorkPlaceFormWidget extends StatefulWidget {
  final String workPlace;

  const WorkPlaceFormWidget({Key key, this.workPlace}) : super(key: key);
  @override
  _WorkPlaceFormWidgetState createState() => _WorkPlaceFormWidgetState();
}

class _WorkPlaceFormWidgetState extends State<WorkPlaceFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.workPlace != null){
      _text.text = widget.workPlace;
    }
    _text.addListener(() {
      var result = _validateWorkPlace();
      setState(() {
        _errorMessage = result;
      });

    });
    super.initState();
  }



  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 205,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Work Place",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Work Place',
                errorText: _errorMessage,
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_errorMessage == null && _text.text.length != 0 ? _handleOkClicked: null,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  String _validateWorkPlace() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Work place must not be less then 4".toUpperCase();
    } else if (value.trim().length < 4) {
      return "Work place must not be less then 4".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}

class JobRolePlaceFormWidget extends StatefulWidget {
  final String jobRole;

  const JobRolePlaceFormWidget({Key key, this.jobRole}) : super(key: key);
  @override
  _JobRolePlaceFormWidgetState createState() => _JobRolePlaceFormWidgetState();
}

class _JobRolePlaceFormWidgetState extends State<JobRolePlaceFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.jobRole != null){
      _text.text = widget.jobRole;
    }
    _text.addListener(() {
      var result = _validateWorkPlace();
      setState(() {
        _errorMessage = result;
      });

    });
    super.initState();
  }



  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 205,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Job Role",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Job Role',
                errorText: _errorMessage,
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_errorMessage == null && _text.text.length != 0 ? _handleOkClicked: null,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  String _validateWorkPlace() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Job Role must not be less then 4".toUpperCase();
    } else if (value.trim().length < 4) {
      return "Job Role must not be less then 4".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}

class DriveStatusPlaceFormWidget extends StatefulWidget {
  final DrivingState drivingState;

  const DriveStatusPlaceFormWidget({Key key, this.drivingState}) : super(key: key);
  @override
  _DriveStatusPlaceFormWidgetState createState() => _DriveStatusPlaceFormWidgetState();
}

class _DriveStatusPlaceFormWidgetState extends State<DriveStatusPlaceFormWidget> {

  int _radioValue1 = -1;

  @override
  void initState() {
  if(widget.drivingState == DrivingState.Drives){
    setState(() {
      _radioValue1 = 1;
    });
  }else if(widget.drivingState == DrivingState.Does_Not_Drive){
    setState(() {
      _radioValue1 = 0;
    });
  }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 225,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Do you drive?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                if(_radioValue1 != 0){
                  setState(() {
                    _radioValue1 = 0;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("No, I don\'t"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                  }, value: 0,
                  )
                ],),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                if(_radioValue1 != 1){
                  setState(() {
                    _radioValue1 = 1;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("Yes, I do"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                  }, value: 1,
                  )
                ],),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_radioValue1 == -1  ?null: _handleOkClicked,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  

  void _handleOkClicked() {
    Navigator.pop(context, _radioValue1 == 0 ? DrivingState.Does_Not_Drive : DrivingState.Drives);
  }
}

class DrivingStatusFormWidget extends StatefulWidget {
  final DriveOrRide driving;

  const DrivingStatusFormWidget({Key key, this.driving}) : super(key: key);
  @override
  _DrivingStatusFormWidgetState createState() => _DrivingStatusFormWidgetState();
}

class _DrivingStatusFormWidgetState extends State<DrivingStatusFormWidget> {

  int _radioValue1 = -1;

  @override
  void initState() {
    if(widget.driving == DriveOrRide.DRIVE){
      setState(() {
        _radioValue1 = 1;
      });
    }else if(widget.driving == DriveOrRide.RIDE){
      setState(() {
        _radioValue1 = 0;
      });
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 225,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Would you be driving?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                if(_radioValue1 != 0){
                  setState(() {
                    _radioValue1 = 0;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("No"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 0,
                  )
                ],),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                if(_radioValue1 != 1){
                  setState(() {
                    _radioValue1 = 1;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("Yes"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 1,
                  )
                ],),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_radioValue1 == -1  ?null: _handleOkClicked,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }



  void _handleOkClicked() {
    Navigator.pop(context, _radioValue1 == 0 ? DriveOrRide.RIDE : DriveOrRide.DRIVE);
  }
}

class RepeatScheduleFormWidget extends StatefulWidget {
  final bool schedule;

  const RepeatScheduleFormWidget({Key key, this.schedule}) : super(key: key);
  @override
  _RepeatScheduleFormWidgetState createState() => _RepeatScheduleFormWidgetState();
}

class _RepeatScheduleFormWidgetState extends State<RepeatScheduleFormWidget> {

  int _radioValue1 = -1;

  @override
  void initState() {
    if(widget.schedule == true){
      setState(() {
        _radioValue1 = 1;
      });
    }else if(widget.schedule == false){
      setState(() {
        _radioValue1 = 0;
      });
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 245,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: Text(
                    "Should we scedule your rides for the week?",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                if(_radioValue1 != 0){
                  setState(() {
                    _radioValue1 = 0;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("No"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 0,
                  )
                ],),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                if(_radioValue1 != 1){
                  setState(() {
                    _radioValue1 = 1;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("Yes"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 1,
                  )
                ],),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_radioValue1 == -1  ?null: _handleOkClicked,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }



  void _handleOkClicked() {
    Navigator.pop(context, _radioValue1 == 0 ? false : true);
  }
}



class RidingVisibillityFormWidget extends StatefulWidget {
  final bool isVisible;

  const RidingVisibillityFormWidget({Key key, this.isVisible}) : super(key: key);
  @override
  _RidingVisibillityFormWidgetState createState() => _RidingVisibillityFormWidgetState();
}

class _RidingVisibillityFormWidgetState extends State<RidingVisibillityFormWidget> {

  int _radioValue1 = -1;

  @override
  void initState() {
    if(widget.isVisible == true){
      setState(() {
        _radioValue1 = 1;
      });
    }else if(widget.isVisible == false){
      setState(() {
        _radioValue1 = 0;
      });
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 225,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Show Ride?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                if(_radioValue1 != 0){
                  setState(() {
                    _radioValue1 = 0;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("No"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 0,
                  )
                ],),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                if(_radioValue1 != 1){
                  setState(() {
                    _radioValue1 = 1;
                  });
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Text("Yes"),
                  Spacer(),
                  Radio(
                    groupValue: _radioValue1,
                    onChanged: (int value) {
                      setState(() {
                        _radioValue1 = value;
                      });
                    }, value: 1,
                  )
                ],),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  onPressed:_radioValue1 == -1  ?null: _handleOkClicked,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }



  void _handleOkClicked() {
    Navigator.pop(context, _radioValue1 == 0 ? false : true);
  }
}