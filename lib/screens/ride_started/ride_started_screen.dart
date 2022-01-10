import 'package:after_layout/after_layout.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/message_handler.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/chat.dart';
import 'package:mobi/models/commuters.dart';
import 'package:mobi/models/scheduled_ride.dart';
import 'package:mobi/models/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mobi/screens/chat_screen.dart';
import 'package:mobi/screens/home_screen_2.dart';
import 'package:mobi/screens/ride_started/chat_mixin.dart';
import 'package:mobi/screens/rides/chat_ride.dart';
import 'package:mobi/viewmodels/chat_view_model.dart';
import 'package:mobi/viewmodels/rides_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/chats.dart';
import 'package:mobi/widgets/form/form_selector.dart';
import 'package:mobi/widgets/location_widget.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class RideStartedScreen2 extends StatefulWidget {
  final ScheduledRide ride;
  final bool shouldEdit;

  const RideStartedScreen2({Key key, this.ride, this.shouldEdit = true})
      : super(key: key);
  @override
  _RideStartedScreenState createState() => _RideStartedScreenState();
}

class _RideStartedScreenState extends State<RideStartedScreen2>
    with AfterLayoutMixin<RideStartedScreen2>, ChatMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int tab = 0;
  UserModel _userModel;
  RidesViewModel _ridesViewModel;
  ABSChatViewModel _chatViewModel;
  ScheduledRide _ride;
  List<User> _fellowCommuters = [];
  TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    if (widget.ride != null) {
      _ride = widget.ride;
    }
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await fetchAllUsers();

    await listenForLiveChanges();

    getAllChat();
  }

  Future fetchAllUsers() async {
    var result = await _userModel.getAllUsers(widget.ride.riders);
    setState(() {
      _fellowCommuters = result;
    });
    print("users $result");
  }

  Future listenForLiveChanges() async {
    _ridesViewModel.getRide(widget.ride).listen((document) async {
      print("harry p");
      ScheduledRide rid = ScheduledRide.fromFirestore(document.data());
      var result = await _userModel.getAllUsers(rid.riders);
      setState(() {
        _fellowCommuters = result;
        _ride = rid;
      });
    });
  }

  void getAllChat() async {
    _chatViewModel
        .getListOfChat(ride: widget.ride, user: _userModel.user)
        .listen((event) {
      if (chats == null) {
        chats = event;
        list = ListModel<Chat>(
          listKey: _listKey,
          initialItems: chats,
          removedItemBuilder: buildRemovedItem,
        );
        setState(() {});
      } else {
        chats.add(event.last);
        insert(event.last);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _ridesViewModel = Provider.of(context);
    _chatViewModel = Provider.of(context);
    var selected = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    var unSelected = TextStyle(
        fontWeight: FontWeight.w300, fontSize: 14, color: Colors.grey);
    print("kkkk ${MediaQuery.of(context).size.height}");
    return Scaffold(
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(50)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Ride in progress",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 27,
            ),
            Container(
              height: 40,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(

                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          tab = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ride Details",
                          style: tab == 0 ? selected : unSelected,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tab = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Co-commutters",
                          style: tab == 1 ? selected : unSelected,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tab = 2;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ride conversations",
                          style: tab == 2 ? selected : unSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            tab == 0
                ? RideStartedDetailsWidget(
                    ride: _ride,
                    shouldEdit: widget.shouldEdit,
                  )
                : tab == 1
                    ? RidersListWidget(
                        fellowCommuters: _fellowCommuters,
                        ride: _ride,
                        shouldEdit: widget.shouldEdit,
                      )
                    : Expanded(
                        child: ChatRideWidget(
                        ride: _ride,
                        handleSendMessage: (value) async{
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
                        },
                        chats: chats,
                        controller: _messageController,
                        listKey: _listKey,
                        list: list,
                      ))
          ],
        ),
      ),
    );
  }
}

class RidersListWidget extends StatefulWidget {
  final List<User> fellowCommuters;
  final ScheduledRide ride;
  final bool shouldEdit;
  const RidersListWidget({
    Key key,
    @required this.fellowCommuters,
    this.ride,
    this.shouldEdit,
  }) : super(key: key);

  @override
  _RidersListWidgetState createState() => _RidersListWidgetState();
}

class _RidersListWidgetState extends State<RidersListWidget>
    with AfterLayoutMixin<RidersListWidget> {
  ProgressDialog pr;

  @override
  void afterFirstLayout(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Dropping off user',
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of(context);
    RidesViewModel ridesViewModel = Provider.of(context);
    User currentUser = userModel.user;
    print("ppppppp 11111");
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          User user = widget.fellowCommuters[index];

          return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircularProfileAvatar(
              user.avatar,
//              'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
              radius: 25, // sets radius, default 50.0
              backgroundColor: Colors
                  .transparent, // sets background color, default Colors.white
              cacheImage:
                  true, // allow widget to cache image against provided url
            ),
            title: Text(
              user.fullName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              getDriverOrCommutterText(userModel.user, user),
              style: TextStyle(fontSize: 13),
            ),
            trailing: widget.ride.userId == user.phoneNumber
                ? SizedBox()
                : widget.shouldEdit == false
                    ? SizedBox()
                    : widget.ride.ridersState[index] == 3
                        ? Text("Available for pickup")
                        : widget.ride.ridersState[index] == 4
                            ? ButtonTheme(
                                minWidth: 70,
                                height: 30,
                                child: FlatButton(
                                  child: Text(
                                    "Drop-off",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  onPressed:userModel.user.phoneNumber == widget.ride.userId ? () {

                                    setRiderState(
                                        user, widget.ride, ridesViewModel);
                                  }:null,
                                  color: blueLight,
                                ),
                              )
                            : widget.ride.ridersState[index] == 2
                                ? Text("Not Available yet")
                                : Text("Dropped Off"),
          );
        },
        itemCount: widget.fellowCommuters.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  void setRiderState(
      User user, ScheduledRide ride, RidesViewModel model) async {
    int index = ride.riders.indexOf(user.phoneNumber);
    //set to waiting
    ride.ridersState[index] = 1;
    pr.show();
    bool result =
        await model.setRiderState(ride, user.phoneNumber, ride.ridersState);
    pr.hide();
    if (result == false) {
      showSimpleNotification(Text("An error occured, try again"),
          background: Colors.red);
    } else {
      showSimpleNotification(Text("Drooped off a user"),
          background: Colors.green);
    }
  }

  String getDriverOrCommutterText(User currentUser, User user) =>
      currentUser.phoneNumber == user.phoneNumber
          ? "Commute Pilot"
          : "Co-commutter";
}

class RideStartedDetailsWidget extends StatefulWidget {
  const RideStartedDetailsWidget({
    Key key,
    @required this.ride,
    this.shouldEdit,
  }) : super(key: key);

  final ScheduledRide ride;
  final bool shouldEdit;

  @override
  _RideStartedDetailsWidgetState createState() =>
      _RideStartedDetailsWidgetState();
}

class _RideStartedDetailsWidgetState extends State<RideStartedDetailsWidget>
    with AfterLayoutMixin<RideStartedDetailsWidget> {
  ProgressDialog pr;
  UserModel _userModel;
  RidesViewModel _ridesViewModel;

  @override
  void afterFirstLayout(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Ending trip',
    );
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of(context);
    _ridesViewModel = Provider.of(context);
    int index = widget.ride.riders.indexOf(_userModel.user.phoneNumber);
    int rideState = widget.ride.ridersState[index];
    print("rrr $rideState");
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          print(
              "constraints ${constraints.maxHeight}-- ${constraints.minHeight}");
          return Container(
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      //_onLocationPressed("dest");
                    },
                    child: LocationWidget(
                      tag: '',
                      screenWidth: MediaQuery.of(context).size.width,
                      title: 'Start Location',
                      content: widget.ride.fromLocation.title,
                      direction: LocationDirection.FRO,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      //_onLocationPressed("dest");
                    },
                    child: LocationWidget(
                      tag: '',
                      screenWidth: MediaQuery.of(context).size.width,
                      title: 'Destination',
                      content: widget.ride.toLocation.title,
                      direction: LocationDirection.TO,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FormSelector(
                    showTopBorder: true,
                    value: MyUtils.getReadableDateOfMonthShort(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.ride.dateinMilliseconds)),
                    title: "Date",
                    desc: "Click to pick a date",
                    onPressed: null,
                  ),
                  FormSelector(
                    showTopBorder: false,
                    value: MyUtils.getReadableTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.ride.dateinMilliseconds)),
                    title: "Trip Started at",
                    desc: "Click to pick a date",
                    onPressed: null,
                  ),
                  FormSelector(
                    showTopBorder: false,
                    value: widget.ride.riders.length.toString(),
                    title: "Number of commutters",
                    desc: "Click to pick a date",
                    onPressed: null,
                  ),
                  constraints.maxHeight < 480
                      ? SizedBox(
                          height: 20,
                        )
                      : SizedBox(
                          height: 80,
                        ),
                  widget.ride.userId == _userModel.user.phoneNumber
                      ? SecondaryButton(
                          title: 'End trip',
                          handleClick: endRide,
                          width: double.infinity,
                        )
                      : rideState != 4 ?SecondaryButton(
                    title: 'Join trip',
                    handleClick: (){
                      _userModel.newRide = true;
                      setRiderStateJoin(_userModel.user, widget.ride, _ridesViewModel,4);
                    },
                    width: double.infinity,
                  ):  SizedBox(),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void setRiderState(
      User user, ScheduledRide ride, RidesViewModel model) async {
    int index = ride.riders.indexOf(user.phoneNumber);
    //set to waiting
    ride.ridersState[index] = 3;
    pr.show();
    var result = await model.setRiderStateToJoin(
        ride, user, ride.ridersState);
    pr.hide();
    if (result.error == true) {
      showSimpleNotification(Text("An error occured, try again"),
          background: Colors.red);
    } else {
      showSimpleNotification(Text("You Have Joined this ride"),
          background: Colors.green);
    }
  }

  void setRiderStateJoin(
      User user, ScheduledRide ride, RidesViewModel model, int num) async {
    int index = ride.riders.indexOf(user.phoneNumber);
    //set to waiting
    ride.ridersState[index] = num;
    pr.show();
    var result =
    await model.setRiderStateToJoin(ride, user, ride.ridersState);
    setState(() {
     pr.hide();
      if (result.error == false) {
        index = index++;
      }
    });
    if (result.error == true) {
      showSimpleNotification(Text("An error occured, try again"),
          background: Colors.red);
    } else {

      showSimpleNotification(Text("Your request was successful"),
          background: Colors.blue);
    }
  }

  void endRide() async {
    pr.show();
    bool result = await _ridesViewModel.setRideState(
        widget.ride, _userModel.user.phoneNumber, RideState.ENDED);
    pr.hide();

    if (result == true) {
      showSimpleNotification(Text("This ride has Ended"),
          background: Colors.green);
      await Future.delayed(Duration(seconds: 2));
      //Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MessageHandler(
                    child: HomeTabs(),
                  )),
          (Route<dynamic> route) => false);
    } else {
      showSimpleNotification(Text("The ride could not be Ended, try again"),
          background: Colors.red);
    }
  }
}
