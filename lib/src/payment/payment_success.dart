import 'package:demo_app/bloc/list_order/list_order_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/money_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSuccess extends StatelessWidget {
  final double total;
  const PaymentSuccess({super.key, required this.total});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final double? totalPrice = args != null ? args['totalPrice'] : 0.00;

    final String? typePage = args != null ? args['typePage'] : null;
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background color
      appBar: AppBar(
        title: Text('transferSuccessful'.tr()),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              '${'transferSuccessful'.tr()}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${'amount'.tr()} : ${formatThaiBaht(totalPrice!)}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final token = state.token;
                final userId = state.user[0].userId;
                return ElevatedButton(
                  onPressed: () {
                    context.read<ListOrderBloc>().add(ListOrderFetchEvent(token, userId));
                    if (typePage == "product") {
                      // Navigator.pushReplacementNamed(context, AppRoute.listOrderPage);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoute.listOrderPage,
                        (route) => false,
                      );
                    } else {
                      // Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoute.bookingListPage,
                        (route) => false,
                      );
                    }
                  },
                  child: Text('backDashboard'.tr()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
