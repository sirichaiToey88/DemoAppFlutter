import 'dart:convert';
import 'package:flutter/material.dart';

const defaultLength = 2;
const defaultStartTag = "00";

class EmvcoTlvBean {
  int length;
  String value;
  Map<String, EmvcoTlvBean>? subTag;

  EmvcoTlvBean({
    required this.length,
    required this.value,
    this.subTag,
  });

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'value': value,
      'subTag': subTag?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

bool isInteger(String str) {
  return int.tryParse(str) != null;
}

Map<String, EmvcoTlvBean> parseSubTagValue(String value) {
  final result = <String, EmvcoTlvBean>{};
  if (value.length > 4) {
    final tag = value.substring(0, defaultLength);
    final lengthStr = value.substring(defaultLength, defaultLength * 2);
    if (tag == defaultStartTag && isInteger(tag) && isInteger(lengthStr)) {
      final length = int.parse(lengthStr);
      if (length > 0) {
        final parse = parseQRCodeValue(value, true);
        result.addAll(parse);
      }
    }
  }
  return result;
}

Map<String, EmvcoTlvBean> parseQRCodeValue(String qrCodeValue, bool isFromSubtag) {
  final result = <String, EmvcoTlvBean>{};
  var i = 0;
  while (i < qrCodeValue.length) {
    final tagInd = i + defaultLength;
    final tag = int.parse(qrCodeValue.substring(i, tagInd));
    final lengthInd = tagInd + defaultLength;
    final lengthValue = int.parse(qrCodeValue.substring(tagInd, lengthInd));
    final emvcoTlvBean = EmvcoTlvBean(
      length: lengthValue,
      value: qrCodeValue.substring(lengthInd, lengthInd + lengthValue),
    );

    if (!isFromSubtag) {
      final subTagJSON = parseSubTagValue(emvcoTlvBean.value);
      if (subTagJSON.isNotEmpty) {
        emvcoTlvBean.subTag = subTagJSON;
      }
    }

    result["tag$tag"] = emvcoTlvBean;

    i = lengthInd + lengthValue;
  }
  return result;
}