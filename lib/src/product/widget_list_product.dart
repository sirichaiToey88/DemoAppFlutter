import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/model/products_model.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildListProduct extends StatelessWidget {
  final List<ProductsModels> data;

  const BuildListProduct({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      'productDetail'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          data[index].image,
                          width: 100,
                          height: 120,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Product Name: ${data[index].title}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Product Description: ${data[index].description}",
                          maxLines: 10,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Price: ${formatThaiBaht(data[index].price)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Rating: ${data[index].rating.count}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'close'.tr(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final CartModel productToAdd = CartModel(
                            category: data[index].category,
                            description: data[index].description,
                            id: data[index].id,
                            image_url: data[index].image,
                            price: data[index].price,
                            title: data[index].title,
                            quantity: 1,
                            total: data[index].price,
                          );
                          Navigator.of(context).pop();
                          BlocProvider.of<ProductsBloc>(context).add(
                            ProductsEventAddToCart([
                              productToAdd
                            ]),
                          );
                          Navigator.pushNamed(
                            context,
                            AppRoute.cartShopping,
                          );
                        },
                        child: Text("addToCart".tr()),
                      ),
                    ],
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: Text(
                    "Name: ${data[index].title}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Image.network(
                    data[index].image,
                    height: 90,
                    width: 50,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price: ${formatThaiBaht(data[index].price)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rating: ${data[index].rating.count}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton(
                      // heroTag: 'uniqueHeroTagForProductList',
                      heroTag: 'uniqueHeroTagForProductList_$index',
                      onPressed: () {
                        final CartModel productToAdd = CartModel(
                          category: data[index].category,
                          description: data[index].description,
                          id: data[index].id,
                          image_url: data[index].image,
                          price: data[index].price,
                          title: data[index].title,
                          quantity: 1,
                          total: data[index].price,
                        );

                        BlocProvider.of<ProductsBloc>(context).add(
                          ProductsEventAddToCart([
                            productToAdd
                          ]),
                        );
                      },
                      mini: true,
                      backgroundColor: Colors.transparent,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
