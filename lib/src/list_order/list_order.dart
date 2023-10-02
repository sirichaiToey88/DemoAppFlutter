import 'package:demo_app/bloc/list_order/list_order_bloc.dart';
import 'package:demo_app/model/list_product/order_user.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/date_format.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOrderPage extends StatelessWidget {
  const ListOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('listOrderPage'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.pushNamed(context, AppRoute.listProduct);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.listProduct,
              (route) => false,
            );
          },
        ),
      ),
      body: BlocBuilder<ListOrderBloc, ListOrderState>(
        builder: (context, state) {
          final data = state.groupedOrders;
          // print("Response" + jsonEncode(data));
          if (state.status.toString() == 'FetchStatus.init') {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                strokeWidth: 5.0,
              ),
            );
          }

          List<String> orderIDs = data.keys.toList();

          return Container(
            padding: const EdgeInsets.only(top: 8),
            child: ListView.separated(
              itemCount: orderIDs.length,
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemBuilder: (context, index) {
                String orderID = orderIDs[index];
                List<Order> orders = data[orderID]!;
                double sumTotalCart = 0.0;
                String orderDate = "";
                for (Order totalCart in orders) {
                  sumTotalCart += double.tryParse(totalCart.totalAmount) ?? 0.0;
                  orderDate = totalCart.createDate.toString();
                }
                // print('Total Amount: ${sumTotalCart}');
                return OrderExpansion(
                  orderID: orderID,
                  orders: orders,
                  totalCart: sumTotalCart,
                  orderDate: orderDate,
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: BlocBuilder<ListOrderBloc, ListOrderState>(
          builder: (context, state) {
            double total = state.total;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${'totalPrice'.tr()} ${formatThaiBaht(total)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderExpansion extends StatelessWidget {
  final String orderID;
  final List<Order> orders;
  final double totalCart;
  final String orderDate;

  const OrderExpansion({
    super.key,
    required this.orderID,
    required this.orders,
    required this.totalCart,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: ExpansionTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${'orderID'.tr()}: $orderID",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text("${'orderDate'.tr()} : ${formatThaiDate(orderDate)}")
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            FittedBox(
              child: Text(
                "${'total'.tr()} ${formatThaiBaht(totalCart)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        children: orders.map((order) => OrderItem(data: order)).toList(),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final Order data;

  const OrderItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        data.imageUrl,
        height: 55,
        width: 55,
      ),
      title: Text(
        data.productTitle,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            "${'price'.tr()} : ${formatThaiBaht(double.tryParse(data.productPrice) ?? 0.0)}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "${'quantity'.tr()} : ${data.quantityProduct}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      trailing: FittedBox(
        child: Text(
          "${'total'.tr()} ${formatThaiBaht(double.tryParse(data.totalAmount) ?? 0.0)}",
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
