// To parse this JSON data, do
//
//     final numbers = numbersFromJson(jsonString);

import 'dart:convert';

// Numbers numbersFromJson(String str) => Numbers.fromJson(json.decode(str));
//
// String numbersToJson(Numbers data) => json.encode(data.toJson());

class Numbers {
  Numbers({
    required this.id,
    required this.label,
  });

  int id;
  String label;

  factory Numbers.fromJson(Map<String, dynamic> json) => Numbers(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
      };
}
