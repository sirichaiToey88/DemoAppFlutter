import 'dart:convert';

List<BookingsPayment> bookingsPaymentFromJson(String str) => List<BookingsPayment>.from(json.decode(str).map((x) => BookingsPayment.fromJson(x)));

String bookingsPaymentToJson(List<BookingsPayment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingsPayment {
  final String id;
  final String userId;
  final String brandId;
  final String stadiumId;
  final String reservationHours;
  final String reservationDate;
  final String startTime;
  final String endTime;
  final String needToPay;
  final Payment payment;

  BookingsPayment({
    required this.id,
    required this.userId,
    required this.brandId,
    required this.stadiumId,
    required this.reservationHours,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.payment,
    required this.needToPay,
  });

  factory BookingsPayment.fromJson(Map<String, dynamic> json) => BookingsPayment(
        id: json["id"] ?? json["Id"],
        userId: json["User_id"] ?? json["user_id"],
        brandId: json["Brand_id"] ?? json["brand_id"],
        stadiumId: json["Stadium_id"] ?? json["stadium_id"],
        reservationHours: json["Reservation_hours"] ?? json["reservation_hours"],
        reservationDate: json["Reservation_date"] ?? json["reservation_date"],
        startTime: json["Start_time"] ?? json["start_time"],
        endTime: json["End_time"] ?? json["end_time"],
        needToPay: json["Need_to_pay"] ?? '',
        payment: Payment.fromJson(json["Payment"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "User_id": userId,
        "Brand_id": brandId,
        "Stadium_id": stadiumId,
        "Reservation_hours": reservationHours,
        "Reservation_date": reservationDate,
        "Start_time": startTime,
        "End_time": endTime,
        "Need_to_pay": needToPay,
        "Payment": payment.toJson(),
      };
}

class Payment {
  final String userId;
  final String status;
  final dynamic imageUrl;
  final String total;
  final String? createDate;
  final String? modifyDate;
  final String source;
  final String destination;

  Payment({
    required this.userId,
    required this.status,
    required this.imageUrl,
    required this.total,
    required this.createDate,
    required this.modifyDate,
    required this.source,
    required this.destination,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        userId: json["user_id"],
        status: json["status"],
        imageUrl: json["image_url"],
        total: json["total"],
        createDate: json["create_date"],
        modifyDate: json["modify_date"],
        source: json["source"],
        destination: json["destination"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "status": status,
        "image_url": imageUrl,
        "total": total,
        "create_date": createDate,
        "modify_date": modifyDate,
        "source": source,
        "destination": destination,
      };
}
