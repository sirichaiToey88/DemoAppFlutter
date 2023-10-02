import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/shoppingCart/list_order_cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartShopping extends StatefulWidget {
  const CartShopping({super.key});

  @override
  State<CartShopping> createState() => _CartShoppingState();
}

class _CartShoppingState extends State<CartShopping> {
  bool _isNavigated = false;
  double totalPrice = 0;
  int iTem = 0;
  List<CartModel> cartData = [];
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>();
    final cart = context.read<ProductsBloc>().state.cart;
    cartData = cart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('shoppingCart'.tr()),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoute.listProduct, arguments: cartData);
            },
          )),
      body: Column(
        children: [
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state.status.toString() == 'FetchStatus.success') {
                final cart = state.cart;
                cartData = cart;
                if (cart.isEmpty && !_isNavigated) {
                  _isNavigated = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, AppRoute.listProduct, arguments: cartData);
                  });
                }
                return BuildListOrderCart(cart: cart);
              }
              return const CircularProgressIndicator(); // แสดงตัว Loading หรือ UI ใดๆ ในระหว่างโหลดข้อมูล
            },
          ),
          const BuildDetailOrderFooter()
        ],
      ),
    );
  }
}
