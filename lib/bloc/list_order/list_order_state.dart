part of 'list_order_bloc.dart';

enum FetchStatus {
  fetching,
  success,
  failed,
  init,
  showDeleteConfirmation
}

class ListOrderState extends Equatable {
  final List<Order> orderList;
  final FetchStatus status;
  final Map<String, List<Order>> groupedOrders;
  final double total;
  final double totalCart;

  ListOrderState({
    required this.orderList,
    required this.groupedOrders,
    this.status = FetchStatus.init,
    this.total = 0.0,
    this.totalCart = 0.0,
  });

  ListOrderState copyWith({
    List<Order>? orderList,
    Map<String, List<Order>>? groupedOrders,
    FetchStatus? status,
    double? total,
    double? totalCart,
  }) {
    return ListOrderState(
      orderList: orderList ?? this.orderList,
      groupedOrders: groupedOrders ?? this.groupedOrders,
      status: status ?? this.status,
      total: total ?? this.total,
      totalCart: totalCart ?? this.totalCart,
    );
  }

  @override
  List<Object> get props => [
        status,
        orderList,
        groupedOrders,
        total,
        totalCart,
      ];
}
