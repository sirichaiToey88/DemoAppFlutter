import 'dart:convert';

import 'package:demo_app/model/bookingStadium/bookingPayment.dart';
import 'package:demo_app/utils/paymentMethod/payment_method.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final double? totalPriceBook = args != null && args['totalPriceBook'] != null ? double.tryParse(args['totalPriceBook']) : 0.00;

    final String? bookingID = args != null && args['bookingID'] != null ? args['bookingID'] : null;

    final Map<String, dynamic>? bookingJson = args != null ? args['bookingData'] as Map<String, dynamic>? : null;

    // Create a Payment object

    // Payment payment = Payment(
    //   userId: bookingJson,
    //   status: '0',
    //   imageUrl: null,
    //   total: '100',
    //   createDate: "2023-09-13",
    //   modifyDate: "2023-09-13",
    //   source: 'source',
    //   destination: 'destination',
    // );

    if (bookingJson != null) {
      // Add the payment object to bookingJson
      Payment payment = Payment(
        userId: bookingJson['user_id'],
        status: '0',
        imageUrl: null,
        total: bookingJson['total_price'],
        createDate: "",
        modifyDate: "",
        source: '',
        destination: '',
      );
      bookingJson['Payment'] = payment.toJson();
    }
    BookingsPayment? paymentBooking = bookingJson != null ? BookingsPayment.fromJson(bookingJson) : null;

    final List<BookingsPayment> paymentBookingList = paymentBooking != null
        ? [
            paymentBooking
          ]
        : <BookingsPayment>[];

// Create a List of Map from paymentBookingList
    // final List<Map<String, dynamic>> paymentBookingListMap = paymentBookingList.map((payment) => payment.toJson()).toList();

    // print("object 352344343 " + jsonEncode(paymentBookingListMap));

    return Scaffold(
      appBar: AppBar(
        title: Text('paymentMethod'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.pushReplacementNamed(context, AppRoute.checkOut);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            PaymentOptionCard(
              icon: Icons.qr_code_scanner_sharp,
              title: 'qrScan'.tr(),
              subtitle: 'Pay with QR scan',
              type: 'QR',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            PaymentOptionCard(
              icon: Icons.mobile_screen_share,
              title: 'backAccount'.tr(),
              subtitle: 'Pay with your back account',
              type: 'bank',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            PaymentOptionCard(
              icon: Icons.credit_card,
              title: 'creditCard'.tr(),
              subtitle: 'Pay with your credit card',
              type: 'CreditCard',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            PaymentOptionCard(
              icon: Icons.attach_money,
              title: 'payPal'.tr(),
              subtitle: 'Pay with your PayPal account',
              type: 'PayPal',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            PaymentOptionCard(
              icon: Icons.payment,
              title: 'applePay'.tr(),
              subtitle: 'Pay with Apple Pay',
              type: 'ApplePay',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            PaymentOptionCard(
              icon: Icons.money_sharp,
              title: 'cashOnDelivery'.tr(),
              subtitle: 'Pay when you receive',
              type: 'COD',
              totalPriceBook: totalPriceBook ?? 0.00,
              bookingID: bookingID,
              paymentBooking: paymentBookingList,
            ),
            // Add more payment options as needed
          ],
        ),
      ),
    );
  }
}
