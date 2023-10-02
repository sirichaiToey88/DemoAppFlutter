TransferQrData readQrCodeData(String qrValue) {
  var length = 0;
  var qrPayment = TransferQrData(isValid: true);
  while (length < qrValue.length) {
    final qrField = _readQrField(qrValue, length);
    if (qrField != null) {
      qrPayment = _mappingQrField(qrField, qrPayment);
      length += qrField.fieldLength;
    } else {
      qrPayment.isValid = false;
      break;
    }
  }
  if (qrPayment.tag == null) {
    qrPayment.isValid = false;
  }
  // print("qrPayment ${qrPayment}");
  return qrPayment;
}

TransferQrAdditionalField _mappingAdditionalField(TransferQrField transferQrField, TransferQrAdditionalField qrAdditionalField) {
  switch (transferQrField.fieldNumber) {
    case "01":
      qrAdditionalField.additionalBillNumber = transferQrField.fieldValue;
      break;
    case "02":
      qrAdditionalField.additionalMobileNumber = transferQrField.fieldValue;
      break;
    case "03":
      qrAdditionalField.additionalStoreID = transferQrField.fieldValue;
      break;
    case "04":
      qrAdditionalField.additionalLoyaltyNumber = transferQrField.fieldValue;
      break;
    case "05":
      qrAdditionalField.additionalReferenceID = transferQrField.fieldValue;
      break;
    case "06":
      qrAdditionalField.additionalConsumerID = transferQrField.fieldValue;
      break;
    case "07":
      qrAdditionalField.additionalTerminalID = transferQrField.fieldValue;
      break;
    case "08":
      qrAdditionalField.additionalPursposeTransaction = transferQrField.fieldValue;
      break;
    case "09":
      qrAdditionalField.additionalConsumerDataRequest = transferQrField.fieldValue;
      break;
  }
  return qrAdditionalField;
}

TransferQrBillPayment _mappingQRBillPaymentField(TransferQrField transferQrField, TransferQrBillPayment qrBillPayment) {
  switch (transferQrField.fieldNumber) {
    case "00":
      qrBillPayment.aid = transferQrField.fieldValue;
      break;
    case "01":
      qrBillPayment.billerId = transferQrField.fieldValue;
      break;
    case "02":
      qrBillPayment.reference1 = transferQrField.fieldValue;
      break;
    case "03":
      qrBillPayment.reference2 = transferQrField.fieldValue;
      break;
  }
  return qrBillPayment;
}

TransferQrVerifySlip _mappingQRVerifySlip(TransferQrField transferQrField, TransferQrVerifySlip transferQrVerifySlip) {
  switch (transferQrField.fieldNumber) {
    case "00":
      transferQrVerifySlip.apiId = transferQrField.fieldValue;
      break;
    case "01": //Type mobile
      transferQrVerifySlip.bankId = transferQrField.fieldValue;
      break;
    case "02": //Type ref
      transferQrVerifySlip.transactionRef = transferQrField.fieldValue;
      break;
  }
  return transferQrVerifySlip;
}

TransferQrPromptPay _mappingQRPromptPayField(TransferQrField transferQrField, TransferQrPromptPay qrPromptPayPayment) {
  switch (transferQrField.fieldNumber) {
    case "00":
      qrPromptPayPayment.aid = transferQrField.fieldValue;
      break;
    case "01": //Type mobile
      qrPromptPayPayment.typeDestinationAccount = "Mobile";
      qrPromptPayPayment.destinationAccount = transferQrField.fieldValue;
      qrPromptPayPayment.destinationAccount = transferQrField.fieldValue.toString().length == 13
          ? "0" + transferQrField.fieldValue.toString().substring(4) //
          : transferQrField.fieldValue;
      break;
    case "02": //Type citizen
      qrPromptPayPayment.typeDestinationAccount = "Citizen";
      qrPromptPayPayment.destinationAccount = transferQrField.fieldValue;
      break;
    case "03": //Type e-wallet
      qrPromptPayPayment.typeDestinationAccount = "E-Wallet";
      qrPromptPayPayment.bankCode = transferQrField.fieldValue.substring(0, 3);
      qrPromptPayPayment.destinationAccount = transferQrField.fieldValue;
      qrPromptPayPayment.transferType = "QREW";
      if (qrPromptPayPayment.bankCode == "025") {
        qrPromptPayPayment.isValid = false;
      }
      break;
    case "04": //Type bank account
      qrPromptPayPayment.typeDestinationAccount = "BankAccount";
      qrPromptPayPayment.destinationAccount = transferQrField.fieldValue;
      break;
    case "05": //OTA
      qrPromptPayPayment.ota = transferQrField.fieldValue;
      break;
  }
  return qrPromptPayPayment;
}

TransferQrData _mappingQrField(TransferQrField qrField, TransferQrData qrPayment) {
  switch (qrField.fieldNumber) {
    case "00":
      qrPayment.version = qrField.fieldValue;

      final detectMiniQr = _readQrField(qrPayment.version, 0);
      if (detectMiniQr?.fieldValue == '000001') {
        var qrVerifySlip = TransferQrVerifySlip(isValid: qrPayment.isValid);
        qrVerifySlip.tag = "QRVerifySlip";

        var length = 0;
        while (length < qrPayment.version.length) {
          final qrVerifySlipData = _readQrField(qrPayment.version, length);
          if (qrVerifySlipData != null) {
            qrVerifySlip = _mappingQRVerifySlip(qrVerifySlipData, qrVerifySlip);
            length += qrVerifySlipData.fieldLength;
          } else {
            qrVerifySlip.isValid = false;
            break;
          }
        }
        qrPayment = qrVerifySlip;
      }

      break;
    case "01":
      qrPayment.type = qrField.fieldValue;
      break;
    case "29": //QR tag 29
      var qrPromptPay = TransferQrPromptPay(isValid: qrPayment.isValid);
      qrPromptPay.version = qrPayment.version;
      qrPromptPay.type = qrPayment.type;
      qrPromptPay.tag = "QRPayment29";
      qrPromptPay.transferType = "PromptPay";
      qrPromptPay.merchant = qrField.fieldValue;

      var length = 0;
      while (length < qrPromptPay.merchant.length) {
        final qrPromptPayMerchant = _readQrField(qrPromptPay.merchant, length);
        if (qrPromptPayMerchant != null) {
          qrPromptPay = _mappingQRPromptPayField(qrPromptPayMerchant, qrPromptPay);
          length += qrPromptPayMerchant.fieldLength;
        } else {
          qrPromptPay.isValid = false;
          break;
        }
      }
      qrPayment = qrPromptPay;
      break;
    case "30": //QR tag 30
      var qrBillPayment = TransferQrBillPayment(isValid: qrPayment.isValid);
      qrBillPayment.version = qrPayment.version;
      qrBillPayment.type = qrPayment.type;
      qrBillPayment.tag = "QRPayment30";
      qrBillPayment.transferType = "QR";
      qrBillPayment.merchant = qrField.fieldValue;
      var length = 0;
      while (length < qrBillPayment.merchant.length) {
        final qrBillPaymentMerchant = _readQrField(qrBillPayment.merchant, length);
        if (qrBillPaymentMerchant != null) {
          qrBillPayment = _mappingQRBillPaymentField(qrBillPaymentMerchant, qrBillPayment);
          length += qrBillPaymentMerchant.fieldLength;
        } else {
          qrBillPayment.isValid = false;
          break;
        }
      }
      qrPayment = qrBillPayment;

      break;
    case "51":
      qrPayment.countryCode = qrField.fieldValue;
      break;
    case "53":
      qrPayment.currencyCode = qrField.fieldValue;
      break;
    case "54":
      qrPayment.amount = double.parse(qrField.fieldValue);
      break;
    case "58":
      qrPayment.county = qrField.fieldValue;
      break;
    case "59":
      qrPayment.merchantName = qrField.fieldValue;
      break;
    case "60":
      qrPayment.merchantCity = qrField.fieldValue;
      break;
    case "62": //Additional field
      var length = 0;
      var qrAdditionalField = TransferQrAdditionalField();
      while (length < qrField.fieldValue.length) {
        final qrSubField = _readQrField(qrField.fieldValue, length);
        if (qrSubField != null) {
          qrAdditionalField = _mappingAdditionalField(qrSubField, qrAdditionalField);
          length += qrSubField.fieldLength;
        } else {
          qrPayment.isValid = false;
          break;
        }
      }
      qrPayment.qrAdditionalField = qrAdditionalField;
      break;
    case "63":
      qrPayment.checkSum = qrField.fieldValue;
      break;
    case "91":
      qrPayment.checkSum = qrField.fieldValue;
      break;
  }
  return qrPayment;
}

TransferQrField? _readQrField(String qrValue, int startPosition) {
  try {
    final fieldNumber = qrValue.substring(startPosition, startPosition + 2);
    final fieldLength = qrValue.substring(startPosition + 2, startPosition + 4);

    final startPositionValue = startPosition + fieldNumber.length + fieldLength.length;
    final endPositionValue = startPositionValue + int.parse(fieldLength);
    final fieldValue = qrValue.substring(startPositionValue, endPositionValue);
    final allFieldValue = "$fieldNumber$fieldLength$fieldValue";

    return TransferQrField(
      fieldNumber: fieldNumber,
      fieldValue: fieldValue,
      fieldLength: allFieldValue.length,
    );
  } catch (exception) {
    return null;
  }
}

class TransferQrField {
  final String fieldNumber;
  final String fieldValue;
  final int fieldLength;

  TransferQrField({
    required this.fieldNumber,
    required this.fieldValue,
    required this.fieldLength,
  });
}

class TransferQrVerifySlip extends TransferQrData {
  late String apiId;
  late String bankId;
  late String transactionRef;

  TransferQrVerifySlip({
    required bool isValid,
  }) : super(isValid: isValid);
}

class TransferQrPromptPay extends TransferQrData {
  late String aid;
  late String destinationAccount;
  late String typeDestinationAccount;
  late String ota;
  String? bankCode;

  TransferQrPromptPay({
    required bool isValid,
  }) : super(isValid: isValid);

  @override
  String toString() {
    return "Type Object: ${runtimeType.toString()} \nVersion: $version " //
        "\nType: $type \nTag: $tag  \nTransfer Type: $transferType" //
        "\nBank Code: $bankCode \nAmount: $amount \nMerchant city: $merchantCity" //
        "\nMerchant name: $merchantName" //
        "\nMerchant: $merchant \nAID: $aid \nDestinationAccount: $destinationAccount"
        "\nTypeDestinationAccount: $typeDestinationAccount \nAdditional field: $qrAdditionalField";
  }
}

class TransferQrBillPayment extends TransferQrData {
  late String aid;
  late String billerId;
  late String reference1;
  String? reference2;

  TransferQrBillPayment({
    required bool isValid,
  }) : super(isValid: isValid);

  @override
  String toString() {
    return "Type Object:${runtimeType.toString()} \nVersion: $version " //
        "\nType: $type \nTag: $tag  \nTransfer Type: $transferType" //
        "\nBiller id: $billerId \nAmount: $amount \nReference1: $reference1 \nReference2: $reference2" //
        "\nMerchant name: $merchantName" //
        "\nMerchant: $merchant \nAID: $aid "
        "\nAdditional field: $qrAdditionalField";
  }
}

class TransferQrAdditionalField {
  String? additionalBillNumber;
  String? additionalMobileNumber;
  String? additionalStoreID;
  String? additionalLoyaltyNumber;
  String? additionalReferenceID;
  String? additionalConsumerID;
  String? additionalTerminalID;
  String? additionalPursposeTransaction;
  String? additionalConsumerDataRequest;

  @override
  String toString() {
    return "Additional Bill Number: $additionalBillNumber " //
        "\nAdditional Mobile Number: $additionalMobileNumber \nAdditional store id: $additionalStoreID  " //
        "\nAdditional store id: $additionalLoyaltyNumber" //
        "\nAdditional reference id: $additionalReferenceID \nAdditional terminal id: $additionalTerminalID" //
        "\nAdditional purpose transaction: $additionalPursposeTransaction" //
        "\nAdditional consumer data: $additionalConsumerDataRequest ";
  }
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
  TransferQrAdditionalField? qrAdditionalField;
  late String countryCode;
  bool isValid;

  TransferQrData({
    required this.isValid,
  });
}
