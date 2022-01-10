import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

class DatePicker extends StatefulWidget {
  final double heightOfAppBar;
  final Size size;
  final AnimationController controller;
  final Function setDate;
  final Function handleBackClicked;

  DatePicker(
      {@required this.heightOfAppBar,
      @required this.size,
      @required this.controller,
      @required this.setDate,
      @required this.handleBackClicked});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with TickerProviderStateMixin {
  Animation<RelativeRect> rectAnimation;

  bool showing = false;

  List<DateTime> selectableDates;
  List<bool> selectedDates = [true, false, false, false, false, false];

  @override
  void initState() {
    selectableDates = get5Extradays(DateTime.now());

    super.initState();
  }

  List<DateTime> get5Extradays(DateTime day) {
    List<DateTime> days = [];

    days.add(day);
    for (int i = 1; i <= 5; i++) {
      days.add(day.add(Duration(days: i)));
    }

    return days;
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
                              "Change Date",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            Text(
                              "Ride date",
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
                      return Column(
                        children: <Widget>[
                          Spacer(),
                          Container(
                            height: constraints.minHeight / 1.5,
                            child: ListView.builder(
                              itemBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: InkWell(
                                      onTap: () {
                                        _setIndexToClicked(index);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          AnimatedContainer(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                                color:
                                                    selectedDates[index] == true
                                                        ? white
                                                        : Colors.transparent,
                                                shape: BoxShape.circle),
                                            duration:
                                                Duration(milliseconds: 200),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${selectableDates[index].day} ",
                                            style: selectedDates[index] == true
                                                ? TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40)
                                                : TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    fontSize: 40,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              scrollDirection: Axis.horizontal,
                              itemCount: selectableDates.length,
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
      rect: rectAnimation,
    );
  }

  void setUpAnimations(Size size, double heightOfAppBar) {
    rectAnimation = new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, 0, 0.0, size.height),
      end: new RelativeRect.fromLTRB(
          0.0, 00.0, 0.0, -(heightOfAppBar - size.height)),
    ).animate(widget.controller);
  }

  void _setIndexToClicked(int index) {
    setState(() {
      for (int i = 0; i < selectedDates.length; i++) {
        selectedDates[i] = false;
      }
      selectedDates[index] = true;
      widget.setDate(selectableDates[index]);
    });
  }
}
