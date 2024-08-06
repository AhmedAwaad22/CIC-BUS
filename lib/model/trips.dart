// To parse this JSON data, do
//
//     final trips = tripsFromJson(jsonString);

import 'dart:convert';

// List<Trips> tripsFromJson(String str) =>
//     List<Trips>.from(json.decode(str).map((x) => Trips.fromJson(x)));
//
// String tripsToJson(List<Trips> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trips {
  Trips({
    required this.busId,
    required  this.capacity,
    required this.busnumber,
    required  this.enName,
    required this.arName,
    required  this.stationPrice,
    required  this.image,
    required this.pickMsg,
  });

   String busId;
   String capacity;
   String busnumber;
   String enName;
   String arName;
   String stationPrice;
   String image;
   String pickMsg;

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
        busId: json["BusId"],
        capacity: json["capacity"],
        busnumber: json["busnumber"],
        enName: json["en_name"],
        arName: json["ar_name"],
        stationPrice: json["station_price"],
        image: json["image"],
        pickMsg: json["pick_msg"],
      );

  Map<String, dynamic> toJson() => {
        "BusId": busId,
        "capacity": capacity,
        "busnumber": busnumber,
        "en_name": enName,
        "ar_name": arName,
        "station_price": stationPrice,
        "image": image,
        "pick_msg": pickMsg,
      };
}
