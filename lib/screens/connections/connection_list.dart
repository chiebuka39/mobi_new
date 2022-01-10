import 'package:flutter/material.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/screens/connections/connections_screen.dart';

class ConnectionList extends StatefulWidget {
  final List<Connection> connections;

  const ConnectionList({Key key,@required this.connections}) : super(key: key);
  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  List<Connection> connections;

  @override
  void initState() {
    connections = widget.connections;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyUtils.buildSizeWidth(6)),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          connections[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MyUtils.fontSize(3.7)),
                        ),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              connections[index].selected = !connections[index].selected;
                            });

                          },
                          value: connections[index].selected,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: connections.length,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MyUtils.buildSizeWidth(6), vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text("Invite a friend"),
                  onPressed: () {},
                ),
                ButtonTheme(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minWidth: MyUtils.buildSizeWidth(35),
                    child: RaisedButton(
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        List<Connection> selected = connections.where((connect) => connect.selected == true).toList();
                        Navigator.pop(context, selected);
                      },
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
