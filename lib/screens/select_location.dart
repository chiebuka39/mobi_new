import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/location.dart';
import 'package:mobi/models/place_details_data.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class SelectLocation extends StatefulWidget {
  final LocationDirection direction;
  final bool save;
  final String placeId;

  const SelectLocation(
      {Key key,
      this.direction = LocationDirection.FRO,
      this.save = true,
      this.placeId})
      : super(key: key);
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation>
    with AfterLayoutMixin<SelectLocation> {
  Completer<GoogleMapController> _controller = Completer();
  LocationModel _locationModel;
  UserModel _userModel;
  bool _loading = false;
  bool _error = false;
  PlaceDetailsData _detailsData;
  GeoFlutterFire geo = GeoFlutterFire();

  CameraPosition currentPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (widget.placeId != null) {
      await _fetchMapDetails();
    }
  }

  Future _fetchMapDetails() async {
    var result = await _locationModel.getMapDetailsWithId2(widget.placeId);
    if (result['error'] == false) {
      setState(() {
        _loading = false;
        _detailsData = result['details'];
      });
      //print("ffff ${_detailsData.lat}");
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _locationModel = Provider.of<LocationModel>(context);
    _userModel = Provider.of<UserModel>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: widget.direction == LocationDirection.FRO ? Text('Confirm Home Location'):Text('Confirm Work location'),
        ),
      body: _error == false
          ? _buildBodyWidget(size, context)
          : Center(
            child: Column(
                children: <Widget>[
                  Spacer(),
                  SvgPicture.asset("assets/img/info.svg", width: 100,),
                  SizedBox(height: 50,),
                  Text(
                    "Unable to find location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-100,
                    child: Text(
                        "We were unable to find this loaction, "
                            "kindly check your network and try again", textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  SecondaryButton(handleClick: (){
                      setState(() {
                        _detailsData = null;
                        _error = false;
                      });
                  },title: "RETRY",),
                  Spacer(),
                ],
              ),
          ),
    );
  }

  Widget _buildBodyWidget(Size size, BuildContext context) {
    return _detailsData == null
        ? Container(
            height: size.height,
            width: size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition:  CameraPosition(
                  target: LatLng(_detailsData.lat,_detailsData.lon),
                  zoom: 17.4746,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("Current picked Location"),
                      position: LatLng(_detailsData.lat, _detailsData.lon))
                },
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: 200,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Choose this Location",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              TheLocation loc = TheLocation(
                                  title: _detailsData.formatted_address,
                                  lon: _detailsData.lon,
                                  lat: _detailsData.lat);
                              if (widget.direction == LocationDirection.FRO &&
                                  widget.save == true) {
                                _userModel.setUserHomeLocation(loc);
                              } else {
                                if (widget.save == true) {
                                  _userModel.setUserWorkLocation(loc);
                                }
                              }
                              _locationModel.reset();
                              Navigator.pop(context);
                              Navigator.pop(context, loc);
                            },
                            child: Text(
                              "SELECT",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              _locationModel.reset();
                              Navigator.pop(context);
                            },
                            child: Text("CANCEL"),
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ))
            ],
          );
  }
}
