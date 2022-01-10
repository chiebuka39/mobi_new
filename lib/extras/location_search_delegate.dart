import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobi/models/place_prediction.dart';
import 'package:mobi/viewmodels/locations_model.dart';


import 'enums.dart';

class LocationSearchDelegate extends SearchDelegate{
  final LocationModel _locationModel;

  LocationSearchDelegate(this._locationModel);
  
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return null;
  }

  Timer _debounce;
  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _locationModel.getPredictionsWithValue(query);
    });


    if (_locationModel.state == ModelState.INIT) {
      return Container(
          height: 500.0,
          alignment: Alignment.center,
          child: Text('Please enter a term to begin'));
    }
    if (_locationModel.state == ModelState.LOADING) {
      return Container(
          height: 500.0,
          alignment: Alignment.center,
          child: CircularProgressIndicator());
    }


    if (_locationModel.state == ModelState.COMPLETE) {
      return ListView.builder(
        itemCount: _locationModel.predictions.placesList.length,
        itemBuilder: (BuildContext context, int index) {
          PredictedPlace prediction = _locationModel.predictions.placesList[index];
          return _SearchResultItem(item: prediction);
        },
      );

    }


    return Container();
  }

}


class _SearchResultItem extends StatelessWidget {
  final PredictedPlace item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.title),
      ),
      title: Text(item.description),
      onTap: () {
//        Navigator.pushReplacement (
//          context,
//          MaterialPageRoute(builder: (context) => PlacesDetailsMap(
//            setLocationBloc: setLocationBloc,
//            detailsRepository:repository,
//            placeId: item.placeId,
//          )),
//        );
        print(item.description);
      },
    );
  }
}