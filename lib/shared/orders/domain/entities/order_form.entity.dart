import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
part 'order_form.entity.freezed.dart';

@freezed
abstract class OrderForm with _$OrderForm {
  const factory OrderForm({
    required double totalPrice,
    required DateTime orderDate,
    required List<Orderable> orderDetails,
  }) = _OrderForm;
}
