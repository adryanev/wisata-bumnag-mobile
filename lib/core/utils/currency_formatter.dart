import 'package:intl/intl.dart';

String? rupiahCurrency(double? price) {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');

  return formatCurrency.format(price ?? 0);
}
