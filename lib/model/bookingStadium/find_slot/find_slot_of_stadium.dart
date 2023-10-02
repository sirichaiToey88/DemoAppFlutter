import 'dart:convert';

List<FindSlotInStadium> findSlotInStadiumFromJson(String str) => List<FindSlotInStadium>.from(json.decode(str).map((x) => FindSlotInStadium.fromJson(x)));

String findSlotInStadiumToJson(List<FindSlotInStadium> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FindSlotInStadium {
  final String startTime;
  final String endTime;

  FindSlotInStadium({
    required this.startTime,
    required this.endTime,
  });

  factory FindSlotInStadium.fromJson(Map<String, dynamic> json) => FindSlotInStadium(
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
      };
}
