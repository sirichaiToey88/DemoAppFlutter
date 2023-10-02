import 'dart:convert';

Map<String, ListBrandWithStadium> listBrandWithStadiumFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, ListBrandWithStadium>(k, ListBrandWithStadium.fromJson(v)));

String listBrandWithStadiumToJson(Map<String, ListBrandWithStadium> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class ListBrandWithStadium {
  final String address;
  final String brandTitle;
  final String id;
  final String imageUrl;
  final String location;
  final Map<String, Stadium> stadium;
  final String tell;
  final String timeClose;
  final String timeOpen;

  ListBrandWithStadium({
    required this.address,
    required this.brandTitle,
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.stadium,
    required this.tell,
    required this.timeClose,
    required this.timeOpen,
  });

  factory ListBrandWithStadium.fromJson(Map<String, dynamic> json) => ListBrandWithStadium(
        address: json["address"],
        brandTitle: json["brand_title"],
        id: json["id"],
        imageUrl: json["image_url"],
        location: json["location"],
        stadium: Map.from(json["stadium"]).map((k, v) => MapEntry<String, Stadium>(k, Stadium.fromJson(v))),
        tell: json["tell"],
        timeClose: json["time_close"],
        timeOpen: json["time_open"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "brand_title": brandTitle,
        "id": id,
        "image_url": imageUrl,
        "location": location,
        "stadium": Map.from(stadium).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "tell": tell,
        "time_close": timeClose,
        "time_open": timeOpen,
      };
}

class Stadium {
  final String brandId;
  final String id;
  final String imageUrl;
  final String price;
  final String promotion;
  final String stadiumNumber;
  final String status;
  final String typeStadium;

  Stadium({
    required this.brandId,
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.promotion,
    required this.stadiumNumber,
    required this.status,
    required this.typeStadium,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) => Stadium(
        brandId: json["brand_id"],
        id: json["id"],
        imageUrl: json["image_url"],
        price: json["price"],
        promotion: json["promotion"],
        stadiumNumber: json["stadium_number"],
        status: json["status"],
        typeStadium: json["type_stadium"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "id": id,
        "image_url": imageUrl,
        "price": price,
        "promotion": promotion,
        "stadium_number": stadiumNumber,
        "status": status,
        "type_stadium": typeStadium,
      };
}
