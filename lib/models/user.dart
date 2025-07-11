class User {
  String name;
  String phoneNumber;
  String password;
  String profilePic;
  List<String> watchlist;

  User({
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.profilePic,
    required this.watchlist
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        profilePic: json["profilePic"],
        watchlist: (json['watchlist'] as List<dynamic>?)
           ?.map((item) => item.toString())
           .toList() ?? [],

      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
    "password": password,
    "profilePic": profilePic,
    "watchlist": watchlist
  };


}