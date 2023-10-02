// To parse this JSON data, do
//
//     final searchSlot = searchSlotFromJson(jsonString);

import 'dart:convert';

SearchSlot searchSlotFromJson(String str) => SearchSlot.fromJson(json.decode(str));

String searchSlotToJson(SearchSlot data) => json.encode(data.toJson());

class SearchSlot {
  final String brandId;
  final String stadiumId;
  final String reservationDate;
  final String reservationHours;

  SearchSlot({
    required this.brandId,
    required this.stadiumId,
    required this.reservationDate,
    required this.reservationHours,
  });

  factory SearchSlot.fromJson(Map<String, dynamic> json) => SearchSlot(
        brandId: json["brand_id"],
        stadiumId: json["stadium_id"],
        reservationDate: json["reservationDate"],
        reservationHours: json["reservationHours"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "stadium_id": stadiumId,
        "reservationDate": reservationDate,
        "reservationHours": reservationHours,
      };
}
