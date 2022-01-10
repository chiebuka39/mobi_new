import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/user.dart';

class TransactionDetailScreen extends StatefulWidget {
  final MobiTransaction transaction;

  const TransactionDetailScreen({Key key,@required this.transaction}) : super(key: key);
  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Transaction Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Amount".toUpperCase(),
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.42), fontSize: 12),
                      ),
                      Text("NGN ${widget.transaction.amount}", style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Date".toUpperCase(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.42), fontSize: 12),
                    ),
                    Text(MyUtils.getReadableDate2(widget.transaction.date), style: TextStyle(fontSize: 20),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 35,),
            Row(

              children: <Widget>[
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Paid by".toUpperCase(),
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.42), fontSize: 12),
                      ),
                      SizedBox(
                        width: 100,
                          child: Text(widget.transaction.userFrom, style: TextStyle(fontSize: 20),))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Recieved by".toUpperCase(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.42), fontSize: 12),
                    ),
                    SizedBox(
                      width: 100,
                        child: Text(widget.transaction.userTo, style: TextStyle(fontSize: 20),))
                  ],
                ),

              ],
            ),
            SizedBox(height: 35,),
            Row(

              children: <Widget>[
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Note".toUpperCase(),
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.42), fontSize: 12),
                      ),
                      SizedBox(
                          width: 100,
                          child: Text(getIconName(widget.transaction).toUpperCase(), style: TextStyle(fontSize: 20),))
                    ],
                  ),
                ),


              ],
            )
          ],
        ),
      ),
    );
  }
  String getIconName(MobiTransaction transaction) {
    if(transaction.type == TransactionType.CREDIT){
      return 'Recieved';
    }else if(transaction.type == TransactionType.PAYMENT){
      return 'Paid';
    }else{
      return 'TOP Up';
    }
  }
}
