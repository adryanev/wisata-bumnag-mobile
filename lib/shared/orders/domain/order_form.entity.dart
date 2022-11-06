import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/orderable.entity.dart';
part 'order_form.entity.freezed.dart';

@freezed
class OrderForm with _$OrderForm {
  const factory OrderForm({
    required double totalPrice,
    required List<Orderable> orderDetails,
  }) = _OrderForm;
}
