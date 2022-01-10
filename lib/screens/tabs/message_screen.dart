import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Your messages"),
      ),
//      body: ListView.builder(itemBuilder: (BuildContext context, int index){
//        return Container(height: 200,child: Column(children: <Widget>[
//          Row(
//            children: <Widget>[
//              Text("Chiebuka Edwin", style: TextStyle(),),
//            ],
//          )
//        ],),);
//      },itemCount: 2,)
    body: NoMessageWidget(),
    );
  }
}

class NoMessageWidget extends StatelessWidget {
  const NoMessageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 1,),
        Image.asset("assets/img/nomessage.png"),
        Text(
          "No Message, yet",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10,),
        SizedBox(
          width: 350,
          child: Text(
            "You have not initiated a conversation with anyone",
            style: TextStyle(fontSize: 19,),textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2,),
      ],
    );
  }
}
