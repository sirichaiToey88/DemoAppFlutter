part of 'booking_stadium_bloc.dart';

abstract class BookingStadiumEvent extends Equatable {
  const BookingStadiumEvent();

  @override
  List<Object> get props => [];
}

class BookingStadiumAddEvent extends BookingStadiumEvent {
  final List<AddBookingStadium> addBooking;
  final String token;

  const BookingStadiumAddEvent(
    this.addBooking,
    this.token,
  );

  @override
  List<Object> get props => [
        addBooking,
        token,
      ];
}

class BookingListAllEvent extends BookingStadiumEvent {
  final String token;
  final String userId;

  const BookingListAllEvent(this.token, this.userId);

  @override
  List<Object> get props => [
        token,
        userId,
      ];
}

class BookingPaymentEvent extends BookingStadiumEvent {
  final String token;
  // final String userId;
  final List<BookingsPayment> paymentBooking;

  const BookingPaymentEvent(this.token, this.paymentBooking);

  @override
  List<Object> get props => [
        token,
        // userId,
        paymentBooking,
      ];
}

class BookingCancelEvent extends BookingStadiumEvent {
  final String token;
  final String userId;
  final String bookingId;

  const BookingCancelEvent(this.token, this.userId, this.bookingId);

  @override
  List<Object> get props => [
        token,
        userId,
        bookingId
      ];
}
