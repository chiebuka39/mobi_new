import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/connection.dart';
import 'package:mobi/screens/connections/connection_list.dart';

import 'connections_screen.dart';
import 'no_contact.dart';

class GroupedConnection extends StatefulWidget {
  final ConnectionType connectionType;

  const GroupedConnection({Key key, this.connectionType}) : super(key: key);
  @override
  _GroupedConnectionState createState() => _GroupedConnectionState();
}

class _GroupedConnectionState extends State<GroupedConnection> {
  List<Connection> _connections = [];
  @override
  Widget build(BuildContext context) {
    return _connections.length == 0
        ? NoContact()
        : ConnectionList(
            connections: <Connection>[],
          );
  }
}
