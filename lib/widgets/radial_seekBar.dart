import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

class RadialSeekBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final Widget child;

  const RadialSeekBar(
      {Key key,
        this.trackWidth = 6.0,
        this.trackColor = secondaryGrey,
        this.progressWidth = 8.0,
        this.progressColor = primaryColor,
        this.progressPercent = 0.0,
        @required this.child})
      : super(key: key);
  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: RadialSeekBarPainter(
        progressWidth: widget.progressWidth,
        progressColor: widget.progressColor,
        progressPercent: widget.progressPercent,
        trackColor: widget.trackColor,
        trackWidth: widget.trackWidth,
      ),
      child: widget.child,
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final double progressPercent;
  final Paint progressPaint;

  RadialSeekBarPainter(
      {@required this.trackWidth,
        trackColor,
        @required this.progressWidth,
        progressColor,
        @required this.progressPercent})
      : trackPaint = Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    // paint track
    canvas.drawCircle(center, radius, trackPaint);

    //paint progress

    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        progressAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}