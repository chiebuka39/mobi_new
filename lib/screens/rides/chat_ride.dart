import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/viewmodels/chat_view_model.dart';
import 'package:mobi/widgets/chats.dart';
import 'package:provider/provider.dart';

class ChatRideWidget extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  final List<Chat> chats;
  final ListModel<Chat> list;
  final TextEditingController controller;
  final ScheduledRide ride;
  final Function handleSendMessage;

  const ChatRideWidget({Key key,
    @required this.listKey,
    @required this.chats,
    @required this.list,
    @required this.controller,
    @required this.ride,
    @required this.handleSendMessage}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return chats == null ? Container():
    Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(

          child: AnimatedList(
            key: listKey,
            initialItemCount: list.length,
            itemBuilder: _buildItem,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20,right: 10),
          height: 100,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter message here",

                  ),
                ),
              ),
              IconButton(icon:  Icon(Icons.send),onPressed: ()async{
                handleSendMessage(controller.text);
              },)
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRemovedItem(
      Chat item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      nip: BubbleNip.rightBottom,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert(Chat chat) {
    list.insert(list.length, chat);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: list[index],
      selected: false,
      onTap: () {

      }, nip: BubbleNip.rightBottom,
    );
  }
}
