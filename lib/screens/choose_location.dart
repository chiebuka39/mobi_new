import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/place_prediction.dart';
import 'package:mobi/screens/select_location.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:provider/provider.dart';

class ChooseLocationScreen extends StatefulWidget {
  final LocationDirection direction;
  final bool save;

  const ChooseLocationScreen({Key key,@required this.direction, this.save = true}) : super(key: key);
  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  LocationModel _locationModel;

  final _searchQuery = new TextEditingController();
  Timer _debounce;

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _locationModel.getPredictionsWithValue(_searchQuery.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightOfAppBar = size.height / 3.2;
    _locationModel = Provider.of<LocationModel>(context);

    return Scaffold(
//      floatingActionButton: Padding(
//        padding: const EdgeInsets.only(bottom: 20),
//        child: FloatingActionButton(
//          onPressed: () {},
//          child: Icon(
//            Icons.check,
//            color: Colors.white,
//          ),
//          backgroundColor: primaryColor,
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              color: Colors.transparent,
              elevation: 3,
              child: Container(
                height: heightOfAppBar,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor.shade900,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: LayoutBuilder(builder: (context, contraints) {
                  pprint(contraints.maxHeight);
                  return Column(
                    children: <Widget>[
                      Container(
                        height: contraints.maxHeight /2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_backspace,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                    "Destination",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "From",
                                    style: TextStyle(
                                        color: secondaryGrey,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Spacer(
                                flex: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/img/location-white.png"),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                  width: 200,
                                  height: 50,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _searchQuery,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type here to search for a location",
                                        hintStyle: TextStyle(color: secondaryGrey)),
                                  )),
                            ),
                            Spacer(),
                          ],
                        ),
                      )
                    ],
                  );
                })
              ),
            ),
            _buildListOfSuggestions(size, heightOfAppBar),
          ],
        ),
      ),
    );
  }

  Widget _buildListOfSuggestions(Size size, double heightOfAppBar) {
    if (_locationModel.state == ModelState.INIT) {
      return Container(child: Text("You have not made a search yet"));
    } else if (_locationModel.state == ModelState.LOADING) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
      );
    } else if (_locationModel.state == ModelState.EMPTY) {
      return Container(child: Text("Your Search result came up empty, sorry"));
    } else if (_locationModel.state == ModelState.COMPLETE) {
      return Container(
        height: size.height - (heightOfAppBar+ 30),
        width: double.infinity,
        child: ListView.separated(
            itemBuilder: (context, index) {
              PredictedPlace prediction = _locationModel.predictions.placesList[index];
              List descArray = _locationModel
                  .predictions.placesList[index].description
                  .split(" ");
              String desc1 = _locationModel
                  .predictions.placesList[index].description;

              String desc = "";
              String descLoc = "";
              int count = 0;
              descArray.forEach((value){
                if(count < descArray.length - 2){
                  if(desc.isEmpty){
                    desc = "$value";
                  }else{
                    desc = "$desc $value";
                  }

                }else{
                  if(descLoc.isEmpty){
                    descLoc = "$value";
                  }else{
                    descLoc = "$descLoc $value";
                  }
                }
                count++;
              });
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: InkWell(
                  onTap: (){
                    _locationModel.getMapDetailsWithId(prediction.placeId);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLocation(direction: widget.direction,save: widget.save,)));
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/img/location.png"),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            desc,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Text(
                            descLoc.isEmpty ? "Nigeria": descLoc,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
            itemCount: _locationModel.predictions.placesList.length),
      );
    }
  }
}

//Row(
//children: <Widget>[
//ClipRRect(borderRadius: BorderRadius.circular(5),child: Image.asset("assets/img/ebuka.png",fit: BoxFit.cover,height: 150, width: 140,))
//],
//)
