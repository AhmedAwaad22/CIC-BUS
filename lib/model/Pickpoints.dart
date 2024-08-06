// To parse this JSON data, do
//
//     final pickupElement = pickupElementFromJson(jsonString);

import 'dart:convert';

List<PickupElement> pickupElementFromJson(String str) =>
    List<PickupElement>.from(
        json.decode(str).map((x) => PickupElement.fromJson(x)));

String pickupElementToJson(List<PickupElement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickupElement {
  PickupElement({
    required this.pickup,
    required this.activeStatus,
    required this.activeMsg,
    required this.nameStatus,
    required this.driverName,
    required this.busNumber,
    required this.driverNo,
  });

  List<Pickup> pickup;
  String activeStatus;
  String activeMsg;
  String nameStatus;
  String driverName;
  String busNumber;
  String driverNo;

  factory PickupElement.fromJson(Map<String, dynamic> json) => PickupElement(
        pickup:
            List<Pickup>.from(json["pickup"].map((x) => Pickup.fromJson(x))),
        activeStatus: json["active_status"],
        activeMsg: json["active_msg"],
        nameStatus: json["name_status"],
        driverName: json["driver_name"],
        busNumber: json["bus_number"] ,
        driverNo: json["driver_no"],
      );

  Map<String, dynamic> toJson() => {
        "pickup": List<dynamic>.from(pickup.map((x) => x.toJson())),
        "active_status": activeStatus,
        "active_msg": activeMsg,
        "name_status": nameStatus,
        "driver_name": driverName,
        "bus_number": busNumber,
        "driver_no": driverNo,
      };
}

class Pickup {
  Pickup({
    required this.pickId,
    required this.pickNameEn,
    required this.pickNameAr,
    required this.pickTime,
    required this.pickDay,
    required this.pickDate,
    required this.pickSort,
    required this.pickImage,
    required this.pickMsg,
    required this.bothStatus,
  });

  String pickId;
  String pickNameEn;
  String pickNameAr;
  String pickTime;
  String pickDay;
  String pickDate;
  String pickSort;
  String pickImage;
  String pickMsg;
  String bothStatus;

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
        pickId: json["pick_id"],
        pickNameEn: json["pick_name_en"],
        pickNameAr: json["pick_name_ar"],
        pickTime: json["pick_time"],
        pickDay: json["pick_day"],
        pickDate: json["pick_date"],
        pickSort: json["pick_sort"],
        pickImage: json["pick_image"],
        pickMsg: json["pick_msg"],
        bothStatus: json["both_status"],
      );

  Map<String, dynamic> toJson() => {
        "pick_id": pickId,
        "pick_name_en": pickNameEn,
        "pick_name_ar": pickNameAr,
        "pick_time": pickTime,
        "pick_day": pickDay,
        "pick_date": pickDate,
        "pick_sort": pickSort,
        "pick_image": pickImage,
        "pick_msg": pickMsg,
        "both_status": bothStatus,
      };
}
