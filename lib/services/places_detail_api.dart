import 'package:google_maps_webservice/places.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/place_details_data.dart';


class PlaceDetailsApi{
  static PlaceDetailsApi _instance ;
  static PlaceDetailsApi getInstance() => _instance ??= PlaceDetailsApi();

  Future<PlaceDetailsData> getPlaceDetails(String placeId) async{
    final googlePlaces = GoogleMapsPlaces(apiKey: MyStrings.apiKey);

    final response = await googlePlaces.getDetailsByPlaceId(placeId);
    return PlaceDetailsData.convertToPlaceDetails(response);
  }
}