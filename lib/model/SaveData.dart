// To parse this JSON data, do
//
//     final sava = savaFromJson(jsonString);

import 'dart:convert';

List<Sava> savaFromJson(String str) => List<Sava>.from(json.decode(str).map((x) => Sava.fromJson(x)));

String savaToJson(List<Sava> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sava {
  Sava({
   required this.busName,
    required this.pickName,
    required this.toPickTime,
    required this.fromPickTime,
    required this.pickDate,
    required this.count,
    required this.toPay,
    required this.currentBalance,
    required this.balanceAfter,
    required this.balanceType,
    required  this.ticketTo,
    required  this.ticketFrom,
    required  this.message,
    required  this.bothStatus,
  });

  String busName;
  String pickName;
  String toPickTime;
  String fromPickTime;
  String pickDate;
  String count;
  String toPay;
  String currentBalance;
  String balanceAfter;
  String balanceType;
  String ticketTo;
  String ticketFrom;
  String message;
  String bothStatus;

  factory Sava.fromJson(Map<String, dynamic> json) => Sava(
    busName: json["bus_name"],
    pickName: json["pick_name"],
    toPickTime: json["to_pick_time"],
    fromPickTime: json["from_pick_time"],
    pickDate: json["pick_date"],
    count: json["count"],
    toPay: json["to_pay"],
    currentBalance: json["current_balance"],
    balanceAfter: json["balance_after"],
    balanceType: json["balance_type"],
    ticketTo: json ["ticket_to"],
    ticketFrom: json["ticket_from"],
    message: json["message"],
    bothStatus: json["both_status"],
  );

  Map<String, dynamic> toJson() => {
    "bus_name": busName,
    "pick_name": pickName,
    "to_pick_time": toPickTime,
    "from_pick_time": fromPickTime,
    "pick_date": pickDate,
    "count": count,
    "to_pay": toPay,
    "current_balance": currentBalance,
    "balance_after": balanceAfter,
    "balance_type": balanceType,
    "ticket_to": ticketTo,
    "ticket_from": ticketFrom,
    "message": message,
    "both_status": bothStatus,
  };
}
