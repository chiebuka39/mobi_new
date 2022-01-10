import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with TickerProviderStateMixin {
  AnimationController _rotateController;
  AnimationController _scaleController;
  Animation _rotateAnimation;
  Animation _scaleAnimation;

  UserModel _userModel;

  @override
  void initState() {
    _rotateController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _rotateController.addStatusListener(_rotateStatusChange);
    _scaleController.addStatusListener(_scaleStatusChange);
    _rotateAnimation =
        CurvedAnimation(parent: _rotateController, curve: Curves.fastOutSlowIn);
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.fastOutSlowIn);
    _rotateController.forward();
    _scaleController.forward();
    scheduleNavigationToDashboard();
    super.initState();
  }

  @override
  void dispose() {
    _rotateController.removeStatusListener(_rotateStatusChange);
    _scaleController.removeStatusListener(_scaleStatusChange);
    _rotateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Processing...',
                      style: TextStyle(
                          color: thirdColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Funding your wallet at the moment',
                      style: TextStyle(color: thirdColor),
                    )
                  ],
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(_scaleAnimation),
                child: RotationTransition(
                    turns: _rotateAnimation,
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/img/circular_loader.svg')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async => false;

  void _rotateStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _rotateController.reset();
      _rotateController.forward();
    }
  }

  void _scaleStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _scaleController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _scaleController.forward();
    }
  }

  void scheduleNavigationToDashboard() {
//    Timer(Duration(seconds: 2), () {
//      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) {
//        return Theme(
//            data: Theme.of(context).copyWith(canvasColor: Colors.green),
//            child: FundingSuccessfulWidget());
//      }), (Route<dynamic> route) => false);
//    });
  }
}