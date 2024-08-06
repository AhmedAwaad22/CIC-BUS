// To parse this JSON data, do
//
//     final lDap = lDapFromJson(jsonString);

import 'dart:convert';

LDap lDapFromJson(String str) => LDap.fromJson(json.decode(str));

String lDapToJson(LDap data) => json.encode(data.toJson());

class LDap {
  LDap({
   required this.login,
    required this.campus,
    required this.username,
    required  this.fullname,
    required this.cicid,
    required this.fullName,
    required this.token,
  });

  bool login;
  String campus;
  String username;
  String fullname;
  String cicid;
  String fullName;
  String token;

  factory LDap.fromJson(Map<String, dynamic> json) => LDap(
    login: json["login"],
    campus: json["campus"],
    username: json["username"],
    fullname: json["fullname"],
    cicid: json["cicid"],
    fullName: json["full_name"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "campus": campus,
    "username": username,
    "fullname": fullname,
    "cicid": cicid,
    "full_name": fullName,
    "token": token,
  };
}
