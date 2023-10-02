import 'package:intl/intl.dart';

String formatThaiBaht(double amount) {
  final formatter = NumberFormat.currency(
    symbol: '฿',
    decimalDigits: 2,
    locale: 'th',
  );
  return formatter.format(amount);
}
