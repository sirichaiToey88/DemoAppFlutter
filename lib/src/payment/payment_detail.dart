import 'package:demo_app/bloc/booking_stadium/booking_stadium_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/bloc/products/products_bloc.dart';
import 'package:demo_app/bloc/sent_cart/sent_cart_bloc.dart';
import 'package:demo_app/model/bookingStadium/bookingPayment.dart';
import 'package:demo_app/model/cart_model.dart';
import 'package:demo_app/model/sent_cart_model.dart';
import 'package:demo_app/model/user_detail.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:demo_app/utils/textFromField/text_from_field_number.dart';
import 'package:demo_app/utils/textFromField/text_from_field_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetail extends StatefulWidget {
  final String paymentType;
  final double? totalPriceBook;
  final List<BookingsPayment>? paymentBooking;
  final String bookingID;

  const PaymentDetail({
    super.key,
    required this.paymentType,
    required this.totalPriceBook,
    required this.paymentBooking,
    required this.bookingID,
  });

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountDestinationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _noteError;
  String? _accountDestinationError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountDestinationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${'paymentWith'.tr()} ${widget.paymentType}'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          final data = context.select((ProductsBloc bloc) => bloc.state.cart);
          final userDetail = context.select((LoginBloc bloc) => bloc.state.user);
          final toKen = context.select((LoginBloc bloc) => bloc.state.token);
          final List<BookingsPayment>? dataBooking = widget.paymentBooking;

          double totalPrice = 0;
          if (widget.totalPriceBook != null && widget.totalPriceBook! > 0) {
            _amountController.text = formatThaiBaht(widget.totalPriceBook!);
            totalPrice = widget.totalPriceBook!;
          } else {
            for (CartModel productInCart in data) {
              totalPrice += productInCart.total;
            }
            _amountController.text = formatThaiBaht(totalPrice);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'accountNumber'.tr(),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      final account = state.user[0].userId;
                      _accountNumberController.text = account;
                      return TextFormField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 24.0),
                        decoration: InputDecoration(
                          hintText: 'enterAccount'.tr(),
                        ),
                        enabled: false,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'amount'.tr(),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 24.0),
                    decoration: InputDecoration(
                      hintText: 'enterAmount'.tr(),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16.0),
                  TextFromFieldNumber(
                    controller: _accountDestinationController,
                    lableText: 'accountDestination'.tr(),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: _accountDestinationError,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFromFieldText(
                    controller: _noteController,
                    lableText: 'note'.tr(),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                    errorMessage: _noteError,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_accountDestinationController.text.isEmpty) {
                        setState(() {
                          _accountDestinationError = _accountDestinationController.text.isEmpty ? 'enterAccountDestination'.tr() : null;
                          // _noteError = _noteController.text.isEmpty ? 'Please enter a note' : null;
                        });
                      } else {
                        buildAlertConfirm(context, data, userDetail, toKen, totalPrice, dataBooking);
                      }
                    },
                    child: Center(child: Text('confirm'.tr())),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildAlertConfirm(BuildContext context, List<CartModel> data, List<UserDetail> userDetail, String toKen, double totalPrice, dataBooking) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("confirmPayment".tr()),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${'accountNumber'.tr()} : ${_accountNumberController.text}"),
              const SizedBox(height: 10),
              Text("${'accountDestination'.tr()} : ${_accountDestinationController.text}"),
              const SizedBox(height: 10),
              Text("${'totalPrice'.tr()} : ${_amountController.text}"),
              const SizedBox(height: 10),
              Text("${'note'.tr()} : ${_noteController.text.isNotEmpty ? _noteController.text : ""}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                sentTosave(userDetail, data, totalPrice, toKen, dataBooking);
              },
              child: Text("confirm".tr()),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and do nothing
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr()),
            ),
          ],
        );
      },
    );
  }

  void sentTosave(List<UserDetail> userDetail, List<CartModel> data, double totalPrice, String toKen, dataBooking) {
    Navigator.of(context).pop();
    if (data.isNotEmpty) {
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
          "Payment_type": widget.paymentType,
          "Payment": {
            "account": userDetail[0].userId,
            "source": userDetail[0].userId,
            "distination": _accountDestinationController.text,
            "total": item.total.toString(),
          },
        };
        jsonData.add(cartData);
      }
      for (var data in jsonData) {
        cartList.add(SentCartModel.fromJson(data));
      }
      context.read<SentCartBloc>().add(SentCartAddEvent(cartList, toKen));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PaymentSuccess(
      //       total: totalPrice,
      //     ),
      //   ),
      // );
      Navigator.pushNamed(
        context,
        AppRoute.paymentSuccess,
        arguments: {
          'totalPrice': totalPrice,
          'typePage': 'product'
        },
      );
    } else {
      List<BookingsPayment> paymentBooking = [];
      if (dataBooking.isNotEmpty) {
        Set<dynamic> jsonBookingData = {};
        for (var item in dataBooking) {
          Map<String, dynamic> bookingData = {
            "Id": widget.bookingID,
            "User_id": userDetail[0].userId,
            "Brand_id": item.brandId,
            "Stadium_id": item.stadiumId,
            "Reservation_hours": item.reservationHours,
            "Reservation_date": item.reservationDate,
            "Start_time": item.startTime,
            "End_time": item.endTime,
            "Need_to_pay": "1",
            "Payment": {
              "user_id": userDetail[0].userId,
              "status": "1",
              "image_url": null,
              "total": totalPrice.toString(),
              "source": userDetail[0].userId,
              "destination": _accountDestinationController.text,
              "createDate": DateTime.now(),
              "modifyDate": DateTime.now(),
            },
          };
          jsonBookingData.add(bookingData);
        }
        for (var data in jsonBookingData) {
          paymentBooking.add(BookingsPayment.fromJson(data));
        }
      }

      context.read<BookingStadiumBloc>().add(BookingPaymentEvent(toKen, paymentBooking));
      Navigator.pushNamed(
        context,
        AppRoute.paymentSuccess,
        arguments: {
          'totalPrice': totalPrice,
          'typePage': 'booking'
        },
      );
    }
  }
}
