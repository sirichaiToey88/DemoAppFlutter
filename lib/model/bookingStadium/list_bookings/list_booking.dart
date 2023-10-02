import 'dart:convert';

List<ListBookings> listBookingsFromJson(String str) => List<ListBookings>.from(json.decode(str).map((x) => ListBookings.fromJson(x)));

String listBookingsToJson(List<ListBookings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListBookings {
  final String id;
  final String userId;
  final String brandId;
  final String stadiumId;
  final String reservationHours;
  final String reservationDate;
  final String startTime;
  final String endTime;
  final String createDate;
  final String modifyDate;
  final String del;
  final String statusPayment;
  final String brandTitle;
  final String stadiumNumber;
  final String totalPrice;
  final String paymentStatus;
  final String overDue;

  ListBookings({
    required this.id,
    required this.userId,
    required this.brandId,
    required this.stadiumId,
    required this.reservationHours,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.createDate,
    required this.modifyDate,
    required this.del,
    required this.statusPayment,
    required this.brandTitle,
    required this.stadiumNumber,
    required this.totalPrice,
    required this.paymentStatus,
    required this.overDue,
  });

  factory ListBookings.fromJson(Map<String, dynamic> json) => ListBookings(
        id: json["id"],
        userId: json["user_id"],
        brandId: json["brand_id"],
        stadiumId: json["stadium_id"],
        reservationHours: json["reservation_hours"],
        reservationDate: json["reservation_date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createDate: json["create_date"],
        modifyDate: json["modify_date"],
        del: json["del"],
        statusPayment: json["status_payment"],
        brandTitle: json["brand_title"],
        stadiumNumber: json["stadium_number"],
        totalPrice: json["total_price"],
        paymentStatus: json["payment_success"],
        overDue: json["over_due"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "brand_id": brandId,
        "stadium_id": stadiumId,
        "reservation_hours": reservationHours,
        "reservation_date": reservationDate,
        "start_time": startTime,
        "end_time": endTime,
        "create_date": createDate,
        "modify_date": modifyDate,
        "del": del,
        "status_payment": statusPayment,
        "brand_title": brandTitle,
        "stadium_number": stadiumNumber,
        "total_price": totalPrice,
        "payment_success": paymentStatus,
        "over_due": overDue
      };
}
