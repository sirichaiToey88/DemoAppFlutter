import 'dart:convert';

CreateBrand createBrandFromJson(String str) => CreateBrand.fromJson(json.decode(str));

String createBrandToJson(CreateBrand data) => json.encode(data.toJson());

class CreateBrand {
  final String brandTitle;
  final String imageUrl;
  final String timeOpen;
  final String timeClose;
  final String location;
  final String tell;
  final String address;
  final Map<String, dynamic> stadiums;
  CreateBrand({
    required this.brandTitle,
    required this.imageUrl,
    required this.timeOpen,
    required this.timeClose,
    required this.location,
    required this.tell,
    required this.address,
    required this.stadiums,
  });

  factory CreateBrand.fromJson(Map<String, dynamic> json) => CreateBrand(
        brandTitle: json["brand_title"],
        imageUrl: json["image_url"],
        timeOpen: json["time_open"],
        timeClose: json["time_close"],
        location: json["location"],
        tell: json["tell"],
        address: json["address"],
        stadiums: Map<String, dynamic>.from(json["stadiums"]),
      );

  Map<String, dynamic> toJson() => {
        "brand_title": brandTitle,
        "image_url": imageUrl,
        "time_open": timeOpen,
        "time_close": timeClose,
        "location": location,
        "tell": tell,
        "address": address,
        "stadiums": stadiums,
      };
}

class Stadium {
  final String typeStadium;
  final String imageUrl;
  final String stadiumNumber;
  final String price;

  Stadium({
    required this.typeStadium,
    required this.imageUrl,
    required this.stadiumNumber,
    required this.price,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) => Stadium(
        typeStadium: json["type_stadium"],
        imageUrl: json["image_url"],
        stadiumNumber: json["stadium_number"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "type_stadium": typeStadium,
        "image_url": imageUrl,
        "stadium_number": stadiumNumber,
        "price": price,
      };
}
