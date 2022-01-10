import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/screens/update_profile/add_social.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/radial_seekBar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel _userModel;
  PageController _pageController;
  int pageNumber = 0;

  File _image;

  @override
  void initState() {
    _pageController =
        PageController(initialPage: pageNumber, viewportFraction: 0.85);
    _pageController.addListener(() {
      if (_pageController.page == 1) {
        setState(() {
          pageNumber = 1;
        });
      } else if (_pageController.page == 0) {
        setState(() {
          pageNumber = 0;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 2,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(MyUtils.buildSizeWidth(15))),
                child: Container(
                  height: MyUtils.buildSizeHeight(40),
                  width: MyUtils.buildSizeWidth(100),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight:
                              Radius.circular(MyUtils.buildSizeWidth(15)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MyUtils.buildSizeHeight(5),
                      ),
                      Row(
                        children: <Widget>[
                          BackButton(
                            color: Colors.black,
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _userModel.user.fullName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MyUtils.fontSize(5)),
                              ),
                              Text(
                                "17 total rides",
                                style: TextStyle(fontSize: MyUtils.fontSize(3)),
                              ),
                            ],
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MyUtils.buildSizeHeight(6),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MyUtils.buildSizeWidth(0)),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: _showImagePickerDialog,
                                  child: Stack(
                                    children: <Widget>[
                                      ClipOval(
                                        clipper: CircleClipper(),
                                        child: _image == null
                                            ? CachedNetworkImage(
                                                imageUrl: _userModel.user.avatar,
                                                height:
                                                    MyUtils.buildSizeWidth(30),
                                                fit: BoxFit.cover,
                                                width:
                                                    MyUtils.buildSizeWidth(30),
                                              )
                                            : Image.file(_image,
                                                height:
                                                    MyUtils.buildSizeWidth(30),
                                                fit: BoxFit.cover,
                                                width:
                                                    MyUtils.buildSizeWidth(30)),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle),
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
                                SizedBox(
                                  height: MyUtils.buildSizeHeight(1.5),
                                ),
                                FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                      _userModel.user.verified == false
                                          ? "Not Verified"
                                          : "Verified",
                                      style: TextStyle(
                                          color:
                                              _userModel.user.verified == false
                                                  ? Colors.redAccent
                                                  : Colors.green)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MyUtils.buildSizeWidth(0)),
                            child: Column(
                              children: <Widget>[
                                RadialSeekBar(
                                  progressPercent: 0.3,
                                  child: Container(
                                      height: MyUtils.buildSizeWidth(30),
                                      width: MyUtils.buildSizeWidth(30),
                                      child: Center(
                                        child: Text(
                                          "6",
                                          style: TextStyle(
                                              fontSize:
                                                  MyUtils.buildSizeWidth(6),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      )),
                                ),
                                SizedBox(
                                  height: MyUtils.buildSizeHeight(1.5),
                                ),
                                Text("* Rides this week")
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MyUtils.buildSizeHeight(6),
              ),
              Container(
                width: MyUtils.buildSizeWidth(100),
                height: MyUtils.buildSizeHeight(20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: MyUtils.buildSizeWidth(5),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddSocialScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(MyUtils.buildSizeWidth(3)),
                        height: MyUtils.buildSizeHeight(20),
                        width: MyUtils.buildSizeWidth(35),
                        decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            SvgPicture.asset(
                              "assets/img/social.svg",
                              height: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Social Accounts",
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MyUtils.buildSizeWidth(5),
                    ),
                    Container(
                      padding: EdgeInsets.all(MyUtils.buildSizeWidth(3)),
                      height: MyUtils.buildSizeHeight(20),
                      width: MyUtils.buildSizeWidth(35),
                      decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Spacer(),
                          SvgPicture.asset("assets/img/avatar.svg"),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${_userModel.connections.length} Connections",
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MyUtils.buildSizeWidth(5),
                    ),
                    Container(
                      padding: EdgeInsets.all(MyUtils.buildSizeWidth(3)),
                      height: MyUtils.buildSizeHeight(20),
                      width: MyUtils.buildSizeWidth(35),
                      decoration: BoxDecoration(
                          color: forthColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: MyUtils.buildSizeHeight(2),
                                width: MyUtils.buildSizeWidth(20),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Text(
                                    "Home Location",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MyUtils.buildSizeWidth(2)),
                                  ),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                          Spacer(),
                          SvgPicture.asset("assets/img/location.svg"),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            MyUtils.getShortenedLocation(
                                _userModel.user.homeLocation.title, 30),
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MyUtils.buildSizeWidth(5),
                    ),
                    Container(
                      padding: EdgeInsets.all(MyUtils.buildSizeWidth(3)),
                      height: MyUtils.buildSizeHeight(20),
                      width: MyUtils.buildSizeWidth(35),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: MyUtils.buildSizeHeight(2),
                                width: MyUtils.buildSizeWidth(20),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Text(
                                    "Work Location",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MyUtils.buildSizeWidth(2)),
                                  ),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                          Spacer(),
                          SvgPicture.asset("assets/img/location.svg"),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            MyUtils.getShortenedLocation(
                                _userModel.user.workLocation.title, 25),
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MyUtils.buildSizeHeight(5),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: MyUtils.buildSizeWidth(5)),
                    child: Text(
                      "Badges",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MyUtils.buildSizeWidth(5)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MyUtils.buildSizeHeight(2),
              ),
              Container(
                height: MyUtils.buildSizeHeight(15),
                width: MyUtils.buildSizeWidth(100),
                color: Colors.transparent,
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(2)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Friendly Commuter",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("3/5")
                              ],
                            ),
                            SizedBox(
                              height: MyUtils.buildSizeHeight(2),
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MyUtils.buildSizeWidth(70),
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                Container(
                                  width: getPercentWidth(50),
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MyUtils.buildSizeWidth(2)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Time Maverick",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("1/5")
                              ],
                            ),
                            SizedBox(
                              height: MyUtils.buildSizeHeight(2),
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MyUtils.buildSizeWidth(70),
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                Container(
                                  width: getPercentWidth(50),
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageNumber == 0
                            ? Colors.blueAccent
                            : Colors.blueAccent.withOpacity(0.4)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageNumber == 1
                            ? Colors.blueAccent
                            : Colors.blueAccent.withOpacity(0.4)),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  double getPercentWidth(int percent) {
    return MyUtils.buildSizeWidth((percent / 100) * 70);
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
}
