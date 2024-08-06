// To parse this JSON data, do
//
//     final busList = busListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

// List<BusList> busListFromJson(String str) => List<BusList>.from(json.decode(str).map((x) => BusList.fromJson(x)));
//
// String busListToJson(List<BusList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusList {
  BusList({
    required  this.busId,
    required  this.capacity,
    required this.busnumber,
    required  this.enName,
    required  this.arName,
    required  this.stationPrice,
    required  this.image,
    required this.pickup,
    required this.cancelStatus,
    required  this.subscription,
    required this.subscriptionMessage,
    required  this.reservationStatus,
    required  this.reservation,
    required  this.currentBalance,
    required  this.balanceType,
  });

  String busId;
  String capacity;
  String busnumber;
  String enName;
  String arName;
  String stationPrice;
  String image;
  List<Pickup> pickup;
  String cancelStatus;
  String subscription;
  String subscriptionMessage;
  String reservationStatus;
  List<Reservation> reservation;
  int currentBalance;
  String balanceType;

  factory BusList.fromJson(Map<String, dynamic> json) => BusList(
    busId: json["BusId"],
    capacity:  json["capacity"],
    busnumber:  json["busnumber"],
    enName:  json["en_name"],
    arName:  json["ar_name"],
    stationPrice:json["station_price"],
    image: json["image"],
    pickup:  List<Pickup>.from(json["pickup"].map((x) => Pickup.fromJson(x))),
    cancelStatus:  json["cancel_status"],
    subscription:  json["subscription"],
    subscriptionMessage:  json["subscription_message"],
    reservationStatus:  json["reservation_status"],
    reservation:  List<Reservation>.from(json["reservation"].map((x) => Reservation.fromJson(x))),
    currentBalance:  json["CurrentBalance"],
    balanceType: json["BalanceType"],
  );

  Map<String, dynamic> toJson() => {
    "BusId":  busId,
    "capacity": capacity,
    "busnumber":  busnumber,
    "en_name":  enName,
    "ar_name":  arName,
    "station_price":  stationPrice,
    "image": image,
    "pickup": List<dynamic>.from(pickup.map((x) => x.toJson())),
    "cancel_status":  cancelStatus,
    "subscription": subscription,
    "subscription_message":subscriptionMessage,
    "reservation_status":  reservationStatus,
    "reservation":  List<dynamic>.from(reservation.map((x) => x.toJson())),
    "CurrentBalance": currentBalance,
    "BalanceType": balanceType,
  };
}

class Pickup {
  Pickup({
    required this.pickId,
    required this.pickNameEn,
    required this.pickNameAr,
    required  this.pickTime,
    required  this.pickSort,
    required this.pickImage,
  });

  String pickId;
  String pickNameEn;
  String pickNameAr;
  String pickTime;
  String pickSort;
  String pickImage;

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    pickId: json["pick_id"],
    pickNameEn: json["pick_name_en"],
    pickNameAr: json["pick_name_ar"],
    pickTime: json["pick_time"],
    pickSort: json["pick_sort"],
    pickImage: json["pick_image"],
  );

  Map<String, dynamic> toJson() => {
    "pick_id": pickId,
    "pick_name_en": pickNameEn,
    "pick_name_ar": pickNameAr,
    "pick_time": pickTime,
    "pick_sort": pickSort,
    "pick_image": pickImage,
  };
}

class Reservation {
  Reservation({
    required  this.busName,
    required  this.pickName,
    required  this.pickTime,
    required this.ticketNo,
    required  this.message,
  });

  String busName;
  String pickName;
  String pickTime;
  String ticketNo;
  String message;

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    busName: json["bus_name"],
    pickName: json["pick_name"],
    pickTime: json["pick_time"],
    ticketNo: json["ticket_no"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "bus_name": busName,
    "pick_name": pickName,
    "pick_time": pickTime,
    "ticket_no": ticketNo,
    "message": message,
  };
}
