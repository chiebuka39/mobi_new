import 'package:flutter/material.dart';

import '../extras/enums.dart';
import '../extras/utils.dart';
import '../widgets/form/form_selector.dart';
import '../widgets/location_widget.dart';
import '../widgets/primary_button.dart';

class HomeWebScreen extends StatefulWidget {
  const HomeWebScreen({Key key}) : super(key: key);

  @override
  _HomeWebScreenState createState() => _HomeWebScreenState();
}

class _HomeWebScreenState extends State<HomeWebScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Schedule Ride",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LocationWidget(
                screenWidth: screenWidth,
                tag:  'from',
                title: "Start Location",
                onPressed: (){

                },
                content:"",
              ),
            ),
            SizedBox(
              height: 34,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LocationWidget(
                tag:  'Work',
                screenWidth: screenWidth,
                title: "Destination",
                onPressed: (){

                },
                content:  "",
                direction: LocationDirection.TO,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FormSelector(
              showTopBorder: true,
              value: MyUtils.getReadableDate(DateTime.now()),
              title: "Date",
              desc: "Click to pick a date",
              onPressed: () async {
                DateTime result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(hours: 5)),
                    firstDate:
                    DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)));
                if (result != null) {

                }
              },
            ),
            FormSelector(
              value: MyUtils.toTimeString(TimeOfDay(minute: 29, hour: 4)),
              title: "Time",
              desc: "Click to pick a time",
              onPressed: () async {
                TimeOfDay result = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (result != null) {
                  setState(() {

                  });
                }
              },
            ),


            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryButton(
                title: "Schedule Ride",
                handleClick: (){},
                width: double.infinity,
                loading:false,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
