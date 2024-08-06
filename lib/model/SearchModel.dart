// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

List<SearchModel> searchModelFromJson(String str) => List<SearchModel>.from(
    json.decode(str).map((x) => SearchModel.fromJson(x)));

String searchModelToJson(List<SearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModel {
  SearchModel({
    required this.busId,
    required this.capacity,
    required this.busnumber,
    required this.enName,
    required this.arName,
    required this.stationPrice,
    required this.image,
    required this.pickMsg,
    required this.tripId,
    required this.activeStatus,
    required this.activeMsg,
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
  String activeStatus;
  String activeMsg;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        busId: json["BusId"],
        capacity: json["capacity"],
        busnumber: json["busnumber"],
        enName: json["en_name"],
        arName: json["ar_name"],
        stationPrice: json["station_price"],
        image: json["image"],
        pickMsg: json["pick_msg"],
        tripId: json["trip_id"],
        activeStatus: json["active_status"],
        activeMsg: json["active_msg"],
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
        "active_status": activeStatus,
        "active_msg": activeMsg,
      };
}
