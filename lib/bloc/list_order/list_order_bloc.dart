import 'package:bloc/bloc.dart';
import 'package:demo_app/model/list_product/order_data.dart';
import 'package:demo_app/model/list_product/order_user.dart';
import 'package:demo_app/src/services/webapi_service.dart';
import 'package:equatable/equatable.dart';

part 'list_order_event.dart';
part 'list_order_state.dart';

class ListOrderBloc extends Bloc<ListOrderEvent, ListOrderState> {
  ListOrderBloc()
      : super(ListOrderState(
          orderList: const [],
          groupedOrders: const {},
        )) {
    on<ListOrderEvent>((event, emit) {});

    on<ListOrderFetchEvent>((event, emit) async {
      emit(state.copyWith(orderList: [], status: FetchStatus.init));
      await Future.delayed(const Duration(seconds: 1));

      try {
        OrderData orderData = await WebApiService().getListOrder(
          event.token,
          event.userId,
        );
        Map<String, List<Order>> groupedOrders = orderData.groupedOrders;
        double total = orderData.total;

        emit(state.copyWith(
          groupedOrders: groupedOrders,
          total: total,
          status: FetchStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(status: FetchStatus.failed));
      }
    });
  }
}
