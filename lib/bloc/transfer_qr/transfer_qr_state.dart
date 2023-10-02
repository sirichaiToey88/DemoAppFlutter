part of 'transfer_qr_bloc.dart';

enum TransferQrStatus {
  init,
  processing,
  success,
  successWithMiniQr,
  invalid,
  invalidEWallet,
  unableToProceedTryAgainWithBillerChecking,
  transactionVerificationError,
  transactionVerificationNotMatchBankError,
  transactionVerificationNotFoundError,
}

class TransferQrState extends Equatable {
  final String? errorCode;
  final TransferQrStatus? status;
  final TransferQrData? transferQrData;
  final String? qrValue;

  const TransferQrState({
    this.errorCode,
    this.status,
    this.transferQrData,
    this.qrValue,
  });

  TransferQrState copyWith({
    String? errorCode,
    TransferQrStatus? status,
    TransferQrData? transferQrData,
    String? qrValue,
    bool? isEdonationQR,
    anferVerifyresponse,
  }) {
    return TransferQrState(
      errorCode: errorCode ?? this.errorCode,
      status: status ?? this.status,
      transferQrData: transferQrData ?? this.transferQrData,
      qrValue: qrValue ?? this.qrValue,
    );
  }

  @override
  List<Object?> get props => [
        errorCode,
        status,
        transferQrData,
        qrValue,
      ];
}

class TransferQrData {
  late String version;
  late String type;
  String? transferType;
  String? tag;
  late String merchant;
  String? merchantCity;
  String? merchantName;
  late String county;
  late String currencyCode;
  double? amount;
  late String checkSum;
  late String countryCode;
  bool isValid;

  TransferQrData({
    required this.isValid,
  });
}
