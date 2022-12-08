import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
part 'payment_form.entity.freezed.dart';

@freezed
class PaymentForm with _$PaymentForm {
  const factory PaymentForm({
    required String orderNumber,
    required PaymentType paymentType,
  }) = _PaymentForm;
}
