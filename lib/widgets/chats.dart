import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
        @required this.animation,
        this.onTap,
        @required this.item,
        @required this.nip,
        this.selected = false})
      : assert(animation != null),
        assert(item != null),
        assert(nip != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final Chat item;
  final BubbleNip nip;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4;

    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    UserModel userModel = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Bubble(
            color: item.senderId == userModel.user.phoneNumber ? Colors.blue: Colors.white,
            margin: BubbleEdges.only(top: 20),
            padding: BubbleEdges.symmetric(horizontal: 10,vertical: 15),
            alignment: item.senderId == userModel.user.phoneNumber ? Alignment.topRight: Alignment.topLeft,
            nip: item.senderId == userModel.user.phoneNumber ? nip:BubbleNip.leftBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.senderName, style: TextStyle(fontSize: 10,color:item.senderId == userModel.user.phoneNumber ? Colors.white:Colors.black,),),
                Text(item.message, style: TextStyle(color:item.senderId == userModel.user.phoneNumber ? Colors.white:Colors.black,fontSize: 16 ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);

  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
            (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}