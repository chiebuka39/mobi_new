import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/api/profile_api.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/message_handler.dart' as MessageHandler1;
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart' as u;
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/set_locations.dart';
import 'package:mobi/screens/set_up_your_profile.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
 
import 'package:provider/provider.dart';

import '../locator.dart';
import 'home_screen_2.dart';

class SignInScreen extends StatefulWidget {
  final ScheduledRide scheduledRide;

  const SignInScreen({Key key, this.scheduledRide}) : super(key: key);
  static Route<dynamic> route({ScheduledRide scheduledRide}) {
    return MaterialPageRoute(
        builder: (_) => SignInScreen(scheduledRide: scheduledRide,),
        settings: RouteSettings(name: SignInScreen().toStringShort()));
  }
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  PageController _pageController = PageController();

  final GlobalKey<FormState> _verifFormKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String _number = "";
  String _verificationNumber;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;

  final ProfileApi _api = locator<ProfileApi>();
  UserModel _userModel;
  RidesViewModel _ridesViewModel;

  Timer _timer;
  int _start = 120;
  bool _visibillity = true;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _timer = null;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    //MyUtils.initDynamicLinks();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    pprint("height: ${size.height} - width: ${size.width}");
    _userModel = Provider.of<UserModel>(context);
    _ridesViewModel = Provider.of<RidesViewModel>(context);
    MyUtils.setUpAppConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _enterPhoneNumberScreen(size),
          _otpScreen(size),

        ],
      ),
    );
  }

  SingleChildScrollView _enterPhoneNumberScreen(Size size) {
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(
              child: SvgPicture.asset("assets/img/logo1.svg"),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Car pooling for workplace commutes and inter-state travels",
                style: TextStyle(
                    fontSize: MyUtils.fontSize(4.5),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Form(
              autovalidate: _autoValidate,
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyUtils.fontSize(8)),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: _validatePhoneNumber,
                      onSaved: (value) {
                        setState(() {
                          _number = value;
                        });
                      }, //1351022029
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Phone Number"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyUtils.fontSize(8)),
                    child: Text(
                      "Your phone number is required for you to login, an example is 0810000----",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyUtils.fontSize(8)),
                    child: ButtonTheme(
                      height: 50,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: RaisedButton(
                          color: primaryColor,
                          onPressed: _handleSubmitted,
                          child: Text(
                            "Login with Phone number",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget _otpScreen(Size size) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Hello, We would need you to enter the Verification number sent to your phone $_number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ),
            Spacer(),
            Form(
              autovalidate: _autoValidate,
              key: _verifFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: _validateVerifCode,
                      onSaved: (value) {
                        _verificationNumber = value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Verification code"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Opacity(
                    opacity: _visibillity == true ?1:0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _timer != null
                          ? Text(
                              "Resend code in $_start",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text.rich(
                              TextSpan(children: [
                                TextSpan(text: "Did't recieve OTP? "),
                                TextSpan(
                                    text: "RESEND OTP",
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {

                                      _loginWithPhoneNumber();
                                      setState(() {
                                        _visibillity = false;
                                      });
                                      showSimpleNotification(
                                          Text("Token has been resent to your phone"),
                                          background: Colors.green);
                                      },
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ButtonTheme(
                      height: 50,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: RaisedButton(
                          color: primaryColor,
                          onPressed: _handleSubmittedCodes,
                          child: _isLoading == true
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  "Verify",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() async {
    if (mounted == false) {
      return;
    }

    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in pink before submitting.');
    } else {
      form.save();
      _pageController.animateToPage(1,
          duration: new Duration(milliseconds: 600), curve: Curves.easeIn);
      print("+234${_number.substring(1)}");
      _loginWithPhoneNumber();
      print("no error");
    }
  }

  void _loginWithPhoneNumber() {
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      print("code sent to " + _number);
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: ');
      _firebaseAuth.signInWithCredential(credential).then((result) {
        _startProfileCreationPage(result.user);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+234${_number.substring(1)}",
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("time out");
        });
    startTimer();
  }

  String _validatePhoneNumber(String value) {
    if (value == null || value.isEmpty || value.length != 11)
      return 'Please enter a Valid phone number';
    return null;
  }

  String _validateVerifCode(String value) {
    if (value == null || value.isEmpty || value.length != 6)
      return 'Please enter a Valid Verification code';
    return null;
  }

  void _handleSubmittedCodes() async {
    if (mounted == false) {
      return;
    }

    final FormState form = _verifFormKey.currentState;

    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in pink before submitting.');
    } else {
      setState(() {
        _isLoading = true;
      });
      form.save();
      _timer.cancel();
      var user =
          await _signInWithPhoneNumber(_verificationNumber, _verificationId);

      _startProfileCreationPage(user);
    }
  }

  Future<User> _signInWithPhoneNumber(
      String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    final User currentUser =  result.user;
    assert(result.user.uid == currentUser.uid);

    return currentUser;
  }

  void _startProfileCreationPage(User user) async {
    u.User newUser = await _userModel.getUser(user.phoneNumber);

    if (newUser == null) {

      setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SetUpProfile(ride: widget.scheduledRide,)),
          (Route<dynamic> route) => false);
    } else if (newUser.homeLocation.title == null) {
      MaterialPageRoute(builder: (context) => SetLocationsScreen());
    } else {
      await _ridesViewModel.getActiveRidesAndSave(newUser.phoneNumber);
      _fcm.subscribeToTopic(newUser.phoneNumber.substring(1));
      setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MessageHandler1.MessageHandler(
                    child: HomeTabs(),
                  )),
          (Route<dynamic> route) => false);
    }
  }
}
