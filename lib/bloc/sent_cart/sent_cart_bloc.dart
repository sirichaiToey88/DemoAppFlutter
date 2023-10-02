import 'package:bloc/bloc.dart';
import 'package:demo_app/model/sent_cart_model.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:equatable/equatable.dart';

part 'sent_cart_event.dart';
part 'sent_cart_state.dart';

class SentCartBloc extends Bloc<SentCartEvent, SentCartState> {
  SentCartBloc()
      : super(const SentCartState(
          isLoading: false,
          isSuccess: false,
          message: '',
        )) {
    on<SentCartEvent>((event, emit) {});

    on<SentCartAddEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      await WebApiService().sentCartToAPI(
        event.cartItem,
        event.toKen,
      );
    });
  }
}
