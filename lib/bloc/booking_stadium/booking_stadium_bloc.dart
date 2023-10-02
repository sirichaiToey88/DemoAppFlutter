import 'package:bloc/bloc.dart';
import 'package:demo_app/model/bookingStadium/add_booking_stadium.dart';
import 'package:demo_app/model/bookingStadium/bookingPayment.dart';
import 'package:demo_app/model/bookingStadium/list_bookings/list_booking.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:demo_app/utils/custom_toast/show_toast_top.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'booking_stadium_event.dart';
part 'booking_stadium_state.dart';

class BookingStadiumBloc extends Bloc<BookingStadiumEvent, BookingStadiumState> {
  BookingStadiumBloc() : super(const BookingStadiumState(addBooking: [], listBookings: [], paymentBooking: [])) {
    on<BookingStadiumEvent>((event, emit) {});

    on<BookingStadiumAddEvent>((event, emit) async {
      emit(state.copyWith(status: FetchStatus.init));
      await Future.delayed(const Duration(seconds: 1));
      try {
        String? result = await WebApiService().sentBookingStadiumToAPI(
          event.addBooking,
          event.token,
        );
        if (result == 'success') {
          emit(state.copyWith(status: FetchStatus.success));
          showCustomToastTop('Booking Success', backgroundColor: Colors.green, textColor: Colors.white);
        } else {
          showCustomToastTop('Booking Failed', backgroundColor: Colors.red, textColor: Colors.white);

          emit(state.copyWith(status: FetchStatus.failed));
        }
      } catch (e) {
        showCustomToastTop('Booking Failed', backgroundColor: Colors.red, textColor: Colors.white);
        emit(state.copyWith(status: FetchStatus.failed));
      }
    });

    on<BookingListAllEvent>((event, emit) async {
      emit(state.copyWith(listBookings: [], status: FetchStatus.init));
      await Future.delayed(const Duration(seconds: 1));
      try {
        final result = await WebApiService().getAllBookings(
          event.token,
          event.userId,
        );
        emit(state.copyWith(listBookings: result, status: FetchStatus.success));
      } catch (e) {
        emit(state.copyWith(listBookings: [], status: FetchStatus.failed));
      }
    });

    on<BookingPaymentEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      await WebApiService().sentBookingPaymentToAPI(
        event.paymentBooking,
        event.token,
      );
    });

    on<BookingCancelEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      try {
        final result = await WebApiService().sentCancelBookingToAPI(
          event.token,
          event.userId,
          event.bookingId,
        );
        showCustomToastTop('cancelSuccess'.tr(), backgroundColor: Colors.green, textColor: Colors.white);
        emit(state.copyWith(listBookings: [], status: FetchStatus.success));
      } catch (e) {
        showCustomToastTop('cancelFail'.tr(), backgroundColor: Colors.red, textColor: Colors.white);
        emit(state.copyWith(listBookings: [], status: FetchStatus.failed));
      }
    });
  }
}
