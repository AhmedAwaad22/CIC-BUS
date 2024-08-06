// To parse this JSON data, do
//
//     final busdata = busdataFromJson(jsonString);

import 'dart:convert';

List<Busdata> busdataFromJson(String str) => List<Busdata>.from(json.decode(str).map((x) => Busdata.fromJson(x)));

String busdataToJson(List<Busdata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Busdata {
  Busdata({
    required this.buss,
    required this.activeStatus,
    required this.activeMsg,
  });

  List<Buss> buss;
  String activeStatus;
  String activeMsg;

  factory Busdata.fromJson(Map<String, dynamic> json) => Busdata(
    buss: List<Buss>.from(json["buss"].map((x) => Buss.fromJson(x))),
    activeStatus: json["active_status"],
    activeMsg: json["active_msg"],
  );

  Map<String, dynamic> toJson() => {
    "buss": List<dynamic>.from(buss.map((x) => x.toJson())),
    "active_status": activeStatus,
    "active_msg": activeMsg,
  };
}

class Buss {
  Buss({
    required this.busId,
    required this.capacity,
    required  this.busnumber,
    required  this.enName,
    required this.arName,
    required this.stationPrice,
    required  this.image,
    required  this.pickMsg,
    required this.tripId,
  });

  String busId;
  String capacity;
  String busnumber;
  String enName;
  String arName;
  String stationPrice;
  String image;
  String pickMsg;
  String tripId;

  factory Buss.fromJson(Map<String, dynamic> json) => Buss(
    busId: json["BusId"],
    capacity: json["capacity"],
    busnumber: json["busnumber"],
    enName: json["en_name"],
    arName: json["ar_name"],
    stationPrice: json["station_price"],
    image: json["image"],
    pickMsg: json["pick_msg"],
    tripId: json["trip_id"],
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
    "trip_id": tripId,
  };
}
