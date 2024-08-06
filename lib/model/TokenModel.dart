// To parse this JSON data, do
//
//     final tokenApiNew = tokenApiNewFromJson(jsonString);

import 'dart:convert';

List<TokenApiNew> tokenApiNewFromJson(String str) => List<TokenApiNew>.from(json.decode(str).map((x) => TokenApiNew.fromJson(x)));

String tokenApiNewToJson(List<TokenApiNew> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TokenApiNew {
  TokenApiNew({
    required this.token,
  });

  String token;

  factory TokenApiNew.fromJson(Map<String, dynamic> json) => TokenApiNew(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}
