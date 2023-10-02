import 'package:demo_app/bloc/booking_stadium/booking_stadium_bloc.dart';
import 'package:demo_app/model/bookingStadium/add_booking_stadium.dart';
import 'package:demo_app/src/booking/main_screen/screen_booking_main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showBookingConfirmation(
  BuildContext context,
  String? brandId,
  String? stadiumId,
  String? reservationDate,
  String? reservationHours,
  String? startTime,
  String? endTime,
  String toKen,
  String userId,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('confirmReservation'.tr()),
        content: Text('bookingConfirm'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              List<AddBookingStadium> bookingStadium = [];
              Set<dynamic> jsonData = {};
              Map<String, dynamic> booking = {
                "User_id": userId,
                "Brand_id": brandId,
                "Stadium_id": stadiumId,
                "Reservation_hours": reservationHours,
                "Reservation_date": reservationDate,
                "Start_time": startTime,
                "End_time": endTime
              };
              jsonData.add(booking);

              for (var data in jsonData) {
                bookingStadium.add(AddBookingStadium.fromJson(data));
              }

              context.read<BookingStadiumBloc>().add(BookingStadiumAddEvent(bookingStadium, toKen));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreenBooking(token: toKen, userId: userId),
                ),
                (route) => false,
              );
            },
            child: Text('confirm'.tr()),
          ),
        ],
      );
    },
  );
}
