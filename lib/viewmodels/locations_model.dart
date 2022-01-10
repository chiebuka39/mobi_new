
import 'package:flutter/material.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/models/place_details_data.dart';
import 'package:mobi/models/place_prediction.dart';
import 'package:mobi/services/places_details_repo.dart';
import 'package:mobi/services/places_prediction_repo.dart';
import 'package:geolocator/geolocator.dart';
import '../locator.dart';

class LocationModel extends ChangeNotifier{
  final PlacesPredictionRepository _repository = locator<PlacesPredictionRepository>();
  final PlaceDetailsRepository _detailsRepository = locator<PlaceDetailsRepository>();

  PlacesPrediction _predictions;
  PlaceDetailsData _detailsData;
  Position _currentPosition;

  ModelState _state = ModelState.INIT;
  ModelState _detailState = ModelState.INIT;

  PlacesPrediction get predictions => _predictions;
  PlaceDetailsData get detailsData => _detailsData;
  Position get currentPosition => _currentPosition;
  ModelState get state => _state;
  ModelState get detailState => _detailState;

  void setPredictionsState(PlacesPrediction predictions){
    _predictions = predictions;

    if(predictions.placesList.length == 0){
      _state = ModelState.EMPTY;
    }else{
      _state = ModelState.COMPLETE;
    }
    notifyListeners();
  }

  void setMapDetailsState(PlaceDetailsData details){
    _detailsData = details;

    if(predictions.placesList.length == 0){
      _detailState = ModelState.EMPTY;
    }else{
      _detailState = ModelState.COMPLETE;
    }

    notifyListeners();
  }

  void setState(ModelState state){
    _state = state;
    notifyListeners();
  }

  void setDetailsState(ModelState state){
    _detailState = state;
    notifyListeners();
  }



  Future<void> getPredictionsWithValue(String value) async{
    setState(ModelState.LOADING);

    PlacesPrediction predictions =  await _repository.getPredictions(value);

    setPredictionsState(predictions);
  }

  Future<Map<String, dynamic>> getPredictionsWithValue2(String value) async{
    Map<String, dynamic> result = Map();
    result['error'] = false;
    try{
      PlacesPrediction predictions =  await _repository.getPredictions(value);
      result['prediction'] = predictions;
    }catch(e){
      result['error'] = false;
      print("jjj,l ${e.toString()}");
    }


    return result;
  }

  Future<PlaceDetailsData> getMapDetailsWithId(String placeId) async{
    setDetailsState(ModelState.LOADING);

    PlaceDetailsData details = await _detailsRepository.getDetails(placeId);
    print(details.formatted_address);

    setMapDetailsState(details);
  }

  Future<Map<String, dynamic>> getMapDetailsWithId2(String placeId) async{
    Map<String, dynamic> result = Map();
    result['error'] = false;
    try{
      PlaceDetailsData details = await _detailsRepository.getDetails(placeId);
      result['details'] = details;
      print(details.formatted_address);
    }catch(e){
      result['error'] = false;
      print("jjj,k ${e.toString()}");
    }
    return result;
  }

  Future<Position> getPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void reset(){
    _detailState = ModelState.INIT;
    _state = ModelState.INIT;
    _detailsData = null;
    _predictions = null;
  }
}