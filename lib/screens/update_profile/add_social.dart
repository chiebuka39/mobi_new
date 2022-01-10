import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/extras/widgets.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class AddSocialScreen extends StatefulWidget {
  @override
  _AddSocialScreenState createState() => _AddSocialScreenState();
}

class _AddSocialScreenState extends State<AddSocialScreen> with AfterLayoutMixin<AddSocialScreen>{
  UserModel _userModel;
  TextEditingController _instagram;
  TextEditingController _twitter;
  TextEditingController _linkedin;
  TextEditingController _fb;

  bool _isLoading = false;

  @override
  void initState() {
    _instagram = TextEditingController();
    _twitter = TextEditingController();
    _linkedin = TextEditingController();
    _fb = TextEditingController();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _instagram.text = _userModel.user.accounts.instagram;
    _twitter.text = _userModel.user.accounts.twitter;
    _fb.text = _userModel.user.accounts.fb;
    _linkedin.text = _userModel.user.accounts.linkedIn;
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    final cardWidth = MediaQuery
        .of(context)
        .size
        .width - 100;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SecondaryButton(
          loading: _isLoading,
          height: 50,
          width: double.infinity,
          title: "Update Social Accounts",
          handleClick: saveUserProfileDetails,
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Add Your Social links",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Adding your social links helps  connect with others "
                "on another social networksand also verifies your identity",
              style: TextStyle(
                  fontSize: 14),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/img/instagram.svg"),
                SizedBox(
                  width: 15,
                ),
                Card(
                    child: Container(
                  width: cardWidth,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: TextField(
                      controller: _instagram,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Instagram Link'),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/img/facebook.svg"),
                SizedBox(
                  width: 15,
                ),
                Card(
                    child: Container(
                  width: cardWidth,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: TextField(
                      controller: _fb,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Facebook link'),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/img/linkedin.svg"),
                SizedBox(
                  width: 15,
                ),
                Card(
                    child: Container(
                  width: cardWidth,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: TextField(
                      controller: _linkedin,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Linkedin link'),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/img/twitter.svg"),
                SizedBox(
                  width: 15,
                ),
                Card(
                    child: Container(
                  width: cardWidth,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: TextField(
                      controller: _twitter,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Twitter link'),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void saveUserProfileDetails() {
    if(_isLoading == true){
      return;
    }
    SocialAccounts accounts = SocialAccounts(
        twitter: _twitter.text,
        instagram: _instagram.text,
        fb: _fb.text,
        linkedIn: _linkedin.text);

    if(accounts.toString() == _userModel.user.accounts.toString()){
      Widgets.showCustomDialog(
          "You need to update any social Url to update Your social accounts", context, "No Update", "Continue", () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }else{
      setState(() {
        _isLoading = true;
      });
      _userModel
          .updateUserProfileSocialAccounts(_userModel.user, accounts)
          .then((result) {
        setState(() {
          _isLoading = false;
        });
        if (result['error'] == false) {
          Widgets.showCustomDialog("You have successfully added your Social details",
              context, "Update Successfull", "Continue", () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pop(context);
              });
        } else {
          Widgets.showCustomDialog(
              result['detail'], context, "Update failed", "Continue", () {
            Navigator.pop(context);
          });
        }
      });
    }

  }
}
