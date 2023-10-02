import 'dart:convert';

import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/bloc/sent_cart/sent_cart_bloc.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/model/sent_cart_model.dart';
import 'package:demo_app/src/payment/payment_success.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRScanPage extends StatelessWidget {
  final List<String> barcodeDetails;
  final int takePhoto;
  final String typePage;

  const QRScanPage({
    super.key,
    required this.barcodeDetails,
    required this.takePhoto,
    required this.typePage,
  });

  @override
  Widget build(BuildContext context) {
    final String originalAccountNumber;
    final String destinationAccountNumber;
    final String banklogo;
    if (takePhoto == 0) {
      final Map<String, dynamic> jsonData = jsonDecode(barcodeDetails[0]);

      originalAccountNumber = jsonData['account'];
      destinationAccountNumber = jsonData['account'];
      banklogo = jsonData['banklogo'];
    } else {
      originalAccountNumber = "200300701";
      destinationAccountNumber = "0012334566";
      banklogo = "assets/images/banklogo/citi.png";
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Transfer Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          final data = context.select((ProductsBloc bloc) => bloc.state.cart);
          final userDetail = context.select((LoginBloc bloc) => bloc.state.user);
          final toKen = context.select((LoginBloc bloc) => bloc.state.token);

          double totalPrice = 0;

          for (CartModel productInCart in data) {
            totalPrice += productInCart.total;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(39.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage(banklogo),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Confirm Transfer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Account Number:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    originalAccountNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'To Account Number:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    destinationAccountNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Amount:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatThaiBaht(totalPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      List<SentCartModel> cartList = [];
                      Set<dynamic> jsonData = {};
                      for (var item in data) {
                        Map<String, dynamic> cartData = {
                          "User_id": userDetail[0].userId,
                          "Product_id": item.id.toString(),
                          "Product_title": item.title,
                          "Product_price": item.price.toString(),
                          "Total_amount": item.total.toString(),
                          "Quantity_product": item.quantity.toString(),
                          "Image_url": item.image_url.toString(),
                          "Payment_type": "QR Payment",
                          "Payment": {
                            "account": userDetail[0].userId,
                            "source": userDetail[0].userId,
                            "distination": userDetail[0].userId,
                            "total": item.total.toString(),
                          },
                        };
                        jsonData.add(cartData);
                      }
                      for (var data in jsonData) {
                        cartList.add(SentCartModel.fromJson(data));
                      }
                      context.read<SentCartBloc>().add(SentCartAddEvent(cartList, toKen));
                      // Navigator.pushReplacementNamed(context, AppRoute.paymentSuccess);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentSuccess(
                            total: totalPrice,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm Transfer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
