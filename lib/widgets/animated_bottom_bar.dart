import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/bar_item.dart';


class AnimatedBottomBarWidget extends StatefulWidget {
  final List<BarItem> barItems;
  final Function onTabSelected;
  final Duration duration;

  AnimatedBottomBarWidget(
      {Key key,
        this.duration = const Duration(milliseconds: 300),
        @required this.barItems,
        @required this.onTabSelected})
      : super(key: key);

  _AnnimatedBottomWidgetState createState() => _AnnimatedBottomWidgetState();
}

class _AnnimatedBottomWidgetState extends State<AnimatedBottomBarWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  int selectedTab = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, MyUtils.fontSize(4), 8, MyUtils.fontSize(4)),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildBarItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();

    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = i == selectedTab;

      _barItems.add(InkWell(
        onTap: () {
          setState(() {
            selectedTab = i;
          });
          widget.onTabSelected(i);
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30)),
          duration: widget.duration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                item.iconSvg == null ?Icon(
                  item.icon,
                  color: isSelected ? primaryColor : Colors.grey,
                ) : SvgPicture.asset("assets/img/${item.iconSvg}.svg", color: isSelected ? primaryColor : Colors.grey,),
                SizedBox(width: 10,),
                AnimatedSize(child: Text(isSelected ? item.text : "", style: TextStyle(color: primaryColor),), duration: widget.duration, vsync: this,)
              ],
            ),
          ),
        ),
      ));
    }
    return _barItems;
  }
}
