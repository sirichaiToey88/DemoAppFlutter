part of 'booking_stadium_bloc.dart';

enum FetchStatus {
  fetching,
  success,
  failed,
  init,
  showDeleteConfirmation
}

class BookingStadiumState extends Equatable {
  final List<AddBookingStadium> addBooking;
  final List<ListBookings> listBookings;
  final FetchStatus status;
  final List<BookingsPayment> paymentBooking;

  const BookingStadiumState({
    required this.addBooking,
    required this.listBookings,
    required this.paymentBooking,
    this.status = FetchStatus.init,
  });

  BookingStadiumState copyWith({
    List<AddBookingStadium>? addBooking,
    List<ListBookings>? listBookings,
    FetchStatus? status,
  }) {
    return BookingStadiumState(
      addBooking: addBooking ?? this.addBooking,
      listBookings: listBookings ?? this.listBookings,
      status: status ?? this.status,
      paymentBooking: paymentBooking,
    );
  }

  @override
  List<Object> get props => [
        addBooking,
        listBookings,
        status,
        paymentBooking
      ];
}
