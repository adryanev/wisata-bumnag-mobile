import 'package:intl/intl.dart';

String? rupiahCurrency(double? price, {int? decimalDigit}) {
  final formatCurrency = NumberFormat.simpleCurrency(
    locale: 'id_ID',
    decimalDigits: decimalDigit,
  );

  return formatCurrency.format(price ?? 0);
}
