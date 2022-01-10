import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/update_profile/harry.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/form/name_form_widgets.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class ChurchDetailsScreen extends StatefulWidget {
  @override
  _ChurchDetailsScreenState createState() => _ChurchDetailsScreenState();
}

class _ChurchDetailsScreenState extends State<ChurchDetailsScreen> with AfterLayoutMixin<ChurchDetailsScreen> {
  String _workPlace;
  String _jobTitle;
  UserModel _userModel;
  bool _loading = false;

  File _workId;

  List<TheLocation> locations = [];

  @override
  void afterFirstLayout(BuildContext context)async {
    setState(() {
      _jobTitle = _userModel.user.jobDesc;
      _workPlace = _userModel.user.work;
    });
    EasyLoading.show(status: 'loading...');
    var result = await _userModel.fetchChurches(_userModel.user);
    if(result.error == false){
      setState(() {
        locations.add(result.data);
      });
      EasyLoading.showSuccess('Great Success!');
    }else{
      EasyLoading.showError('Failed with Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white,),
            onPressed: locations.length > 0? null : toLocFunc,
          )
        ],
        title: Text("", style:
        TextStyle(
            color: Colors.black, fontSize: 16,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
          Text("Add Your church address", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
          SizedBox(height: 5,),
            SizedBox(
            width: 250,
              child: Text("Adding your church address helps you find rides going to church", style: TextStyle(fontSize: 12),)),
          Column(
            children:locations.asMap().entries.map((e) => InkWell(
              child: Material(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: secondaryGrey))),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Church Location ${e.key +1}",
                        style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        e.value.title.length > 20? e.value.title.substring(0, 20)
                            :e.value.title,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
            Spacer(),
            SecondaryButton(title: "Update Church adresses",
              handleClick: _saveChanges,width: double.infinity,loading: _loading,),
            SizedBox(height: 40,)
        ],),
      ),
    );
  }

  Future toLocFunc() async {
    TheLocation loc = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LocationSearchScreen(
              direction: LocationDirection.TO,
              save: false,
            )));
    if (loc != null) {
      setState(() {
        locations.add(loc);
      });
    } else {}
  }

  _saveChanges() {
    if(locations.isNotEmpty){
      //print("got here");
      TheLocation location = locations.first;
      location.type = "church";

      setState(() {
        _loading = true;
      });

      _userModel.addChurch(locations.first, _userModel.user).then((result) {
        if(result.error != true){
          setState(() {
            _loading = false;
          });

          showDialog(context: context, builder: (c){
            return AlertDialog(title: Text("Success", style: TextStyle(fontWeight: FontWeight.bold),),content: Text("You have successfully "
                "Saved the changes to your profile"),);
          });
          Navigator.of(context).pop();
        }else{
          showDialog(context: context, builder: (v){
           return AlertDialog(title: Text("Error", style: TextStyle(fontWeight: FontWeight.bold),),content: Text("You have successfully "
                "Could not Update your work details"),);
          });
        }

      });
    }
  }

}
