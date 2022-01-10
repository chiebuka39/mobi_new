import 'package:mobi/models/location.dart';


class RideRequest{
  String name;
  String phone;
  TheLocation locationFrom;
  TheLocation locationTo;

  RideRequest.initialize({
    this.name,this.phone, this.locationFrom, this.locationTo
});
}