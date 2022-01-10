import 'package:mobi/models/place_details_data.dart';
import 'package:mobi/services/places_detail_api.dart';


import '../locator.dart';

class PlaceDetailsRepository{
  final PlaceDetailsApi _client = locator<PlaceDetailsApi>();



  Future<PlaceDetailsData> getDetails(String placeId) async{
    final result = await _client.getPlaceDetails(placeId);
    print(result.formatted_address);
    print(result.url);
    return result;
  }
}