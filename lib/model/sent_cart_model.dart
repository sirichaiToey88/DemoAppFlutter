import 'dart:convert';

SentCartModel sentCartModelFromJson(String str) => SentCartModel.fromJson(json.decode(str));

String sentCartModelToJson(SentCartModel data) => json.encode(data.toJson());

class SentCartModel {
  final String userId;
  final String productId;
  final String productTitle;
  final String productPrice;
  final String totalAmount;
  final String quantityProduct;
  final String paymentType;
  final String image_url;
  final Payment payment;

  SentCartModel({
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.totalAmount,
    required this.quantityProduct,
    required this.paymentType,
    required this.image_url,
    required this.payment,
  });

  factory SentCartModel.fromJson(Map<String, dynamic> json) => SentCartModel(
        userId: json["User_id"],
        productId: json["Product_id"],
        productTitle: json["Product_title"],
        productPrice: json["Product_price"],
        totalAmount: json["Total_amount"],
        quantityProduct: json["Quantity_product"],
        paymentType: json["Payment_type"],
        image_url: json["Image_url"],
        payment: Payment.fromJson(json["Payment"]),
      );

  Map<String, dynamic> toJson() => {
        "User_id": userId,
        "Product_id": productId,
        "Product_title": productTitle,
        "Product_price": productPrice,
        "Total_amount": totalAmount,
        "Quantity_product": quantityProduct,
        "Payment_type": paymentType,
        "Image_url": image_url,
        "Payment": payment.toJson(),
      };
}

class Payment {
  final String account;
  final String source;
  final String distination;
  final String total;

  Payment({
    required this.account,
    required this.source,
    required this.distination,
    required this.total,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        account: json["account"],
        source: json["source"],
        distination: json["distination"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "account": account,
        "source": source,
        "distination": distination,
        "total": total,
      };
}
