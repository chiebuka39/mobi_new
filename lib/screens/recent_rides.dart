import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';

class RecentRidesScreen extends StatefulWidget {

  RecentRidesScreen({Key key}): super(key:key);

  @override
  _RecentRidesScreenState createState() => _RecentRidesScreenState();
}

class _RecentRidesScreenState extends State<RecentRidesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: CustomAppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: 140,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Monday",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                        Text(
                          '23 May',
                          style: TextStyle(fontSize: 12),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/img/sports-car.png",
                              scale: 1.2,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "VI -> Lekki",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Text("9:00am")
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
        itemCount: 2,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
        SizedBox(height: 50,),
        IconButton(onPressed: (){},icon: Icon(Icons.arrow_back, color: white,),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Recent Rides", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
        ),
      ],),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150);
}
