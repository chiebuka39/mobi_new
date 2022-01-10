import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function handleClick;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final bool loading;

  const PrimaryButton(
      {Key key,
      @required this.title,
      @required this.handleClick,
      this.buttonColor = Colors.redAccent,
      this.textColor = Colors.white,
      this.width,
      this.height,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: width ?? 250,
      height: height ?? 45,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: buttonColor,
        child: loading == false ? Text(
          title,
          style: TextStyle(color: textColor),
        ): Container(height:20,width:20,child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
        onPressed: handleClick,
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {
  final String title;
  final Function handleClick;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final double elevation;
  final bool loading;
  final double horizontalPadding;

  const SecondaryButton(
      {Key key,
        @required this.title,
        @required this.handleClick,
        this.buttonColor = primaryColor,
        this.textColor = Colors.white,
        this.width,
        this.height,
        this.loading = false, this.horizontalPadding = 0, this.elevation = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ButtonTheme(
        minWidth: width ?? 250,
        height: height ?? 55,
        child: RaisedButton(
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: buttonColor,
          child: loading == false ? Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ): Container(height:20,width:20,child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
          onPressed: handleClick,
        ),
      ),
    );
  }
}

class SecondaryOutlineButton extends StatelessWidget {
  final String title;
  final Function handleClick;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final double elevation;
  final bool loading;
  final double horizontalPadding;

  const SecondaryOutlineButton(
      {Key key,
        @required this.title,
        @required this.handleClick,
        this.buttonColor = primaryColor,
        this.textColor = primaryColor,
        this.width,
        this.height,
        this.loading = false, this.horizontalPadding = 0, this.elevation = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ButtonTheme(
        minWidth: width ?? 250,
        height: height ?? 55,
        child: RaisedButton(elevation: elevation,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: buttonColor)
          ),

          color: Colors.white,
          child: loading == false ? Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ): Container(height:20,width:20,child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textColor),)),
          onPressed: handleClick,
        ),
      ),
    );
  }
}
