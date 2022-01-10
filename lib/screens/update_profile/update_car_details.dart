import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/app_config.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class UpdateCarDetails extends StatefulWidget {
  @override
  _UpdateCarDetailsState createState() => _UpdateCarDetailsState();
}

class _UpdateCarDetailsState extends State<UpdateCarDetails> {
  PageController _controller;
  TextEditingController _licenseController;
  TextEditingController _carModelController;
  TextEditingController _carColorController;
  bool _validate = false;
  bool _validateColor = false;
  bool _validateModel = false;
  int pageIndex = 0;
  File _licenseImage;
  File _carImage;
  bool _isLoading = false;

  final ProfileRepository _repo = locator<ProfileRepository>();
  UserModel _userModel;

  @override
  void initState() {
    _controller = PageController(initialPage: pageIndex);
    _licenseController = TextEditingController();
    _carColorController = TextEditingController();
    _carModelController = TextEditingController();
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
              buildContainerForUploadingLicense(),
              buildContainerForUploadingCarPicture()
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
                AnimatedContainer(
                  height: MyUtils.buildSizeWidth(2),
                  width: MyUtils.buildSizeWidth(2),
                  decoration: BoxDecoration(
                      color: pageIndex == 2
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  duration: Duration(milliseconds: 300),
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  height: MyUtils.buildSizeWidth(2),
                  width: MyUtils.buildSizeWidth(2),
                  decoration: BoxDecoration(
                      color: pageIndex == 3
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  duration: Duration(milliseconds: 300),
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
                pageIndex == 3
                    ? Padding(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: _upDateUserData,
                          child: _isLoading == false
                              ? Text(
                                  "Update Info",
                                  style: TextStyle(color: Colors.white),
                                )
                              : SizedBox(
                            height: 30,
                                width: 30,
                                child: CircularProgressIndicator(

                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                              ),
                          color: Colors.greenAccent,
                        ),
                        padding: EdgeInsets.only(right: 10),
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

  Container buildContainerForInPutingCarColor() {
    return Container(
      width: AppConfig.width,
      height: AppConfig.height,
      decoration: BoxDecoration(color: primaryColor),
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
                "A short Description of your car?",
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
            child: Container(
                width: MyUtils.buildSizeWidth(70),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "A Green Honda 2018 model",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: MyUtils.fontSize(7))),
                )),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
            child: Text(
              "VEHICLE COLOR",
              style: TextStyle(
                  color: Colors.white, fontSize: MyUtils.fontSize(2.5)),
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
                  "What are the details of your vehicle?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MyUtils.fontSize(6),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: MyUtils.buildSizeHeight(20),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Container(
                  width: MyUtils.buildSizeWidth(70),
                  child: TextField(
                    controller: _licenseController,
                    style: TextStyle(
                        color: Colors.white, fontSize: MyUtils.fontSize(7)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "LAG45678",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: MyUtils.fontSize(7)),
                        errorText: _validate ? "Value Can't be Empty" : null),
                  )),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Text(
                "VEHICLE LICENSE NUMBER",
                style: TextStyle(
                    color: Colors.white, fontSize: MyUtils.fontSize(2.5)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Container(
                  width: MyUtils.buildSizeWidth(70),
                  child: TextField(
                    controller: _carColorController,
                    style: TextStyle(
                        color: Colors.white, fontSize: MyUtils.fontSize(7)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Black",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: MyUtils.fontSize(7)),
                        errorText: _validateColor ? "Value Can't be Empty" : null),
                  )),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
              child: Text(
                "VEHICLE COLOR",
                style: TextStyle(
                    color: Colors.white, fontSize: MyUtils.fontSize(2.5)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
            padding:
            EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
            child: Container(
            width: MyUtils.buildSizeWidth(70),
            child: TextField(
            controller: _carModelController,
            style: TextStyle(
            color: Colors.white, fontSize: MyUtils.fontSize(7)),
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "BMW 3-SERIES",
            hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: MyUtils.fontSize(7)),
            errorText: _validateModel ? "Value Can't be Empty" : null),
            )),
            ),
            Padding(
    padding:
    EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
    child: Text(
    "VEHICLE Model",
    style: TextStyle(
    color: Colors.white, fontSize: MyUtils.fontSize(2.5)),
    ),
    )
          ],
        ),
      ),
    );
  }

  Widget buildContainerForUploadingLicense() {
    return AnimatedContainer(
      width: AppConfig.width,
      height: AppConfig.height,
      decoration: BoxDecoration(color: primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MyUtils.buildSizeHeight(_licenseImage == null ? 40 : 30),
          ),
          _licenseImage == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(6)),
                      child: Container(
                        width: MyUtils.buildSizeWidth(60),
                        child: Text(
                          "Upload Drivers License",
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
                      padding: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(6)),
                      child: Container(
                        width: MyUtils.buildSizeWidth(70),
                        child: Text(
                          "For Safety of both driver patners and riders and strict adherence to the nation laws we would need to verify that you have a valid Drivers license",
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
                          child: Text("Upload License",
                              style:
                                  TextStyle(fontSize: MyUtils.fontSize(3.5))),
                          onPressed: () {
                            _showImagePickerDialog(1);
                          },
                          color: Colors.white,
                        ),
                        width: MyUtils.buildSizeWidth(40),
                      ),
                    )
                  ],
                )
              : buildLicenseImageWidget("Drivers Licence", _licenseImage, () {
                  setState(() {
                    _licenseImage = null;
                  });
                }),
        ],
      ),
      duration: Duration(milliseconds: 300),
    );
  }

  Container buildContainerForUploadingCarPicture() {
    return Container(
      width: AppConfig.width,
      height: AppConfig.height,
      decoration: BoxDecoration(color: primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MyUtils.buildSizeHeight(_carImage == null ? 40 : 30),
          ),
          _carImage == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(6)),
                      child: Container(
                        width: MyUtils.buildSizeWidth(60),
                        child: Text(
                          "Take a picture of your Personal Car",
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
                      padding: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(6)),
                      child: Container(
                        width: MyUtils.buildSizeWidth(70),
                        child: Text(
                          "This helps riders spot your car easily, and saves time spent to locate your car",
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
                          child: Text(
                            "Upload Car picture",
                            style: TextStyle(fontSize: MyUtils.fontSize(3.5)),
                          ),
                          onPressed: () {
                            _showImagePickerDialog(2);
                          },
                          color: Colors.white,
                        ),
                        width: MyUtils.buildSizeWidth(40),
                      ),
                    )
                  ],
                )
              : buildLicenseImageWidget("Car Image", _carImage, () {
                  setState(() {
                    _carImage = null;
                  });
                }),
        ],
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
                "Our verification process involves uploading some crucial documents",
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
    if (pageIndex != 3) {
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

  Future getLicenseImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    print("here");
    setState(() {
      _licenseImage = File(pickedFile.path);
    });
  }

  Future getCarImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    print("here");
    setState(() {
      _carImage = File(pickedFile.path);
    });
  }

  void animatePageUp() {
    if (pageIndex != 0) {
      setState(() {
        pageIndex = pageIndex - 1;
      });
      animateToPage(pageIndex);
    }
  }

  Padding buildLicenseImageWidget(
      String title, File image, Function deleteClicked) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 200,
        width: 400,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: deleteClicked,
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _upDateUserData() {
    if (_isLoading == true) {
      return;
    }
    if (_licenseController.text.length != 8 || _carModelController.text.length <3 || _carColorController.text.length < 3
    ) {
      Widgets.showCustomDialog("One or more of your Car deatails inputted is incorrect",
          context, "Incomplete Details", "Close", () {
            Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        if(_licenseController.text.length != 8){
          _validate = true;
        }
        if(_carModelController.text.length <3){
          _validateModel = true;
        }
        if(_carColorController.text.length <3){
          _validateColor = true;
        }

      });


      animateToPage(1);

      return;
    }

    if (_licenseImage == null) {
      Widgets.showCustomDialog(
          "You have not added a picture of your vehicle license",
          context,
          "Incomplete Details",
          "Close", () {
        Navigator.of(context, rootNavigator: true).pop();
      });
      animateToPage(2);
      return;
    }

    if (_carImage == null) {
      Widgets.showCustomDialog(
          "You need to add a picture of your "
              "vehicle to enable others recognize your car easily",
          context,
          "Incomplete Details",
          "Close", () {
        Navigator.of(context, rootNavigator: true).pop();
      });
      animateToPage(3);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _userModel
        .updateUserCarDetails(
            _userModel.user, _licenseController.text, _carColorController.text, _carModelController.text,_licenseImage, _carImage)
        .then((result) {
      setState(() {
        _isLoading = false;
      });
      if (result['error'] == false) {
        Widgets.showCustomDialog("You have successfully added your car details",
            context, "Update Successfull", "Continue", () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
        });
      } else {
        Widgets.showCustomDialog(
            result['detail'], context, "Update failed", "Continue", () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
    });
  }

  void _showImagePickerDialog(int action) {
    var content = new Text('Select Image from gallery or camera');
    if (Platform.isIOS) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new CupertinoAlertDialog(
              content: content,
              actions: <Widget>[
                new CupertinoDialogAction(
                  child: const Text('Camera'),
                  isDestructiveAction: true,
                  onPressed: () {
                    action == 1
                        ? getLicenseImage(ImageSource.camera)
                        : getCarImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                new CupertinoDialogAction(
                  child: const Text('Gallery'),
                  isDefaultAction: true,
                  onPressed: () {
                    action == 1
                        ? getLicenseImage(ImageSource.gallery)
                        : getCarImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              content: content,
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      action == 1
                          ? getLicenseImage(ImageSource.camera)
                          : getCarImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: new Text('Camera')),
                new FlatButton(
                    onPressed: () {
                      action == 1
                          ? getLicenseImage(ImageSource.gallery)
                          : getCarImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: new Text('Gallery'))
              ],
            );
          });
    }
  }
}
