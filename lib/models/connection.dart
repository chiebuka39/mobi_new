import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/extras/enums.dart';


List<Connection> connectionsFromJson(String str) => new List<Connection>.from(json.decode(str).map((x) => Connection.fromMap(x)));
List<Connection> connectionsFromFireStore(String str) => new List<Connection>.from(json.decode(str).map((x) => Connection.fromFirestore(x)));


Connection connectionFromJson(String str) => Connection.fromMap(json.decode(str));
//List<CountryMerchants> countryMerchantsFromJson(String str) => new List<CountryMerchants>.from(json.decode(str).map((x) => CountryMerchants.fromJson(x)));
String connectionToJson(Connection data) => json.encode(data.toMap());

class Connection{
  String connectionId;
  String userId;
  String name;
  String userProfilePix;
  ConnectionType type;
  bool selected = false;

  Connection({
    this.connectionId,
    this.userId,
    this.userProfilePix,
    this.name,
    this.type,
  });

  Map<String, dynamic> toMap() {
    var userMap = Map<String, dynamic>();
    userMap['connection_id'] = connectionId;
    userMap['user_id'] = userId;
    userMap['user_pix'] = userProfilePix;
    userMap['name'] = name;
    userMap['type'] = Connection.convertFromType(type);
    return userMap;
  }

  Map<String, dynamic> toFireStore() {
    var userMap = Map<String, dynamic>();
    userMap['connection_id'] = connectionId;
    userMap['user_id'] = userId;
    userMap['user_pix'] = userProfilePix;
    userMap['name'] = name;
    userMap['connection_type'] = Connection.convertFromType(type);
    return userMap;
  }

  static Connection fromMap(Map<String, dynamic> map){
    return Connection(
        connectionId: map['connection_id'],
        userId: map['user_id'],
        userProfilePix: map['user_pix'],
        name:map['name'],
        type: Connection.convertToType(map['connection_type']),

    );

  }

  static Connection fromFirestore(Map<String, dynamic> map){
    return Connection(
        connectionId: map['connection_id'],
      userProfilePix: map['user_pix'],
        userId: map['user_id'],
        name: map['name'],
        type: Connection.convertToType(map['connection_type']),
    );
  }

  static List<Connection> listFromFirestore(List<DocumentSnapshot> docs){
    List<Connection> rides = [];
    docs.forEach((doc){
      Map<String, dynamic> map = doc.data();
      rides.add(
          Connection(
              connectionId: map['connection_id'],
              userId: map['user_id'],
            name: map['name'],
              type: Connection.convertToType(map['type']),
          )
      );
    });


    return rides;
  }





  static int convertFromType(ConnectionType type){
    if(type == ConnectionType.CONNECTIONS){
      return 0;
    }else if(type == ConnectionType.COWORKER){
      return 1;
    }else if(type == ConnectionType.NEIGBHOR){
      return 2;
    }

    return 0;
  }

  static ConnectionType convertToType(int value){
    if(value == 0){
      return ConnectionType.CONNECTIONS;
    }else if(value == 1){
      return ConnectionType.COWORKER;
    }else if(value == 2){
      return ConnectionType.NEIGBHOR;
    }
    return ConnectionType.CONNECTIONS;
  }

}



