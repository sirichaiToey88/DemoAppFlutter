// form_validation.dart
import 'package:flutter/material.dart';

bool validateInputs({
  required TextEditingController brandNameController,
  required TextEditingController timeOpenController,
  required TextEditingController timeCloseController,
  required TextEditingController tellController,
  required TextEditingController addressController,
}) {
  bool isValid = true;

  // ตรวจสอบและกำหนดข้อความผิดพลาดของ brandName
  if (brandNameController.text.isEmpty) {
    isValid = false;
  }

  // ตรวจสอบและกำหนดข้อความผิดพลาดของ timeOpen
  if (timeOpenController.text.isEmpty) {
    isValid = false;
  }

  // ตรวจสอบและกำหนดข้อความผิดพลาดของ timeClose
  if (timeCloseController.text.isEmpty) {
    isValid = false;
  }

  // ตรวจสอบและกำหนดข้อความผิดพลาดของ tell
  if (tellController.text.isEmpty) {
    isValid = false;
  }

  // ตรวจสอบและกำหนดข้อความผิดพลาดของ address
  if (addressController.text.isEmpty) {
    isValid = false;
  }

  // เช็คเวลาปิดไม่น้อยกว่าเวลาเปิด
  if (timeOpenController.text.isNotEmpty) {
    final timeOpen = timeOpenController.text.split(':');
    final timeClose = timeCloseController.text.split(':');
    final int hourOpen = int.parse(timeOpen[0]);
    final int minuteOpen = int.parse(timeOpen[1]);
    final int hourClose = int.parse(timeClose[0]);
    final int minuteClose = int.parse(timeClose[1]);

    if (hourClose < hourOpen || (hourClose == hourOpen && minuteClose < minuteOpen)) {
      isValid = false;
    }
  }

  return isValid;
}
