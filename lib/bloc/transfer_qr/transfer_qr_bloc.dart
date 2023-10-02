import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transfer_qr_event.dart';
part 'transfer_qr_state.dart';

class TransferQrBloc extends Bloc<TransferQrEvent, TransferQrState> {
  TransferQrBloc() : super(TransferQrState()) {
    on<TransferQrEvent>((event, emit) {});

    on<TransferQrReadEvent>((event, emit) {
      emit(state.copyWith(status: TransferQrStatus.processing));
      // TransferQrData transferQrData = readQrCodeData(event.qrValue);
      // print("Response QR Value => ${transferQrData}");
    });
  }
}
