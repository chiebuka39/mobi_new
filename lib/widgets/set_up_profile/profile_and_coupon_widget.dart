import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/widgets/primary_button.dart';

class UploadProfile extends StatefulWidget {
  final ReceiveFile onPressed;

  const UploadProfile({Key key, this.onPressed}) : super(key: key);
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  File _file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            "Add your profile photo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 290,
            child: Text(
              "Adding a real picture increases the chance of you getting rides ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: _file == null
                ? Image.asset(
                    "assets/img/gravatar.png",
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  )
                : Image.file(
                    _file,
                    height: 80,
                    width: 80,
                  ),
          ),
          SizedBox(height: 15,),
          FlatButton(
            color: primaryColor,
            child: Text(
              "Choose Image",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _showImagePickerDialog();
            },
          ),
          Spacer(),
          SecondaryButton(handleClick: (){
            if(_file != null){
              widget.onPressed(_file);
            }else{
              showSimpleNotification(Text("You need to add a profile picture"),background: Colors.red);
            }


          }, title: "Create Profile".toUpperCase(),
            width: double.infinity,
          ),
          SizedBox(height: 20,),
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
    final pickedFile = await picker.getImage(source:imageSource);

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
    pprint("here");
    setState(() {
      _file = croppedFile;
    });
  }

}


typedef ReceiveFile<T> = void Function(File value);
