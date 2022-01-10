import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String message;
  String id;
  DateTime time;
  String senderName;
  String senderId;
  String rideId;
  String carOwnerName;
  String carOwnerId;

  Chat({this.message, this.time,this.rideId,
    this.carOwnerId,
    this.carOwnerName, this.senderId, this.senderName, this.id});

  Map<String, dynamic> toFireStore() {
    var map = Map<String, dynamic>();
    map['message'] = message;
    map['id'] = id;
    map['time'] = Timestamp.fromDate(time);
    map['sender_name'] = senderName;
    map['carowner_name'] = carOwnerName;
    map['carowner_id'] = carOwnerId;
    map['sender_id'] = senderId;
    map['ride_id'] = rideId;
    return map;
  }

  static Chat fromFirestore(Map<String, dynamic> map){
    return Chat(
      message: map['message'],
      time: DateTime.fromMillisecondsSinceEpoch(
          (map['time'] as Timestamp).millisecondsSinceEpoch),
      senderName: map['sender_name'],
      carOwnerName: map['carowner_name'],
      carOwnerId: map['carowner_id'],
      senderId: map['sender_id'],
      rideId: map['rideId'],
      id: map['id']
    );
  }

  static List<Chat> listFromFirestore(List<DocumentSnapshot> docs){
    List<Chat> rides = [];
    docs.forEach((doc){
      Map<String, dynamic> map = doc.data();
      rides.add(
          Chat.fromFirestore(map)
      );
    });


    return rides;
  }
}
