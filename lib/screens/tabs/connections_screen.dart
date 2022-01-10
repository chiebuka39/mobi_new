import 'package:flutter/material.dart';

class ConnectionsScreen extends StatefulWidget {

  ConnectionsScreen({Key key}):super(key:key);

  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Your list of connections would show here"),
        ),
      ),
    );
  }
}
