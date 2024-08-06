class UserData {
  UserData({
   required this.login,
    required this.campus,
    required this.username,
    required  this.token,
  });

  bool login;
  String campus;
  String username;
  String token;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    login: json["login"],
    campus: json["campus"],
    username: json["username"] as String,
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "campus": campus,
    "username": username,
    "token": token,
  };
}
