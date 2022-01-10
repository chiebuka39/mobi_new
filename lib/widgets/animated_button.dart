import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final String initialText, finalText;
  final ButtonStyle buttonStyle;
  final IconData iconData;
  final double iconSize;
  final Duration animationDuration;
  final Function handleOnclick;
  final TickerProvider ticker;

  AnimatedButton(
      {this.initialText,
      this.finalText,
      this.iconData,
      this.buttonStyle,
        @required this.currentState,
        this.handleOnclick,
        @required this.ticker,
      this.animationDuration,
      this.iconSize});


  final ButtonState currentState;



  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: buttonStyle.elevation,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: iconSize + 16,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        color: buttonStyle.primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedSize(
              child: (currentState == ButtonState.SHOW_ONLY_TEXT) ? Container() :
              Icon(
                iconData,
                size: iconSize,
                color: buttonStyle.secondaryColor,
              ), vsync: ticker, duration: Duration(milliseconds: 300),
            ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: (currentState == ButtonState.SHOW_ONLY_TEXT) ?
              Text(initialText,style: buttonStyle.initialTextStyle ,) : Container(), vsync: ticker,
          )
          ],
        ),
      ),
    );
  }


}

class ButtonStyle {
  final TextStyle initialTextStyle, finalTextStyle;
  final Color primaryColor, secondaryColor;
  final double elevation;

  ButtonStyle(
      {this.primaryColor,
      this.finalTextStyle,
      this.initialTextStyle,
      this.secondaryColor,
      this.elevation});
}

enum ButtonState { SHOW_ONLY_ICON, SHOW_ONLY_TEXT, SHOW_ICON_TEXT }
