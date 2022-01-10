import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

import '../sign_in_screen.dart';

class OnBoardingWidget extends StatefulWidget {
  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget>
    with TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final slideTween = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero);
  var items = NavItem.generateItems();

  PageController controller;
  var currentPage = 0;

  @override
  void initState() {
    //MyUtils.initDynamicLinks();

    controller = PageController(initialPage: currentPage);
    controller.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(shape: BoxShape.circle),
          padding: EdgeInsets.only(top: kToolbarHeight, left: 30, right: 30),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: PageView(
                    controller: controller,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          buildHeaderSection(items[0]),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Image.asset(
                                'assets/img/${items[0].image}.png',
                                width: 300,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          buildHeaderSection(items[1]),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Image.asset(
                                'assets/img/${items[1].image}.png',
                                width: 300,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          buildHeaderSection(items[2]),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Image.asset(
                                'assets/img/${items[2].image}.png',
                                width: 300,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              isLast()
                  ? SizedBox(
                height: 66,
              )
                  : SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: skip,
                  textColor: thirdColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text('Skip for now'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  onPressed: next,
                  textColor: Colors.white,
                  color: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: currentPage == (items.length - 1)
                      ? Text("Continue")
                      : Text("Next"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderSection(NavItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          item.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: primaryColor,
          ),
        )
      ],
    );
  }

  bool isLast() {
    return currentPage == (items.length - 1);
  }

  void skip() {

    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) {
      return new SignInScreen();
    }), (Route<dynamic> route) => false);
  }

  void next() {
    if (isLast()) {
       skip();
      return;
    }
    controller.nextPage(
        duration: Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
  }

  void onChange() {
    setState(() => currentPage = controller.page.round());
  }
}

const crossFadeDuration = Duration(milliseconds: 500);


class NavItem {
  final String title;
  final String description;
  final String image;

  NavItem(this.title, this.description, this.image);

  static List<NavItem> generateItems() {
    return <NavItem>[
      NavItem(
        'Find Extra car spaces',
        'We connect Car owners with free spaces to commuters who are going their way.',
        'board1',
      ),
      NavItem(
        'Meet New people',
        'Make your commutes memorable, by meeting new people daily and striking up a bond',
        'board2',
      ),
      NavItem(
        'Comfortable rides to work',
        'No more danfo wahala, and stress to work, join neigbors and co-workers going your way',
        'board3',
      ),
    ];
  }
}
