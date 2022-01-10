import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';


abstract class ABSChatApi {
  Future<Result<Chat>> postChat(
      {ScheduledRide ride, User user, String message});
  Stream<List<Chat>> getListOfChat({ScheduledRide ride, User user});
}

class FirestoreChatApi extends ABSChatApi {
  final FirebaseFirestore database = FirebaseFirestore.instance;


  @override
  Future<Result<Chat>> postChat(
      {ScheduledRide ride, User user, String message}) async {
    Result<Chat> result = Result();
    result.error = false;
    CollectionReference chatReference = database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .collection("chats");
    var doc = chatReference.doc();
    Chat chat = Chat(
        message: message,
        time: DateTime.now(),
        rideId: ride.id,
        carOwnerId: ride.userId,
        carOwnerName: ride.userName,
        senderId: user.phoneNumber,
        senderName: user.fullName,
        id: doc.id);
    doc.set(chat.toFireStore()).catchError((error) {
      result.error = true;
      result.message = error.toString();
    });
    if (result.error == false) {
      result.data = chat;
    }
    return result;
  }

  @override
  Stream<List<Chat>> getListOfChat({ScheduledRide ride, User user}){
    var streamTransformer =
    StreamTransformer<QuerySnapshot, List<Chat>>.fromHandlers(
      handleData: (QuerySnapshot data, EventSink sink) {
        sink.add(Chat.listFromFirestore(data.docs));
      },
      handleError: (error, stacktrace, sink) {
        print("ppppp release error");
        sink.addError('Something went wrong: $error');
      },
      handleDone: (sink) {
        sink.close();
      },
    );


    Query chatReference = database
        .collection(MyStrings.users())
        .doc(ride.userId)
        .collection(MyStrings.rides())
        .doc(ride.id)
        .collection("chats").orderBy("time",descending: false);
    var data = chatReference.snapshots().transform(streamTransformer);


    return data;
  }
}
