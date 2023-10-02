import 'dart:convert';

OrderByUserModel orderByUserModelFromJson(String str) => OrderByUserModel.fromJson(json.decode(str));

String orderByUserModelToJson(OrderByUserModel data) => json.encode(data.toJson());

class OrderByUserModel {
  final List<Order> order;
  final double total;

  OrderByUserModel({
    required this.order,
    required this.total,
  });

  factory OrderByUserModel.fromJson(Map<String, dynamic> json) => OrderByUserModel(
        order: List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
        total: json["total"].toDouble(),
      );

  get payment => null;

  Map<String, dynamic> toJson() => {
        "order": List<dynamic>.from(order.map((x) => x.toJson())),
        "total": total,
      };
}

class Order {
  final String id;
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String productPrice;
  final String totalAmount;
  final String quantityProduct;
  final String paymentType;
  final String imageUrl;
  final Payment payment;
  final DateTime createDate;
  final DateTime modifyDate;

  Order({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.totalAmount,
    required this.quantityProduct,
    required this.paymentType,
    required this.imageUrl,
    required this.payment,
    required this.createDate,
    required this.modifyDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderId: json["order_id"],
        userId: json["User_id"],
        productId: json["Product_id"],
        productTitle: json["Product_title"],
        productPrice: json["Product_price"],
        totalAmount: json["Total_amount"],
        quantityProduct: json["Quantity_product"],
        paymentType: json["Payment_type"],
        imageUrl: json["Image_url"],
        payment: Payment.fromJson(json["Payment"]),
        createDate: DateTime.parse(json["create_date"]),
        modifyDate: DateTime.parse(json["modify_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "User_id": userId,
        "Product_id": productId,
        "Product_title": productTitle,
        "Product_price": productPrice,
        "Total_amount": totalAmount,
        "Quantity_product": quantityProduct,
        "Payment_type": paymentType,
        "Image_url": imageUrl,
        "Payment": payment.toJson(),
        "create_date": createDate.toIso8601String(),
        "modify_date": modifyDate.toIso8601String(),
      };
}

class Payment {
  final String id;
  final String orderId;
  final String account;
  final String source;
  final String distination;
  final String total;
  final DateTime createDate;
  final DateTime modifyDate;

  Payment({
    required this.id,
    required this.orderId,
    required this.account,
    required this.source,
    required this.distination,
    required this.total,
    required this.createDate,
    required this.modifyDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        orderId: json["order_id"],
        account: json["account"],
        source: json["source"],
        distination: json["distination"],
        total: json["total"],
        createDate: DateTime.parse(json["create_date"]),
        modifyDate: DateTime.parse(json["modify_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "account": account,
        "source": source,
        "distination": distination,
        "total": total,
        "create_date": createDate.toIso8601String(),
        "modify_date": modifyDate.toIso8601String(),
      };
}
