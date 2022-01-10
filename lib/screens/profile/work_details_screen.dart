import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class WorkDetailsScreen extends StatefulWidget {
  @override
  _WorkDetailsScreenState createState() => _WorkDetailsScreenState();
}

class _WorkDetailsScreenState extends State<WorkDetailsScreen> with AfterLayoutMixin<WorkDetailsScreen> {
  String _workPlace;
  String _jobTitle;
  UserModel _userModel;
  bool _loading = false;

  File _workId;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _jobTitle = _userModel.user.jobDesc;
      _workPlace = _userModel.user.work;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Edit Work Details", style:
        TextStyle(
            color: Colors.black, fontSize: 16,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
        Row(
          children: <Widget>[
            SizedBox(width: 20,),
            InkWell(
              onTap: _showImagePickerDialog,
              child: _workId == null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                imageUrl: _userModel
                      .user.workIdentityUrl.isEmpty ?
                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y':_userModel.user.workIdentityUrl,
                height: MyUtils.buildSizeWidth(30),
                fit: BoxFit.cover,
                width: MyUtils.buildSizeWidth(30),
              ),
                  )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                    child: Image.file(_workId,
                    height: MyUtils.buildSizeWidth(30),
                    fit: BoxFit.cover,
                    width: MyUtils.buildSizeWidth(30)),
                  ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,top: 20),
          child: Text("Click to upload your work identification"),
        ),
        InkWell(
          onTap: () async {
            String result = await showDialog(
                context: context,
                builder:(c){
                  return  WorkPlaceFormWidget(
                    workPlace: _workPlace,
                  );
                });

            if (result != null) {
              setState(() {
                _workPlace = result;
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
                      "Work place",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      _workPlace ?? "Click to add place of work",
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
                  return JobRolePlaceFormWidget(
                    jobRole: _jobTitle,
                  );
                });

            if (result != null) {
              setState(() {
                _jobTitle = result;
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
                      "Job role",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      _jobTitle ?? "Click to add Job Role",
                      style: TextStyle(fontSize: 16),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
          Spacer(),
          SecondaryButton(title: "Save Changes",
            handleClick: _saveChanges,horizontalPadding: 20,width: double.infinity,loading: _loading,),
          SizedBox(height: 40,)
      ],),
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
      _workId = croppedFile;
    });
  }

  _saveChanges() {
    if(_userModel.user.work != _workPlace
        || _userModel.user.jobDesc != _jobTitle || _workId != null){
      //print("got here");
      User user = User.fromUser(_userModel.user);
      user.work = _workPlace;
      user.jobDesc = _jobTitle;

      setState(() {
        _loading = true;
      });

      _userModel.updateWorkDetails(_workId, user,"workId").then((result) {
        if(result.error != true){
          setState(() {
            _loading = false;
          });
          _userModel.setUser(result.data);
          showDialog(context: context, builder:(c){
            return AlertDialog(title: Text("Success", style: TextStyle(fontWeight: FontWeight.bold),),content: Text("You have successfully "
                "saved the changes to your profile"),);
          });
        }else{
          showDialog(context: context, builder:(c){
            return AlertDialog(title: Text("Error", style: TextStyle(fontWeight: FontWeight.bold),),content: Text("You have successfully "
                "Could not Update your work details"),);
          });
        }

      });
    }
  }

}
