// To parse this JSON data, do
//
//     final busBook = busBookFromJson(jsonString);

// List<BusBook> busBookFromJson(String str) => List<BusBook>.from(json.decode(str).map((x) => BusBook.fromJson(x)));
//
// String busBookToJson(List<BusBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusBook {
  BusBook({
    required this.busCapacity,
    required this.busReserve,
    required this.busAvailable,
    required this.opened,
    required this.count,
  });

  String busCapacity;
  String busReserve;
  String busAvailable;
  String count;
  List<Opened> opened;

  factory BusBook.fromJson(Map<String, dynamic> json) => BusBook(
        busCapacity: json["bus_capacity"],
        busReserve: json["bus_reserve"],
        busAvailable: json["bus_available"],
        count: json["count"],
        opened:
            List<Opened>.from(json["opened"].map((x) => Opened.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bus_capacity": busCapacity,
        "bus_reserve": busReserve,
        "bus_available": busAvailable,
        "count": count,
        "opened": List<dynamic>.from(opened.map((x) => x.toJson())),
      };
}

class Opened {
  Opened({
    required this.id,
    required this.label,
  });

  String id;
  String label;

  factory Opened.fromJson(Map<String, dynamic> json) => Opened(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
      };
}
