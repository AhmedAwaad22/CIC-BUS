class User {
  final String? username;

  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
  };

}
