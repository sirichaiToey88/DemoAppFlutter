import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final List<UserDetail> data;
  final String token;

  User({
    required this.data,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        data: List<UserDetail>.from(json["data"].map((x) => UserDetail.fromJson(x))),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "token": token,
      };
}

class UserDetail {
  final String id;
  final DateTime createDate;
  final DateTime modifyDate;
  final String userName;
  final String userId;
  final String mobile;
  final String email;

  UserDetail({
    required this.id,
    required this.createDate,
    required this.modifyDate,
    required this.userName,
    required this.userId,
    required this.mobile,
    required this.email,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        createDate: DateTime.parse(json["create_date"]),
        modifyDate: DateTime.parse(json["modify_date"]),
        userName: json["user_name"],
        userId: json["user_id"],
        mobile: json["mobile"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_date": createDate.toIso8601String(),
        "modify_date": modifyDate.toIso8601String(),
        "user_name": userName,
        "user_id": userId,
        "mobile": mobile,
        "email": email,
      };
}
