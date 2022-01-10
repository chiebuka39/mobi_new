import 'package:flutter/foundation.dart';
import 'package:mobi/extras/result.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/services/chat_api.dart';
import 'package:mobi/services/payment_api.dart';

import '../locator.dart';

abstract class ABSChatViewModel extends ChangeNotifier{

  Future<Result<Chat>> postChat({ScheduledRide ride, User user, String message});
  Stream<List<Chat>> getListOfChat({ScheduledRide ride, User user});
}

class ChatViewModel extends ABSChatViewModel{
  final _api = locator<ABSChatApi>();

  @override
  Future<Result<Chat>> postChat({ScheduledRide ride, User user, String message}) {

    return _api.postChat(ride: ride,user: user,message: message);
  }

  @override
  Stream<List<Chat>> getListOfChat({ScheduledRide ride, User user}) {
    return _api.getListOfChat(ride: ride,user: user);
  }

}