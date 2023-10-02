import 'package:bloc/bloc.dart';
import 'package:demo_app/model/bookingStadium/createBrand.dart';
import 'package:demo_app/model/books.model.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:equatable/equatable.dart';

part 'brand_stadium_event.dart';
part 'brand_stadium_state.dart';

class BrandStadiumBloc extends Bloc<BrandStadiumEvent, BrandStadiumState> {
  BrandStadiumBloc() : super(BrandStadiumState()) {
    on<BrandStadiumEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<BrandStadiumSaveEvent>((event, emit) async {
      emit(state.copyWith(
        brandData: [],
        status: FetchStatus.init,
      ));
      await Future.delayed(const Duration(seconds: 1));
      final dataResult = await WebApiService().saveBrandStatdiumToAPI(event.toKen, event.brandData);
      emit(state.copyWith(
        brandData: [],
        status: FetchStatus.success,
      ));
    });
  }
}
