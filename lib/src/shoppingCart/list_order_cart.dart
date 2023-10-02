import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildDetailOrderFooter extends StatelessWidget {
  const BuildDetailOrderFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Navigator.pushNamed(context, AppRoute.checkOut);
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.payments,
                        size: 35,
                      ),
                      Text(
                        'payment'.tr(),
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
    );
  }
}

class BuildListOrderCart extends StatelessWidget {
  const BuildListOrderCart({
    super.key,
    required this.cart,
  });

  final List<CartModel> cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cart.isEmpty
          ? Container()
          : Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx < 0) {
                          // Swipe from right to left (delete gesture)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: Text("Are you sure you want to delete ${cart[index].title}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog and remove the item from the cart
                                      Navigator.of(context).pop();
                                      int productId = cart[index].id;
                                      context.read<ProductsBloc>().add(ProductsDeleteItemInCartEvent(cart, productId));
                                    },
                                    child: const Text("Delete"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog and do nothing
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    cart[index].image_url,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Title: ${cart[index].title}",
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${'price'.tr()} ${formatThaiBaht(cart[index].price)}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${'totalPrice'.tr()} ${formatThaiBaht(cart[index].total)}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pinkAccent[100],
                                        ),
                                        onPressed: () {
                                          // Reduce the quantity
                                          int productId = cart[index].id;
                                          if (cart[index].quantity > 1) {
                                            context.read<ProductsBloc>().add(ProductsReduceQuantityEvent(cart, productId));
                                          }
                                        },
                                        child: const Text("-"),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${cart[index].quantity}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Increase the quantity
                                          int productId = cart[index].id;
                                          context.read<ProductsBloc>().add(ProductsIncreaseQuantityEvent(cart, productId));
                                        },
                                        child: const Text("+"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationZ(0.05), // Rotate the text slightly
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'slideDelete'.tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
