import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/car_form_widgets.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/primary_button.dart';
 
import 'package:provider/provider.dart';

class CarDetailsTab extends StatefulWidget {
  @override
  _CarDetailsTabState createState() => _CarDetailsTabState();
}

class _CarDetailsTabState extends State<CarDetailsTab> with AfterLayoutMixin {
  File _carImage;
  File _licenseImage;
  final ProfileRepository _repo = locator<ProfileRepository>();
  UserModel _userModel;
  String _carRegNo;
  String _carColor;
  String _carModel;

  bool _loading = false;

  @override
  void afterFirstLayout(BuildContext context) {
    if (mounted) {
      setState(() {
        _carRegNo = _userModel.user.carDetails.plateNumber;
        _carColor = _userModel.user.carDetails.carColor;
        _carModel = _userModel.user.carDetails.carModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _showImagePickerDialog("license");
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: _userModel.user.carDetails.licenseImageUrl ==
                                        null &&
                                    _licenseImage == null
                                ? Container(
                                    height: MyUtils.buildSizeWidth(30),
                                    width: MyUtils.buildSizeWidth(30),
                                    decoration: BoxDecoration(
                                        color: secondaryGrey,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                : _licenseImage == null
                                    ? CachedNetworkImage(
                                        imageUrl: _userModel
                                            .user.carDetails.licenseImageUrl,
                                        height: MyUtils.buildSizeWidth(30),
                                        fit: BoxFit.cover,
                                        width: MyUtils.buildSizeWidth(30),
                                      )
                                    : Image.file(_licenseImage,
                                        height: MyUtils.buildSizeWidth(30),
                                        fit: BoxFit.cover,
                                        width: MyUtils.buildSizeWidth(30)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("Drivers Licence")
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _showImagePickerDialog("car");
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: _userModel.user.carDetails.carImageUrl ==
                                        null &&
                                    _carImage == null
                                ? Container(
                                    height: MyUtils.buildSizeWidth(30),
                                    width: MyUtils.buildSizeWidth(30),
                                    decoration: BoxDecoration(
                                        color: secondaryGrey,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                : _carImage == null
                                    ? CachedNetworkImage(
                                        imageUrl: _userModel
                                            .user.carDetails.carImageUrl,
                                        height: MyUtils.buildSizeWidth(30),
                                        fit: BoxFit.cover,
                                        width: MyUtils.buildSizeWidth(30),
                                      )
                                    : Image.file(_carImage,
                                        height: MyUtils.buildSizeWidth(30),
                                        fit: BoxFit.cover,
                                        width: MyUtils.buildSizeWidth(30)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("Vehicle Picture")
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              String result = await showDialog(
                  context: context,
                  builder: (c){
                   return RegNumberFormWidget(
                      regNum: _carRegNo,
                    );
                  });
              if (result != null) {
                setState(() {
                  _carRegNo = result;
                });
              }
            },
            child: Material(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: secondaryGrey),
                        bottom: BorderSide(color: secondaryGrey))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Car Registration No",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        _carRegNo ?? "",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String result = await showDialog(
                  context: context,
                  builder:(c){
                    return CarModelFormWidget(
                      carModel: _carModel,
                    );
                  });
              if (result != null) {
                setState(() {
                  _carModel = result;
                });
              }
            },
            child: Material(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: secondaryGrey))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Car Model",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        _carModel ?? "",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String result = await showDialog(
                  context: context,
                  builder: (c){
                    return CarColorFormWidget(
                      carColor: _carColor,
                    );
                  });
              if (result != null) {
                setState(() {
                  _carColor = result;
                });
              }
            },
            child: Material(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: secondaryGrey))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Car Color",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        _carColor ?? "",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          SecondaryButton(
            handleClick: _saveChanges,
            title: "save changes".toUpperCase(),
            width: double.infinity,
            horizontalPadding: 20,
            loading: _loading,
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(String type) {
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
                  onPressed: () {
                    getImage(ImageSource.camera, type);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                new CupertinoDialogAction(
                  child: const Text('Gallery'),
                  isDefaultAction: true,
                  onPressed: () {
                    getImage(ImageSource.gallery, type);
                    Navigator.of(context, rootNavigator: true).pop();
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
                      getImage(ImageSource.camera, type);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: new Text('Camera')),
                new FlatButton(
                    onPressed: () {
                      getImage(ImageSource.gallery, type);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: new Text('Gallery'))
              ],
            );
          });
    }
  }

  Future getImage(ImageSource imageSource, String type) async {
    var picked =
        await ImagePicker().getImage(source: imageSource, imageQuality: 85);
    var image = File(picked.path);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings());
    print("here");
    setState(() {
      if (type == "license") {
        _licenseImage = croppedFile;
      } else {
        _carImage = croppedFile;
      }
    });
  }

  _saveChanges() {
    if (_userModel.user.carDetails.carColor != _carColor ||
        _userModel.user.carDetails.carModel != _carModel ||
        _userModel.user.carDetails.plateNumber != _carRegNo ||
        _carImage != null ||
        _licenseImage != null) {
      setState(() {
        _loading = true;
      });
      _userModel
          .updateUserCarDetails(
        _userModel.user,
        _carRegNo,
        _carColor,
        _carModel,
        _licenseImage,
        _carImage,
      )
          .then((result) {
        setState(() {
          _loading = false;
        });
        if (result['error'] == false) {
          Widgets.showCustomDialog(
              "You have successfully added your car details",
              context,
              "Update Successfull",
              "Continue", () {
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
    } else {
      showSimpleNotification(Text("You have not mad any changes yet"),
          background: Colors.red,
          contentPadding: EdgeInsets.only(left: 30, right: 30));
    }
  }
}
