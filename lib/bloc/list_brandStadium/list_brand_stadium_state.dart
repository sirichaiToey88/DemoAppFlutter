part of 'list_brand_stadium_bloc.dart';

enum FetchStatus {
  fetching,
  success,
  failed,
  init,
  showDeleteConfirmation
}

class ListBrandStadiumState extends Equatable {
  final Map<String, ListBrandWithStadium> dataResult;
  final List<FindSlotInStadium> slotTime;
  final FetchStatus status;
  const ListBrandStadiumState({
    required this.dataResult,
    required this.slotTime,
    this.status = FetchStatus.init,
  });

  ListBrandStadiumState copyWith({
    Map<String, ListBrandWithStadium>? dataResult,
    final List<FindSlotInStadium>? slotTime,
    FetchStatus? status,
  }) {
    return ListBrandStadiumState(
      dataResult: dataResult ?? this.dataResult,
      slotTime: slotTime ?? this.slotTime,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        dataResult,
        slotTime,
        status
      ];
}
