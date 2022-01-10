import 'package:after_layout/after_layout.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/ride_started/chat_mixin.dart';
import 'package:mobi/screens/rides/chat_ride.dart';
import 'package:mobi/viewmodels/chat_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/chats.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class RideChatScreen extends StatefulWidget {
  final ScheduledRide ride;

  const RideChatScreen({Key key,@required this.ride}) : super(key: key);
  @override
  _RideChatScreenState createState() => _RideChatScreenState();
}

class _RideChatScreenState extends State<RideChatScreen> with AfterLayoutMixin<RideChatScreen>, ChatMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ABSChatViewModel _chatViewModel;
  UserModel _userModel;
  TextEditingController _messageController;

  ProgressDialog _pr;

  @override
  void initState() {
    _messageController = TextEditingController();

    super.initState();
  }



  // Insert the "next item" into the list model.





  @override
  void afterFirstLayout(BuildContext context) async{
    _chatViewModel.getListOfChat(ride: widget.ride,user: _userModel.user).listen((event) {
      print("pppp vv $chats -- $event");
      if(chats == null){
        chats = event;
        list = ListModel<Chat>(
          listKey: _listKey,
          initialItems: chats,
          removedItemBuilder: buildRemovedItem,
        );
        setState(() {

        });
      }else{
        chats.add(event.last);
        insert(event.last);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    _chatViewModel = Provider.of(context);
    _userModel = Provider.of(context);
    _pr = ProgressDialog(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Trip Conversation", style: TextStyle(color: Colors.black),),
      ),
      body: ChatRideWidget(
        chats: chats,
        list: list,
        ride: widget.ride, handleSendMessage: (value)async{
        if(value.length > 3){
          //_pr.show();
          var result = await _chatViewModel.postChat(ride: widget.ride,
              user: _userModel.user,
              message: value);
          //_pr.dismiss();
          if(result.error == true){
            showSimpleNotification(Text("Could not send chat"),background: Colors.redAccent);
          }else{
            //_chats.add(result.data);
            //_insert(result.data);
            showSimpleNotification(Text("Message sent"));
            _messageController.text = "";
          }
        }
      }, controller: _messageController, listKey: _listKey,

      )
    );
  }




}


