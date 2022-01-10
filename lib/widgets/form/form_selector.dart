import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobi/extras/colors.dart';

class FormSelector extends StatelessWidget {
  final String title;
  final String desc;
  final Function onPressed;
  final bool showTopBorder;
  const FormSelector({
    Key key,
    @required String value,
    this.title,
    this.desc,
    this.onPressed,
    this.showTopBorder = false,
  })  : _date = value,
        super(key: key);

  final String _date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(
                  top: showTopBorder == true
                      ? BorderSide(color: secondaryGrey)
                      : BorderSide(color: Colors.transparent),
                  bottom: BorderSide(color: secondaryGrey))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                _date == null
                    ? Text(
                        desc,
                        style: TextStyle(
                            fontWeight: FontWeight.w200, fontSize: 12),
                      )
                    : Text(
                        _date,
                        style: TextStyle(fontSize: 16),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormSelectorSecondary extends StatelessWidget {
  final Widget title;
  final Widget desc;
  final Function onPressed;
  final bool showTopBorder;
  const FormSelectorSecondary({
    Key key,
    @required String value,
    this.title,
    this.desc,
    this.onPressed,
    this.showTopBorder = false, this.content,
  })  :
        super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(
                  top: showTopBorder == true
                      ? BorderSide(color: secondaryGrey)
                      : BorderSide(color: Colors.transparent),
                  bottom: BorderSide(color: secondaryGrey))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                title,
                Spacer(),
                content == null
                    ? desc : content,

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingsSelector extends StatelessWidget {
  final String title;
  final double ratings;
  final Function onPressed;
  final bool showTopBorder;
  const RatingsSelector({
    Key key,
    this.title,
    this.ratings,
    this.onPressed,
    this.showTopBorder = false,
  })  :
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(
                  top: showTopBorder == true
                      ? BorderSide(color: secondaryGrey)
                      : BorderSide(color: Colors.transparent),
                  bottom: BorderSide(color: secondaryGrey))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                RatingBar(
                  itemSize: 15,
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),

                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                  ratingWidget: RatingWidget(
                    empty: Icon(
                  Icons.star,
                  color: Colors.white,
                ), full: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ), half: Icon(
                    Icons.star,
                    color: Colors.amber,
                  )

                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
