import 'dart:convert';
import 'package:flutter/material.dart';

const defaultLength = 2;
const defaultStartTag = "00";

class EmvcoTlvBeanString {
  int length;
  String value;
  Map<String, EmvcoTlvBeanString>? subTag;

  EmvcoTlvBeanString({
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

Map<String, String> parseSubTagValue(String value) {
  final result = <String, String>{};
  if (value.length > 4) {
    final tag = value.substring(0, defaultLength);
    final lengthStr = value.substring(defaultLength, defaultLength * 2);
    if (tag == defaultStartTag && isInteger(tag) && isInteger(lengthStr)) {
      final length = int.parse(lengthStr);
      if (length > 0) {
        final parse = parseQRCodeValueString(value, true);
        if (parse != null) {
          result.addAll(parse);
        }
      }
    }
  }
  return result;
}

Map<String, String>? parseQRCodeValueString(String qrCodeValue, bool isFromSubtag) {
  final result = <String, String>{};
  var i = 0;
  while (i < qrCodeValue.length) {
    final tagInd = i + defaultLength;
    final tag = int.tryParse(qrCodeValue.substring(i, tagInd));
    final lengthInd = tagInd + defaultLength;
    final lengthValue = int.tryParse(qrCodeValue.substring(tagInd, lengthInd));
    final value = qrCodeValue.substring(lengthInd, lengthInd + (lengthValue ?? 0));

    if (!isFromSubtag) {
      final subTagJSON = parseSubTagValue(value);
      if (subTagJSON.isNotEmpty) {
        result['tag${tag ?? 0}'] = subTagJSON['tag2'] ?? '';
      }
    } else {
      result['tag${tag ?? 0}'] = value;
    }

    i = lengthInd + (lengthValue ?? 0);
  }
  return result.isEmpty ? null : result;
}
