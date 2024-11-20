// To parse this JSON data, do
//
//     final busList = busListFromJson(jsonString);

import 'dart:convert';

List<BusList> busListFromJson(String str) =>
    List<BusList>.from(json.decode(str).map((x) => BusList.fromJson(x)));

String busListToJson(List<BusList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusList {
  BusList({
    required this.activisionStatus,
    required this.activisionMsg,
    required this.cancelStatus,
    required this.subscription,
    required this.subscriptionMessageAR,
    required this.subscriptionMessageEN,
    required this.reservationStatus,
    required this.reservation,
    required this.currentBalance,
    required this.balanceType,
    required this.policy,
    required this.holdStatus,
    required this.holdMsg,
    required this.token,
    required this.update,
    required this.addbalance,
  });

  String activisionStatus;
  String activisionMsg;
  String cancelStatus;
  String subscription;
  String subscriptionMessageAR;
  String subscriptionMessageEN;
  String reservationStatus;
  List<Reservation> reservation;
  String currentBalance;
  String balanceType;
  String policy;
  String holdStatus;
  String holdMsg;
  String token;
  String update;
  String addbalance;

  factory BusList.fromJson(Map<String, dynamic> json) => BusList(
        activisionStatus: json["activision_status"],
        activisionMsg: json["activision_msg"],
        cancelStatus: json["cancel_status"],
        subscription: json["subscription"],
        subscriptionMessageAR: json["subscription_message_ar"],
        subscriptionMessageEN: json["subscription_message_en"],
        reservationStatus: json["reservation_status"],
        reservation: List<Reservation>.from(
            json["reservation"].map((x) => Reservation.fromJson(x))),
        currentBalance: json["CurrentBalance"],
        balanceType: json["BalanceType"],
        policy: json["policy"],
        holdStatus: json["hold_status"],
        holdMsg: json["hold_msg"],
        token: json["token"],
        update: json["update"],
        addbalance: json["addbalance"],
      );

  Map<String, dynamic> toJson() => {
        "activision_status": activisionStatus,
        "activision_msg": activisionMsg,
        "cancel_status": cancelStatus,
        "subscription": subscription,
        "subscription_messageAR": subscriptionMessageAR,
        "subscription_messageEN": subscriptionMessageEN,
        "reservation_status": reservationStatus,
        "reservation": List<dynamic>.from(reservation.map((x) => x.toJson())),
        "CurrentBalance": currentBalance,
        "BalanceType": balanceType,
        "policy": policy,
        "hold_status": holdStatus,
        "hold_msg": holdMsg,
        "token": token,
        "update": update,
        "addbalance": addbalance,
      };
}

class Reservation {
  Reservation({
    required this.busName,
    required this.pickName,
    required this.pickTime,
    required this.ticketNo,
    required this.pickPrice,
    required this.reserveDate,
    required this.reserveSeat,
    required this.reserveAmount,
    required this.message,
    required this.nameStatus,
    required this.driverName,
    required this.busNumber,
    required this.driverNo,
    required this.studName,
    required this.studId,
    required this.canCancel,
    required this.qrcode,
  });

  String busName;
  String pickName;
  String pickTime;
  String ticketNo;
  String pickPrice;
  String reserveDate;
  String reserveSeat;
  String reserveAmount;
  String message;
  String nameStatus;
  String driverName;
  String busNumber;
  String driverNo;
  String studName;
  String studId;
  String canCancel;
  String qrcode;

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        busName: json["bus_name"],
        pickName: json["pick_name"],
        pickTime: json["pick_time"],
        ticketNo: json["ticket_no"],
        pickPrice: json["pick_price"],
        reserveDate: json["reserve_date"],
        reserveSeat: json["reserve_seat"],
        reserveAmount: json["reserve_amount"],
        message: json["message"],
        nameStatus: json["name_status"],
        driverName: json["driver_name"],
        busNumber: json["bus_number"],
        driverNo: json["driver_no"],
        studName: json["Stud_name"],
        studId: json["Stud_id"],
        canCancel: json["canCancel"],
        qrcode: json["qrcode"],
      );

  Map<String, dynamic> toJson() => {
        "bus_name": busName,
        "pick_name": pickName,
        "pick_time": pickTime,
        "ticket_no": ticketNo,
        "pick_price": pickPrice,
        "reserve_date": reserveDate,
        "reserve_seat": reserveSeat,
        "reserve_amount": reserveAmount,
        "message": message,
        "name_status": nameStatus,
        "driver_name": driverName,
        "bus_number": busNumber,
        "driver_no": driverNo,
        "Stud_name": studName,
        "Stud_id": studId,
        "canCancel": canCancel,
        "qrcode": qrcode,
      };
}
