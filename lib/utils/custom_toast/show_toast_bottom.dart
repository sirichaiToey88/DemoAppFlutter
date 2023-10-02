import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToastBottom(String message, {required Color backgroundColor, required Color textColor}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor ?? Colors.black87,
    textColor: textColor ?? Colors.white,
    fontSize: 16.0,
  );
}
