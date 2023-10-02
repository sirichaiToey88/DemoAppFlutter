part of 'transfer_qr_bloc.dart';

abstract class TransferQrEvent extends Equatable {
  const TransferQrEvent();

  @override
  List<Object> get props => [];
}

class TransferQrReadEvent extends TransferQrEvent {
  final String qrValue;

  const TransferQrReadEvent(this.qrValue);

  @override
  List<Object> get props => [
        qrValue,
      ];
}
