// To parse this JSON data, do
//
// final church = churchFromJson(jsonString);

import 'dart:convert';

Church churchFromJson(String str) => Church.fromJson(json.decode(str));

String churchToJson(Church data) => json.encode(data.toJson());

class Church {
  Church({
    required this.id,
    required this.logo,
    required this.name,
    required this.email,
    required this.contact,
    required this.location,
    required this.login,
  });
  final String id;
  final String logo;
  final String name;
  String email;
  final String contact;
  final String location;
  final String login;

  factory Church.fromJson(Map<String, dynamic> json) => Church(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        email: json["email"],
        contact: json["contact"],
        location: json["location"],
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "email": email,
        "contact": contact,
        "location": location,
        "login": login,
      };
}
