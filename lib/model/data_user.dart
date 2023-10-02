import 'dart:convert';

List<DataUser> dataUserFromJson(String str) => List<DataUser>.from(json.decode(str).map((x) => DataUser.fromJson(x)));

String dataUserToJson(List<DataUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataUser {
  final int userId;
  final int id;
  final String title;
  final String body;

  DataUser({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
