import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/connections/grouped_connection.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

import 'connection_list.dart';

class ConnectionsScreen extends StatefulWidget {

  //Selected Connections of the user
  final List<Connection> connections;
  //Connections of this user
  final List<Connection> mainConnections;


  const ConnectionsScreen({Key key,
    @required this.connections,
    @required this.mainConnections}) : super(key: key);
  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> with AfterLayoutMixin<ConnectionsScreen>{
  UserModel _userModel;
  int coworkers = 0;
  bool _loading = false;

  @override
  void initState() {
    widget.mainConnections.forEach((connection){
      widget.connections.forEach((connect){
        if(connect.name == connection.name){
          connection.selected = true;
        }
      });
    });

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check),onPressed: (){

          },)
        ],
        title: Text('Connections'),
      ),
      body: widget.mainConnections.length == 0? GroupedConnection():ConnectionList(connections: widget.mainConnections,),
    );
  }
}




