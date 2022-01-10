import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/app_config.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class AddASocialMediaUrl extends StatefulWidget {
  @override
  _AddASocialMediaUrlState createState() => _AddASocialMediaUrlState();
}

class _AddASocialMediaUrlState extends State<AddASocialMediaUrl> {
  PageController _controller;
  TextEditingController _licenseController;
  bool _validate = false;
  int pageIndex = 0;

  final ProfileRepository _repo = locator<ProfileRepository>();
  UserModel _userModel;

  @override
  void initState() {
    _controller = PageController(initialPage: pageIndex);
    _licenseController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              buildContainerForIntro(),
              buildContainerForInPutingCarLicensePlate(),
            ],
          ),
          Positioned(
            top: MyUtils.buildSizeHeight(10),
            right: MyUtils.buildSizeWidth(5),
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  height: MyUtils.buildSizeWidth(2),
                  width: MyUtils.buildSizeWidth(2),
                  decoration: BoxDecoration(
                      color: pageIndex == 0
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  duration: Duration(microseconds: 300),
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  height: MyUtils.buildSizeWidth(2),
                  width: MyUtils.buildSizeWidth(2),
                  decoration: BoxDecoration(
                      color: pageIndex == 1
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  duration: Duration(milliseconds: 300),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MyUtils.buildSizeHeight(10),
            right: MyUtils.buildSizeWidth(0),
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    animatePageUp();
                  },
                  child: SvgPicture.asset(
                    "assets/img/up.svg",
                    color: pageIndex == 0
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                pageIndex == 1
                    ? FloatingActionButton(
                        onPressed: _upDateUserData,
                        child: Icon(Icons.check),
                        backgroundColor: Colors.greenAccent,
                      )
                    : FlatButton(
                        onPressed: () {
                          animatePage();
                        },
                        child: SvgPicture.asset(
                          "assets/img/down.svg",
                          color: pageIndex == 3
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white,
                        ),
                      )
              ],
            ),
          ),
          Positioned(
            top: MyUtils.buildSizeHeight(5),
            left: MyUtils.buildSizeWidth(2),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }


  Container buildContainerForInPutingCarLicensePlate() {
    return Container(
      width: AppConfig.width,
      height: AppConfig.height,
      decoration: BoxDecoration(color: primaryColor),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MyUtils.buildSizeHeight(12),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Container(
                width: MyUtils.buildSizeWidth(60),
                child: Text(
                  "Enter any of your social media profile Url",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MyUtils.fontSize(6),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: MyUtils.buildSizeHeight(30),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Row(
                children: <Widget>[
                  Text("https:// ", style: TextStyle(fontSize: MyUtils.buildSizeWidth(5), color: Colors.white.withOpacity(0.6)),),
                  Container(
                      width: MyUtils.buildSizeWidth(70),
                      child: TextField(
                        controller: _licenseController,
                        style: TextStyle(
                            color: Colors.white, fontSize: MyUtils.fontSize(5)),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "www.twitter.com/chiebuka39",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: MyUtils.fontSize(5)),
                            errorText: _validate ? "Value Can't be Empty" : null),
                      )),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Text(
                "SOCIAL MEDIA URL",
                style: TextStyle(
                    color: Colors.white, fontSize: MyUtils.fontSize(2.5)),
              ),
            )
          ],
        ),
      ),
    );
  }



  Container buildContainerForIntro() {
    return Container(
      width: AppConfig.width,
      height: AppConfig.height,
      decoration: BoxDecoration(color: primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MyUtils.buildSizeHeight(40),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
            child: Container(
              width: MyUtils.buildSizeWidth(60),
              child: Text(
                "Verify Your Account",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MyUtils.fontSize(6),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: MyUtils.buildSizeHeight(1),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
            child: Container(
              width: MyUtils.buildSizeWidth(70),
              child: Text(
                "To verify your profile, we would need you to input your other social media account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MyUtils.fontSize(3.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MyUtils.buildSizeWidth(6),
                vertical: MyUtils.buildSizeWidth(2)),
            child: Container(
              child: RaisedButton(
                child: Text("Proceed"),
                onPressed: () {
                  animatePage();
                },
                color: Colors.white,
              ),
              width: MyUtils.buildSizeWidth(40),
            ),
          )
        ],
      ),
    );
  }

  void animatePage() {
    if (pageIndex != 1) {
      setState(() {
        pageIndex++;
      });
      animateToPage(pageIndex);
    }
  }

  void animateToPage(int value) {
    _controller.animateToPage(value,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }


  void animatePageUp() {
    if (pageIndex != 0) {
      setState(() {
        pageIndex = pageIndex - 1;
      });
      animateToPage(pageIndex);
    }
  }


  void _upDateUserData() {
    if (_licenseController.text.length < 5) {
      Widgets.showCustomDialog("The profile Url, you inputted is incomplete",
          context, "Incomplete Details", "Close", () {
        Navigator.pop(context);
      });
      setState(() {
        _validate = true;
      });

      animateToPage(1);

      return;
    }


    savingProfileLink();
//    _userModel
//        .updateUserProfileSocialAccounts(
//            _userModel.user, _licenseController.text)
//        .then((result) {
//      if (result['error'] == false) {
//        Widgets.showCustomDialog("You have successfully added a social account",
//            context, "Update Successfull", "Continue", () {
//          Navigator.pop(context);
//          Navigator.pop(context);
//        });
//      } else {
//        Widgets.showCustomDialog(
//            result['detail'], context, "Update failed", "Continue", () {
//          Navigator.pop(context);
//        });
//      }
//    });
  }

  void savingProfileLink() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0, curvedValue * 100, 0),
            child: Opacity(
              opacity: a1.value,
              child: Material(type: MaterialType.transparency, child: LoadingWidget()),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
