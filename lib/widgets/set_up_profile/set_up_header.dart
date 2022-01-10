import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

class SetUpProfileHeaderWidget extends StatelessWidget {
  const SetUpProfileHeaderWidget({
    Key key,
    @required this.visiblePage,
  }) : super(key: key);

  final int visiblePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                      color: visiblePage == 0 ? Colors.white : Colors.white30,
                      borderRadius: BorderRadius.circular(5)),
                  duration: Duration(milliseconds: 300),
                ),
                SizedBox(
                  width: 10,
                ),
                AnimatedContainer(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                        color: visiblePage == 1 ? Colors.white : Colors.white30,
                        borderRadius: BorderRadius.circular(5)),
                    duration: Duration(milliseconds: 300)),
                SizedBox(
                  width: 10,
                ),
                AnimatedContainer(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                        color: visiblePage == 2 ? Colors.white : Colors.white30,
                        borderRadius: BorderRadius.circular(5)),
                    duration: Duration(milliseconds: 300)),
                SizedBox(
                  width: 10,
                ),
                AnimatedContainer(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                        color: visiblePage == 3 ? Colors.white : Colors.white30,
                        borderRadius: BorderRadius.circular(5)),
                    duration: Duration(milliseconds: 300)),
              ],
            )),
      ),
      decoration: BoxDecoration(color: primaryColor),
    );
  }
}
