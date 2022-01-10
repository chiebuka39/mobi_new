import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'dart:math' as math;

import 'package:mobi/screens/set_up_your_profile.dart';


class OtpScreen extends StatefulWidget {
  final String countryCode;

  final String phoneNumber;

  OtpScreen({this.phoneNumber = "8161167992", this.countryCode = "+234", Key key}) : super(key:key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var countdownKey = new GlobalKey<RetryCountdownWidgetState>();
  bool retryVisible = false;
  bool isLoading = false;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Image.asset(
                'assets/img/logo2.png',
                height: 150.0,
              ),
              SizedBox(height: 30),
              isLoading
                  ? SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Enter OTP sent to ${widget.countryCode} ${widget.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  SizedBox(height: 50),
                  TextFieldsContainer(
                    onOTPComplete: (otp) {
                      _handleGetStarted();
                    },
                  ),
                  SizedBox(height: 50),
                  new AnimatedOpacity(
                    opacity: retryVisible ? 0.0 : 1.0,
                    duration: _retryOpacityDuration,
                    child: new RetryCountdownWidget(
                      key: countdownKey,
                      onCountdownComplete: onRetryCountdownComplete,
                    ),
                  ),
                  buildResendButton(retryVisible)
                ],
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  _handleGetStarted() async {
    pprint("here");
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SetUpProfile();
    }));
  }



  Widget buildResendButton(bool visible) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: _retryOpacityDuration,
      child: SizedBox(
        width: double.infinity,
        child: FlatButton(
            onPressed: visible ? resendToken : null,
            child: const Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: const Text(
                'Resend it',
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }

  void validatePhone() {}

  void resendToken() {
    setState(() => isLoading = true);
    timer = Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        retryVisible = false;
      });

      countdownKey.currentState?.restartCountdown();
    });
  }

  void onRetryCountdownComplete() => setState(() => retryVisible = true);
}

class RetryCountdownWidget extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  RetryCountdownWidget({Key key, @required this.onCountdownComplete})
      : super(key: key);

  @override
  RetryCountdownWidgetState createState() => new RetryCountdownWidgetState();
}

class RetryCountdownWidgetState extends State<RetryCountdownWidget>
    with SingleTickerProviderStateMixin {
  static const int kStartValue = 31;
  AnimationController _countdownController;
  Animation _countdownAnim;

  @override
  void initState() {
    super.initState();
    _countdownController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    _countdownController.addListener(() => setState(() {}));
    _countdownAnim =
        new StepTween(begin: kStartValue, end: 0).animate(_countdownController);

    _countdownController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownComplete();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _startCountdown());
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Didn\'t receive the OTP in ',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 14),
            children: <TextSpan>[
              TextSpan(
                  text: '${_countdownAnim.value.toString()} seconds',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor)),
              TextSpan(
                  text: '?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor))
            ]),
      ),
    );
  }

  void _startCountdown() {
    if (_countdownController.isAnimating ||
        _countdownController.isCompleted ||
        !mounted) {
      return;
    }
    _countdownController.forward();
  }

  void restartCountdown() {
    if (!mounted) {
      return;
    }
    _countdownController.reset();
    _countdownController.forward();
  }
}

class TextFieldsContainer extends StatefulWidget {
  final ValueChanged<String> onOTPComplete;

  TextFieldsContainer({@required this.onOTPComplete});

  @override
  _TextFieldsContainerState createState() => _TextFieldsContainerState();
}

class _TextFieldsContainerState extends State<TextFieldsContainer> {
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();

  String value1;
  String value2;
  String value3;
  String value4;
  String value5;
  String value6;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _TextField(
          focusNode: focusNode1,
          autoFocus: true,
          valueChanged: (value) {
            this.value1 = value;
            swapFocus(focusNode1, focusNode2);
          },
        ),
        _TextField(
          focusNode: focusNode2,
          valueChanged: (value) {
            this.value2 = value;
            swapFocus(focusNode2, focusNode3);
          },
        ),
        _TextField(
          focusNode: focusNode3,
          valueChanged: (value) {
            this.value3 = value;
            swapFocus(focusNode3, focusNode4);
          },
        ),
        _TextField(
          focusNode: focusNode4,
          valueChanged: (value) {
            this.value4 = value;
            swapFocus(focusNode4, focusNode5);
//            widget.onOTPComplete('$value1$value2$value3$value4$value5$value6');
          },
        ),
        _TextField(
          focusNode: focusNode5,
          valueChanged: (value) {
            this.value5 = value;
            swapFocus(focusNode5, focusNode6);
//            widget.onOTPComplete('$value1$value2$value3$value4$value5$value6');
          },
        ),
        _TextField(
          focusNode: focusNode6,
          valueChanged: (value) {
            this.value6 = value;
            swapFocus(focusNode1, FocusNode());
            widget.onOTPComplete('$value1$value2$value3$value4$value5$value6');
          },
        ),
      ],
    );
  }

  swapFocus(FocusNode oldFocus, FocusNode newFocus) {
    oldFocus.unfocus();
    FocusScope.of(context).requestFocus(newFocus);
  }
}

class _TextField extends StatefulWidget {
  final FocusNode focusNode;
  final ValueChanged<String> valueChanged;
  final bool autoFocus;

  _TextField(
      {@required this.focusNode,
        @required this.valueChanged,
        this.autoFocus = false});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  var controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
      if (hasText()) {
        widget.valueChanged(controller.text);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double inputSize = math.min(40, (MediaQuery.of(context).size.width / 8));
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            width: inputSize,
            height: inputSize,
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                  hasText() ? primaryColor : Colors.transparent,
                  hintText: '*',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                      fontSize: 35),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  focusedBorder: getInputBorder(true),
                  enabledBorder: getInputBorder(),
                ),
                textAlign: TextAlign.center,
                focusNode: widget.focusNode,
                autofocus: widget.autoFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                cursorWidth: 0,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                controller: controller,
              ),
            ),
          ),
        ));
  }

  InputBorder getInputBorder([bool isFocused = false]) {
    return hasText()
        ? OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    )
        : OutlineInputBorder(
      borderSide: isFocused
          ? BorderSide(color: Colors.transparent)
          : BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }

  bool hasText() {
    return controller.text.trim().isNotEmpty;
  }
}

const _retryOpacityDuration = const Duration(seconds: 1);