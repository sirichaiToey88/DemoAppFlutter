import 'package:demo_app/model/list_product/order_user.dart';

class OrderData {
  final Map<String, List<Order>> groupedOrders;
  final double total;

  OrderData({
    required this.groupedOrders,
    required this.total,
  });
}
