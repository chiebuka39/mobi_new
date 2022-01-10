import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/locator.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/profile/work_details_screen.dart';
import 'package:mobi/screens/update_profile/add_social.dart';
import 'package:mobi/viewmodels/user_repo.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:mobi/widgets/set_up_profile/company_details.dart';
import 'package:provider/provider.dart';


class PersonalTab extends StatefulWidget {
  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> with AfterLayoutMixin {
  File _image;
  final ProfileRepository _repo = locator<ProfileRepository>();
  UserModel _userModel;
  String _fullName;
  String _email;
  String _workPlace;
  String _jobTitle;
  DrivingState _drivingState;

  bool _loading = false;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _fullName = _userModel.user.fullName;
      _email = _userModel.user.emailAddress;
      _workPlace = _userModel.user.work;
      _drivingState = _userModel.user.drivingState;
      _jobTitle = _userModel.user.jobDesc;
    });
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
          InkWell(
            onTap: _showImagePickerDialog,
            child: Stack(
              children: <Widget>[
                ClipOval(
                  clipper: CircleClipper(),
                  child: _image == null
                      ? CachedNetworkImage(
                    imageUrl: _userModel.user.avatar,
                    height: MyUtils.buildSizeWidth(30),
                    fit: BoxFit.cover,
                    width: MyUtils.buildSizeWidth(30),
                  )
                      : Image.file(_image,
                      height: MyUtils.buildSizeWidth(30),
                      fit: BoxFit.cover,
                      width: MyUtils.buildSizeWidth(30)),
                ),

                Positioned(
                  bottom: 5,
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
          SizedBox(height: 3,),
          Text("Tap to edit"),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              String result = await showDialog(
                  context: context,
                  builder:(c){
                    return NameFormWidget(
                      fullName: _fullName,
                    );
                  });
              if (result != null) {
                setState(() {
                  _fullName = result;
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
                        "Full name",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        _fullName ?? "Chiebuka Edwin",
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
                    return DynamicAlertFormWidget(
                      title: "Email Address",
                      value: _email,
                    );
                  });
              if (result != null) {
                setState(() {
                  _email = result;
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
                        "Email Address",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      _email != null ? Text(
                        _email,
                        style: TextStyle(fontSize: 16),
                      ): Text(
                        "Click to edit",
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkDetailsScreen()));
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
                        "Work place details",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                         "Click to edit",
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              DrivingState result = await showDialog(
                  context: context,
                  builder:(c){
                    return DriveStatusPlaceFormWidget(
                      drivingState: _drivingState,
                    );
                  });

              if (result != null) {
                setState(() {
                  _drivingState = result;
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
                        "Do you drive?",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        _drivingState == DrivingState.Drives ? "Yes":"No",
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
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AddSocialScreen()));
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
                        "Click to add Social Accounts",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
         SizedBox(height: 80,),
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

  void _showImagePickerDialog() {
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
                    getImage(ImageSource.camera);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                new CupertinoDialogAction(
                  child: const Text('Gallery'),
                  isDefaultAction: true,
                  onPressed: () {
                    getImage(ImageSource.gallery);
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
                      getImage(ImageSource.camera);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: new Text('Camera')),
                new FlatButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: new Text('Gallery'))
              ],
            );
          });
    }
  }

  Future getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
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
      _image = croppedFile;
    });
  }

  _saveChanges() {
    if(_userModel.user.fullName != _fullName  ||_userModel.user.emailAddress != _email || _userModel.user.drivingState != _drivingState || _image != null){
      //print("got here");
      User user = User.fromUser(_userModel.user);
      user.drivingState = _drivingState;
      user.jobDesc = _jobTitle;
      user.fullName = _fullName;
      user.emailAddress = _email;

      setState(() {
        _loading = true;
      });

      _repo.updatePersonalDetails(user, _image).then((user2) {
        setState(() {
          _loading = false;
        });
        _userModel.setUser(user2);
        showDialog(context: context, builder: (c){
          return AlertDialog(title: Text("Success", style: TextStyle(fontWeight: FontWeight.bold),),content: Text("You have successfully "
              "saved the changes to your profile"),);
        });
      });
    }
  }
}
