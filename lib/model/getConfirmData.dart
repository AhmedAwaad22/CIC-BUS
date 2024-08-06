// To parse this JSON data, do
//
//     final getConfirmData = getConfirmDataFromJson(jsonString);

import 'dart:convert';

List<GetConfirmData> getConfirmDataFromJson(String str) =>
    List<GetConfirmData>.from(
        json.decode(str).map((x) => GetConfirmData.fromJson(x)));

String getConfirmDataToJson(List<GetConfirmData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetConfirmData {
  GetConfirmData({
    required this.busName,
    required this.pickName,
    required this.toTitle,
    required this.fromTitle,
    required this.toPickTime,
    required this.fromPickTime,
    required this.pickDate,
    required this.count,
    required this.toPay,
    required this.openPromo,
    required this.promo,
    required this.promoMsg,
    required this.toPayAfter,
    required this.currentBalance,
    required this.balanceAfter,
    required this.balanceType,
    required this.message,
    required this.pickMsg,
    required this.bothMsg,
    required this.bothStatus,
    required this.limit,
    required this.payStatus,
  });

  String busName;
  String pickName;
  String toTitle;
  String fromTitle;
  String toPickTime;
  String fromPickTime;
  String pickDate;
  String count;
  String toPay;
  String openPromo;
  String promo;
  String promoMsg;
  String toPayAfter;
  String currentBalance;
  String balanceAfter;
  String balanceType;
  String message;
  String pickMsg;
  String bothMsg;
  String bothStatus;
  String limit;
  String payStatus;

  factory GetConfirmData.fromJson(Map<String, dynamic> json) => GetConfirmData(
        busName: json["bus_name"],
        pickName: json["pick_name"],
        toTitle: json["to_title"],
        fromTitle: json["from_title"],
        toPickTime: json["to_pick_time"],
        fromPickTime: json["from_pick_time"],
        pickDate: json["pick_date"],
        count: json["count"],
        toPay: json["to_pay"],
        openPromo: json["openPromo"],
        promo: json["promo"],
        promoMsg: json["promo_msg"],
        toPayAfter: json["to_pay_after"],
        currentBalance: json["current_balance"],
        balanceAfter: json["balance_after"],
        balanceType: json["balance_type"],
        message: json["message"],
        pickMsg: json["pick_msg"],
        bothMsg: json["both_msg"],
        bothStatus: json["both_status"],
        limit: json["limit"],
        payStatus: json["pay_status"],
      );

  Map<String, dynamic> toJson() => {
        "bus_name": busName,
        "pick_name": pickName,
        "to_title": toTitle,
        "from_title": fromTitle,
        "to_pick_time": toPickTime,
        "from_pick_time": fromPickTime,
        "pick_date": pickDate,
        "count": count,
        "to_pay": toPay,
        "openPromo": openPromo,
        "promo": promo,
        "promo_msg": promoMsg,
        "to_pay_after": toPayAfter,
        "current_balance": currentBalance,
        "balance_after": balanceAfter,
        "balance_type": balanceType,
        "message": message,
        "pick_msg": pickMsg,
        "both_msg": bothMsg,
        "both_status": bothStatus,
        "limit": limit,
        "pay_status": payStatus,
      };
}
