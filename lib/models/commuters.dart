import 'package:mobi/extras/enums.dart';


class Commuter {
  String name;
  DriveOrRide driveOrRide;
  String destination;
  String source;
  String profileImage;

  Commuter(
      {this.name,
      this.driveOrRide,
      this.destination,
      this.profileImage,
      this.source});
}

List<Commuter> comutters = [
  Commuter(
      name: "Harry Potter",
      driveOrRide: DriveOrRide.DRIVE,
      destination: "VI",
      source: "Ikeja",
      profileImage: "assets/img/ebuka.png"),
  Commuter(
      name: "Chiebuka Edwin",
      driveOrRide: DriveOrRide.DRIVE,
      destination: "Agege",
      source: "Oworo",
      profileImage: "assets/img/ebuka.png"),
  Commuter(
      name: "Victor Ego",
      driveOrRide: DriveOrRide.DRIVE,
      destination: "Lekki",
      source: "Egbeda",
      profileImage: "assets/img/ebuka.png"),
  Commuter(
      name: "Faith Shareride",
      driveOrRide: DriveOrRide.RIDE,
      destination: "Mowe",
      source: "Ikeja",
      profileImage: "assets/img/ebuka.png"),
  Commuter(
      name: "Roseline Oworo",
      driveOrRide: DriveOrRide.DRIVE,
      destination: "VGC",
      source: "VI",
      profileImage: "assets/img/ebuka.png"),
];
