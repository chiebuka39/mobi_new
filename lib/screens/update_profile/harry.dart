import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/place_prediction.dart';
import 'package:mobi/screens/select_location.dart';
import 'package:mobi/viewmodels/locations_model.dart';
import 'package:provider/provider.dart';

class LocationSearchScreen extends StatefulWidget {
  final LocationDirection direction;
  final bool save;

  const LocationSearchScreen({Key key, this.direction, this.save}) : super(key: key);
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  LocationModel _locationModel;

  final _searchQuery = new TextEditingController();
  Timer _debounce;
  PlacesPrediction _prediction;
  bool _loading = false;

  @override
  void initState() {
    print("qqqqqqqq");
    _searchQuery.addListener(onChange);
    super.initState();
  }

  Future<Null> onChange() async {
    String value = _searchQuery.text;

    if (value.length >= 3) {
      _debounce?.cancel();
      if (value != null) {}
      _debounce = new Timer(const Duration(seconds: 2), () async {
        _debounce.cancel();
        await _fetchPredictions(value);
      });
    } else {
      _debounce?.cancel();
    }
  }

  Future _fetchPredictions(String value) async {
    setState(() {
      _loading = true;
    });
    var result = await _locationModel.getPredictionsWithValue2(value);

    if (result['error'] == false) {
      setState(() {
        _prediction = result['prediction'];
        _loading = false;
      });
    } else {
      print("an error");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce.cancel();
    _searchQuery.removeListener(onChange);
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locationModel = Provider.of<LocationModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: widget.direction == LocationDirection.FRO ? Text('Start Location'):Text('End location'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              autofocus: true,
              controller: _searchQuery,
              decoration: InputDecoration(
                  labelText: widget.direction == LocationDirection.FRO ? "Enter Home address":"Enter Work Address",
                border: OutlineInputBorder()
              ),
            ),
          ),
          SizedBox(height: 50,),
          _loading == false
              ? _prediction == null ? Container() : _buildPredictionList()
              : _buildLoadingWidget()
        ],
      ),
    );
  }

  Expanded _buildLoadingWidget() {
    return Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
  }

  Expanded _buildPredictionList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:
                      (_) =>
                          SelectLocation(
                            direction: widget.direction,
                            save: widget.save,placeId: _prediction.placesList.elementAt(index).placeId,)));
            },
            child: Container(
              height: 65,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: .5))
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(_prediction.placesList.elementAt(index).description),
            ),
          );
        },
        itemCount: _prediction.placesList.length,
      ),
    );
  }
}
