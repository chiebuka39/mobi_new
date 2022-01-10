import 'package:google_maps_webservice/places.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/place_prediction.dart';


class PlacesPredictionApi{
  static PlacesPredictionApi _instance;
  static PlacesPredictionApi getInstance() => _instance ??= PlacesPredictionApi();

  Future<PlacesPrediction> getPredictedPlaces(String location) async {
    final googlePlaces = GoogleMapsPlaces(apiKey: MyStrings.apiKey);
//    final response1 = await googlePlaces.searchNearbyWithRadius(location, radius);
    print("is $location");

    final response = await googlePlaces.autocomplete(location, components: [Component(Component.country, "ng")]);
    print(response.errorMessage);
    return PlacesPrediction.convertToPredictedPlace(response);
  }

}