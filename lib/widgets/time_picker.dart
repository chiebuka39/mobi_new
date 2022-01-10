import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi/extras/colors.dart';

class TimePickerWidget extends StatefulWidget {
  final double heightOfAppBar;
  final Size size;
  final AnimationController controller;

  final TimeOfDay timeOfDay;
  final Function setTime;
  final Function handleBackClicked;
  final Function handleTimeChangedAction;

  TimePickerWidget(
      {@required this.heightOfAppBar,
      @required this.size,
      @required this.controller,
      @required this.setTime,
      @required this.handleBackClicked,
      @required this.timeOfDay,
      @required this.handleTimeChangedAction});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget>
    with TickerProviderStateMixin {
  Animation<RelativeRect> rectTimePickerAnimation;

  int _hour;
  int _minute;
  DayPeriod _dayPeriod;

  @override
  void initState() {
    _hour = widget.timeOfDay.hourOfPeriod;
    _minute = widget.timeOfDay.minute;
    _dayPeriod = widget.timeOfDay.period;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstcontainerHeight = widget.heightOfAppBar / 1.9;
    setUpAnimations(widget.size, widget.heightOfAppBar);
    return PositionedTransition(
      child: Material(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        color: Colors.transparent,
        elevation: 3,
        child: SingleChildScrollView(
          child: Container(
            height: widget.heightOfAppBar,
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryColor.shade900,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Column(
              children: <Widget>[
                Container(
                  height: widget.heightOfAppBar / 1.9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            widget.handleBackClicked();
                          },
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Column(
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "Preferred time",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            Text(
                              "For depature",
                              style: TextStyle(
                                  color: secondaryGrey,
                                  fontWeight: FontWeight.w300),
                            ),
                            Spacer(),
                          ],
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: widget.heightOfAppBar - firstcontainerHeight,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Row(
                        children: <Widget>[
                          Spacer(),
                          _buildHourColumn(),
                          SizedBox(width: 4),
                          Text(
                            ":",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(width: 4),
                          _buildMinuteColumn(),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_dayPeriod == DayPeriod.pm) {
                                  _dayPeriod = DayPeriod.am;
                                }
                              });
                              widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
                            },
                            child: Container(
                              height: 45,
                              width: 50,
                              child: Center(
                                  child: Text(
                                "AM",
                                style: _dayPeriod == DayPeriod.pm
                                    ? TextStyle(
                                        color: Colors.black, fontSize: 16)
                                    : TextStyle(
                                        color: Colors.white, fontSize: 16),
                              )),
                              decoration: BoxDecoration(
                                  color: _dayPeriod == DayPeriod.pm
                                      ? Colors.white
                                      : primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3))),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_dayPeriod == DayPeriod.am) {
                                  _dayPeriod = DayPeriod.pm;
                                }
                              });
                              widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
                            },
                            child: Container(
                              height: 45,
                              width: 50,
                              child: Container(
                                height: 45,
                                width: 25,
                                child: Center(
                                    child: Text(
                                  "PM",
                                  style: TextStyle(
                                      color: _dayPeriod == DayPeriod.pm
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                )),
                              ),
                              decoration: BoxDecoration(
                                  color: _dayPeriod == DayPeriod.pm
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3))),
                            ),
                          ),
                          Spacer()
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      rect: rectTimePickerAnimation,
    );
  }

  Column _buildMinuteColumn() {
    return Column(
      children: <Widget>[
        Spacer(),
        InkWell(
          onTap: () {
            setState(() {
              if (_minute == 59) {
                _minute = 0;
              } else {
                _minute += 1;
              }
            });
            widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
          },
          child: Text(
            "+",
            style: TextStyle(color: white, fontSize: 24),
          ),
        ),
        Container(
          height: 45,
          width: 50,
          child: Center(
            child: Text(
                _minute < 10 ? "0${_minute.toString()}" : _minute.toString()),
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3)),
        ),
        InkWell(
            onTap: () {
              setState(() {
                if (_minute == 0) {
                  _minute = 59;
                } else {
                  _minute -= 1;
                }
              });
              widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
            },
            child: Text("-", style: TextStyle(color: white, fontSize: 24))),
        Spacer(),
      ],
    );
  }

  Column _buildHourColumn() {
    return Column(
      children: <Widget>[
        Spacer(),
        InkWell(
            onTap: () {
              setState(() {
                if (_hour == 12) {
                  _hour = 1;
                } else {
                  _hour += 1;
                }
              });
              widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
            },
            child: Text(
              "+",
              style: TextStyle(color: white, fontSize: 24),
            )),
        Container(
          height: 45,
          width: 50,
          child: Center(
            child: Text(_hour < 10 ? "0${_hour.toString()}" : _hour.toString()),
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3)),
        ),
        InkWell(
            onTap: () {
              setState(() {
                if (_hour == 1) {
                  _hour = 12;
                } else {
                  _hour -= 1;
                }
              });
              widget.handleTimeChangedAction(_hour, _minute, _dayPeriod);
            },
            child: Text("-", style: TextStyle(color: white, fontSize: 24))),
        Spacer(),
      ],
    );
  }

  void setUpAnimations(Size size, double heightOfAppBar) {
    rectTimePickerAnimation = new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, 0, 0.0, size.height),
      end: new RelativeRect.fromLTRB(
          0.0, 00.0, 0.0, -(heightOfAppBar - size.height)),
    ).animate(widget.controller);
  }
}
