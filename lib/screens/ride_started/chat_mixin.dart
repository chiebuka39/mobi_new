import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/widgets/chats.dart';

mixin ChatMixin<T extends StatefulWidget> on State<T> {
  List<Chat> chats;
  ListModel<Chat> list;

  Widget buildRemovedItem(
      Chat item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      nip: BubbleNip.rightBottom,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }
  void insert(Chat chat) {
    print("${list.length} 00000 ");
    list.insert(list.length, chat);
  }
}