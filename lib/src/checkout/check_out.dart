import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("checkOut".tr()),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoute.cartShopping);
          },
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              final cart = state.cart;
              return Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(14),
                      color: Colors.white,
                      child: ListTile(
                        leading: Image.network(
                          cart[index].image_url,
                          height: 70,
                        ),
                        title: Text(
                          cart[index].title,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${'price'.tr()} ${formatThaiBaht(cart[index].price)}",
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${'quantity'.tr()} ${cart[index].quantity}",
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${'totalPrice'.tr()}: ${formatThaiBaht(cart[index].total)}",
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            height: 90,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                final total = context.select((ProductsBloc bloc) => bloc.state.cart);
                double totalPrice = 0;
                int totalItems = 0;

                for (CartModel productInCart in total) {
                  totalPrice += productInCart.total;
                  totalItems += productInCart.quantity;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${'totalPrice'.tr()} ${formatThaiBaht(totalPrice)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${'totalItem'.tr()} $totalItems",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 100, bottom: 5),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, AppRoute.paymentMethod);
                          Navigator.pushNamed(
                            context,
                            AppRoute.paymentMethod,
                            arguments: {
                              'totalPriceBook': null
                            },
                          );
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.payments,
                              size: 35,
                            ),
                            Text(
                              'confirm'.tr(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
