import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/main/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildCartNoti extends StatelessWidget {
  final List<CartModel> cartData;
  const BuildCartNoti({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            final total = state.cart;
            int totalItems = 0;

            for (CartModel productInCart in total) {
              totalItems += productInCart.quantity;
            }

            if (state.cart.isEmpty) {
              for (CartModel productInCart in cartData) {
                totalItems += productInCart.quantity;
              }
              final updatedCart = List<CartModel>.from(state.cart)..addAll(cartData);

              BlocProvider.of<ProductsBloc>(context).add(
                ProductsEventAddToCart(updatedCart),
              );
            }

            return GestureDetector(
              onTap: () {
                if (totalItems > 0) {
                  Navigator.pushNamed(
                    navigatorState.currentContext!,
                    AppRoute.cartShopping,
                  );
                } else {
                  return showAddToCartAlert(context);
                }
              },
              child: Stack(
                children: [
                  // Your notification icon
                  const Icon(
                    Icons.card_travel_sharp,
                    size: 24,
                  ),
                  if (totalItems > 0)
                    // Notification count badge
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void showAddToCartAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('addToCart'.tr()),
          content: Text('pleaseAddProductToCart'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('confirm'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
