import 'package:mobi/models/place_prediction.dart';
import 'package:mobi/services/places_prediction_api.dart';

import '../locator.dart';

class PlacesPredictionRepository{
  final PlacesPredictionApi _client = locator<PlacesPredictionApi>();


  Future<PlacesPrediction> getPredictions(String term) async{
    print(term);
    final result = await _client.getPredictedPlaces(term);
    return result;
  }
}