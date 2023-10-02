part of 'list_brand_stadium_bloc.dart';

abstract class ListBrandStadiumEvent extends Equatable {
  const ListBrandStadiumEvent();

  @override
  List<Object> get props => [];
}

class ListBrandStadiumFetchEvent extends ListBrandStadiumEvent {
  final String token;
  final String userId;

  const ListBrandStadiumFetchEvent(this.token, this.userId);

  @override
  List<Object> get props => [
        token,
        userId,
      ];
}

class ListSlotOfStadiumFetchEvent extends ListBrandStadiumEvent {
  final Map<String, dynamic> dataRequestSlot;
  final String token;
  final String userId;
  const ListSlotOfStadiumFetchEvent(
    this.dataRequestSlot,
    this.token,
    this.userId,
  );

  @override
  List<Object> get props => [
        dataRequestSlot,
        token,
        userId,
      ];
}
