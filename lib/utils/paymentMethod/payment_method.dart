import 'package:demo_app/model/bookingStadium/bookingPayment.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/payment/payment_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String type;
  final double totalPriceBook;
  final List<BookingsPayment>? paymentBooking;
  final String? bookingID;

  const PaymentOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.totalPriceBook,
    required this.paymentBooking,
    required this.bookingID,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     elevation: 2.0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: ListTile(
  //       leading: Icon(icon, size: 48.0),
  //       title: Text(title, style: const TextStyle(fontSize: 20.0)),
  //       subtitle: Text(subtitle),
  //       onTap: () {
  //         switch (type) {
  //           case "QR":
  //             Navigator.pushNamed(context, AppRoute.scanQR);
  //             break;
  //           case "bank":
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const PaymentDetail(paymentType: 'Bank Account'),
  //               ),
  //             );
  //             break;
  //           case "CreditCard":
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const PaymentDetail(paymentType: 'Credit Card'),
  //               ),
  //             );
  //             break;
  //           case "PayPal":
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const PaymentDetail(paymentType: 'Pay Pal'),
  //               ),
  //             );
  //             break;
  //           case "ApplePay":
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const PaymentDetail(paymentType: 'Apple Pay'),
  //               ),
  //             );
  //             break;
  //           case "COD":
  //             Navigator.pushNamed(context, AppRoute.paymentDetail);
  //             break;
  //           default:
  //         }
  //       },
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(icon, size: 48.0),
        title: Text(title, style: const TextStyle(fontSize: 20.0)),
        subtitle: Text(subtitle),
        onTap: () {
          switch (type) {
            case "QR":
              Navigator.pushNamed(context, AppRoute.scanQR);
              break;
            case "bank":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetail(
                    paymentType: 'bankAccount'.tr(),
                    totalPriceBook: totalPriceBook,
                    paymentBooking: paymentBooking,
                    bookingID: bookingID ?? '',
                  ),
                ),
              );
              break;
            case "CreditCard":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetail(
                    paymentType: 'creditCard'.tr(),
                    totalPriceBook: totalPriceBook,
                    paymentBooking: paymentBooking,
                    bookingID: bookingID ?? '',
                  ),
                ),
              );
              break;
            case "PayPal":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetail(
                    paymentType: 'payPal'.tr(),
                    totalPriceBook: totalPriceBook,
                    paymentBooking: paymentBooking,
                    bookingID: bookingID ?? '',
                  ),
                ),
              );
              break;
            case "ApplePay":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetail(
                    paymentType: 'applePay'.tr(),
                    totalPriceBook: totalPriceBook,
                    paymentBooking: paymentBooking,
                    bookingID: bookingID ?? '',
                  ),
                ),
              );
              break;
            case "COD":
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "See you soon!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            default:
          }
        },
      ),
    );
  }
}
