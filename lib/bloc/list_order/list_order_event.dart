part of 'list_order_bloc.dart';

abstract class ListOrderEvent extends Equatable {
  const ListOrderEvent();

  @override
  List<Object> get props => [];
}

class ListOrderFetchEvent extends ListOrderEvent {
  final String token;
  final String userId;

  const ListOrderFetchEvent(this.token, this.userId);

  @override
  List<Object> get props => [
        token,
        userId,
      ];
}
