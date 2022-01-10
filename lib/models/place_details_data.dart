

import 'package:google_maps_webservice/places.dart';
import 'package:mobi/extras/utils.dart';

class PlaceDetailsData{
  final String formatted_address;
  final String second_address;
  final double lat;
  final double lon;
  final String icon;
  final String url;
  final String id;
  final String placeId;

  PlaceDetailsData({this.formatted_address, this.lat, this.lon, this.icon, this.url, this.id, this.placeId, this.second_address});

  static convertToPlaceDetails(PlacesDetailsResponse response){
    pprint("addresss -- ${response.result.addressComponents.first.longName} -- ${response.result.addressComponents.first.shortName} -0- ${response.result.adrAddress}");
    return PlaceDetailsData(
        formatted_address: response.result.formattedAddress,
        second_address: response.result.addressComponents.first.shortName,
        lat: response.result.geometry.location.lat,
        lon: response.result.geometry.location.lng,
        icon: response.result.icon,
        url: response.result.url,
        id: response.result.id,
        placeId: response.result.placeId
    );
  }

}