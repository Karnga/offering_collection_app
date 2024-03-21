// To parse this JSON data, do
//
// final User = UserFromJson(jsonString);

import 'dart:convert';

User UserFromJson(String str) => User.fromJson(json.decode(str));

String UserToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.email,
    required this.username,
    required this.profile_pic,
    required this.names,
    required this.contact,
    required this.fav_bible_verse,
    required this.date_created,
  });

  String email;
  final String username;
  final String profile_pic;
  final String names;
  final String contact;
  final String fav_bible_verse;
  final String date_created;

  factory User.fromJson(Map<String, dynamic> json) => User(
      username: json["username"],
      email: json["email"],
      profile_pic: json["profile_pic"],
      names: json["names"],
      contact: json["contact"],
      fav_bible_verse: json["fav_bible_verse"],
      date_created: json["date_created"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "profile_pic": profile_pic,
        "names": names,
        "contact": contact,
        "fav_bible_verse": fav_bible_verse,
        "date_created": date_created,
      };
}
