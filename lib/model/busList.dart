class BusList {
  final String? name;
  final String? image;
  final String? desc;
  final String? title;
  final String? img_detaile_screen;
  final List<String> pickupPoints;

  BusList(
      {this.name,
      this.image,
      this.desc,
      this.title,
      this.img_detaile_screen,
      required this.pickupPoints});

  factory BusList.fromJson(Map<String, dynamic> json) => BusList(
        name: json['name'],
        image: json['image'],
        desc: json['desc'],
        title: json['title'],
        img_detaile_screen: json['img_detaile_screen'],
        pickupPoints: json['pickupPoints'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'desc': desc,
        'title': title,
        'img_detaile_screen': img_detaile_screen,
        'pickupPoints': pickupPoints,
      };
}
