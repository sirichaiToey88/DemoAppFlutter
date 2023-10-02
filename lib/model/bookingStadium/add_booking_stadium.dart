import 'dart:convert';

AddBookingStadium addBookingStadiumFromJson(String str) => AddBookingStadium.fromJson(json.decode(str));

String addBookingStadiumToJson(AddBookingStadium data) => json.encode(data.toJson());

class AddBookingStadium {
  final String userId;
  final String brandId;
  final String stadiumId;
  final String reservationHours;
  final String reservationDate;
  final String startTime;
  final String endTime;

  AddBookingStadium({
    required this.userId,
    required this.brandId,
    required this.stadiumId,
    required this.reservationHours,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
  });

  factory AddBookingStadium.fromJson(Map<String, dynamic> json) => AddBookingStadium(
        userId: json["User_id"],
        brandId: json["Brand_id"],
        stadiumId: json["Stadium_id"],
        reservationHours: json["Reservation_hours"],
        reservationDate: json["Reservation_date"],
        startTime: json["Start_time"],
        endTime: json["End_time"],
      );

  Map<String, dynamic> toJson() => {
        "User_id": userId,
        "Brand_id": brandId,
        "Stadium_id": stadiumId,
        "Reservation_hours": reservationHours,
        "Reservation_date": reservationDate,
        "Start_time": startTime,
        "End_time": endTime,
      };
}
