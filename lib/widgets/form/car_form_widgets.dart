import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/models/user.dart';




class RegNumberFormWidget extends StatefulWidget {
  final String regNum;

  const RegNumberFormWidget({Key key, this.regNum}) : super(key: key);
  @override
  _RegNumberFormWidgetState createState() => _RegNumberFormWidgetState();
}

class _RegNumberFormWidgetState extends State<RegNumberFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.regNum != null){
      _text.text = widget.regNum;
    }
    _text.addListener(() {
      var result = _validateRegNumber();
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
                  "Car Plate Number",
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
                labelText: 'Car Plate Number',
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

  String _validateRegNumber() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Plate Number must be equal to 7".toUpperCase();
    } else if (value.trim().length != 7) {
      return "Plate Number must be equal to 7".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}

class CarModelFormWidget extends StatefulWidget {
  final String carModel;

  const CarModelFormWidget({Key key, this.carModel}) : super(key: key);
  @override
  _CarModelFormWidgetState createState() => _CarModelFormWidgetState();
}

class _CarModelFormWidgetState extends State<CarModelFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.carModel != null){
      _text.text = widget.carModel;
    }
    _text.addListener(() {
      var result = _validateRegNumber();
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
                  "Car Model",
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
                labelText: 'Car Model',
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

  String _validateRegNumber() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Car Model must not be less then 3".toUpperCase();
    } else if (value.trim().length < 3) {
      return "Car Model must not be less then 3".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}

class CarColorFormWidget extends StatefulWidget {
  final String carColor;

  const CarColorFormWidget({Key key, this.carColor}) : super(key: key);
  @override
  _CarColorFormWidgetState createState() => _CarColorFormWidgetState();
}

class _CarColorFormWidgetState extends State<CarColorFormWidget> {
  final _text = TextEditingController();
  String _errorMessage;

  @override
  void initState() {
    if(widget.carColor != null){
      _text.text = widget.carColor;
    }
    _text.addListener(() {
      var result = _validateCarColor();
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
                  "Car Color",
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
                labelText: 'Car Color',
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

  String _validateCarColor() {
    String value = _text.text;
    if (value == null || value.isEmpty) {
      return "Car Color must not be less then 3".toUpperCase();
    } else if (value.trim().length < 3) {
      return "Car Color must not be less then 3".toUpperCase();
    } else {
      return null;
    }
  }

  void _handleOkClicked() {
    Navigator.pop(context, _text.text);
  }
}




