import 'package:intl/intl.dart';

String? rupiahCurrency(double? price, {int? decimalDigit}) {
  final formatCurrency = NumberFormat.simpleCurrency(
    locale: 'id_ID',
    decimalDigits: decimalDigit ?? 0,
  );

  return formatCurrency.format(price ?? 0);
}
