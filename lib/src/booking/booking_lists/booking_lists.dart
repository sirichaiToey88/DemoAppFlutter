import 'package:demo_app/bloc/booking_stadium/booking_stadium_bloc.dart';
import 'package:demo_app/bloc/login/login_bloc.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/utils/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingListPage extends StatefulWidget {
  final String token;
  final String userId;

  const BookingListPage({super.key, required this.token, required this.userId});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  @override
  void initState() {
    super.initState();
    final loginState = context.read<LoginBloc>().state;
    final userId = loginState.user[0].userId;
    final token = loginState.token;

    if (widget.token.isEmpty) {
      context.read<BookingStadiumBloc>().add(BookingListAllEvent(token, userId));
    } else {
      context.read<BookingStadiumBloc>().add(BookingListAllEvent(widget.token, widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bookingList'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoute.mainScreenBooking);
          },
        ),
      ),
      body: BlocBuilder<BookingStadiumBloc, BookingStadiumState>(
        builder: (context, state) {
          final data = state.listBookings;
          if (state.status.toString() == 'FetchStatus.init') {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                strokeWidth: 5.0,
              ),
            );
          }
          return SingleChildScrollView(
            child: data.isEmpty
                ? Center(
                    child: Text('bookingNotFound'.tr()),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16), // กำหนดระยะห่างระหว่างรายการจอง
                    itemBuilder: (context, index) {
                      final booking = data[index];
                      return Stack(
                        children: [
                          ListTile(
                            title: Text(booking.brandTitle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${'court'.tr()} ${booking.stadiumNumber}"),
                                Text("${'date'.tr()} ${formatShortDateThai(booking.reservationDate)}"),
                                Text("${'time'.tr()} ${booking.startTime} - ${booking.endTime}"),
                                Text("${'totalPrice'.tr()} ${booking.totalPrice}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: (booking.paymentStatus == '1' && booking.overDue == '1') || (booking.paymentStatus == '0' && booking.overDue == '1') || booking.paymentStatus == '1' || booking.del == '1'
                                      ? null
                                      : () {
                                          final bookingJson = booking.toJson();
                                          Navigator.pushNamed(
                                            context,
                                            AppRoute.paymentMethod,
                                            arguments: {
                                              'totalPriceBook': booking.totalPrice,
                                              'bookingData': bookingJson,
                                              'bookingID': booking.id,
                                            },
                                          );
                                        },
                                  child: Text(
                                    (booking.paymentStatus == '1' && booking.overDue == '1') || (booking.paymentStatus == '0' && booking.overDue == '1') || booking.del == '1' ? 'overDue'.tr() : 'Payment',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: booking.paymentStatus == '1' || booking.overDue == '1' || booking.del == '1'
                                      ? null
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('confirmDelete'.tr()),
                                                content: Text('confirmDelBooking'.tr()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('cancel'.tr()),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      context.read<BookingStadiumBloc>().add(
                                                            BookingCancelEvent(widget.token, widget.userId, booking.id),
                                                          );
                                                      Navigator.of(context).pop();
                                                      if (state.status.toString() == 'FetchStatus.success') {
                                                        context.read<BookingStadiumBloc>().add(BookingListAllEvent(widget.token, widget.userId));
                                                      }
                                                    },
                                                    child: Text('confirm'.tr()),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                  child: Text('cancel'.tr()),
                                ),
                              ],
                            ),
                          ),
                          if (booking.del == '1')
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                alignment: Alignment.center,
                                child: Text(
                                  'cancelBooking'.tr(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          if (booking.paymentStatus == '1')
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                alignment: Alignment.center,
                                child: Text(
                                  'paymentSuccess'.tr(),
                                  style: TextStyle(
                                    color: Colors.green.shade300,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
