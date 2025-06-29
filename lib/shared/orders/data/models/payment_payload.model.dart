import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/payment_form.entity.dart';

part 'payment_payload.model.freezed.dart';
part 'payment_payload.model.g.dart';

@freezed
abstract class PaymentPayload with _$PaymentPayload {
  const factory PaymentPayload({
    required String orderNumber,
    required String paymentType,
  }) = _PaymentPayload;

  factory PaymentPayload.fromJson(Map<String, dynamic> json) =>
      _$PaymentPayloadFromJson(json);

  factory PaymentPayload.fromDomain(PaymentForm form) => PaymentPayload(
        orderNumber: form.orderNumber,
        paymentType: PaymentTypeMapper.toStringType(form.paymentType),
      );
}
