import 'package:bloc/bloc.dart';
import 'package:demo_app/model/bookingStadium/find_slot/find_slot_of_stadium.dart';
import 'package:demo_app/model/bookingStadium/listBrandWithStadium.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:equatable/equatable.dart';

part 'list_brand_stadium_event.dart';
part 'list_brand_stadium_state.dart';

class ListBrandStadiumBloc extends Bloc<ListBrandStadiumEvent, ListBrandStadiumState> {
  ListBrandStadiumBloc() : super(const ListBrandStadiumState(dataResult: {}, slotTime: [])) {
    on<ListBrandStadiumEvent>((event, emit) {});

    on<ListBrandStadiumFetchEvent>((event, emit) async {
      emit(state.copyWith(dataResult: {}, status: FetchStatus.init));
      await Future.delayed(const Duration(seconds: 1));

      try {
        Map<String, ListBrandWithStadium> dataResult = await WebApiService().getBrandWithStadium(
          event.token,
          event.userId,
        );
        emit(state.copyWith(
          dataResult: dataResult,
          status: FetchStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(status: FetchStatus.failed));
      }
    });

    on<ListSlotOfStadiumFetchEvent>((event, emit) async {
      emit(state.copyWith(
        slotTime: [],
        status: FetchStatus.init,
      ));
      await Future.delayed(const Duration(seconds: 1));

      try {
        List<FindSlotInStadium> dataResult = await WebApiService().findSlotOfStadium(
          event.token,
          event.userId,
          event.dataRequestSlot,
        );
        emit(state.copyWith(
          slotTime: dataResult,
          status: FetchStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(
          slotTime: [],
          status: FetchStatus.failed,
        ));
      }
    });
  }
}
