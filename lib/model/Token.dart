
class TokenTake {
  TokenTake({
   required this.token,
  });

  String token;

  factory TokenTake.fromJson(Map<String, dynamic> json) => TokenTake(
    token: json["_token"],
  );

  Map<String, dynamic> toJson() => {
    "_token": token,
  };
}
