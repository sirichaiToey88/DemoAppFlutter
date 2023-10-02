import 'package:intl/intl.dart';

String formatThaiDate(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final thaiDateFormatter = DateFormat('dd MMMM yyyy');
  String thaiFormat = formatShortDateThai(dateString);
  return thaiFormat;
}

String formatInternationalDate(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final internationalDateFormatter = DateFormat('dd MMMM yyyy');
  return internationalDateFormatter.format(dateTime);
}

// Given input data
List<String> monthsInThai = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

List<String> shortMonthsInThai = [
  'ม.ค.',
  'ก.พ.',
  'ม.ค.',
  'ม.ย.',
  'พ.ค.',
  'มิ.ย.',
  'ก.ค.',
  'ส.ค.',
  'ก.ย.',
  'ต.ค.',
  'พ.ย.',
  'ธ.ค.',
];

String formatDateThai(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  int day = date.day;
  int month = date.month;
  int year = date.year;

  String formattedDate = '$day ${monthsInThai[month - 1]} $year';
  return formattedDate;
}

String formatShortDateThai(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  int day = date.day;
  int month = date.month;
  int year = date.year;

  String formattedDate = '$day ${shortMonthsInThai[month - 1]} $year';
  return formattedDate;
}
