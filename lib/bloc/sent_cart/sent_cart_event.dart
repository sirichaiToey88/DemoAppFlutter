part of 'sent_cart_bloc.dart';

abstract class SentCartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SentCartAddEvent extends SentCartEvent {
  final List<SentCartModel> cartItem;
  final String toKen;

  SentCartAddEvent(this.cartItem, this.toKen);

  @override
  List<Object> get props => [
        cartItem,
        toKen,
      ];
}
