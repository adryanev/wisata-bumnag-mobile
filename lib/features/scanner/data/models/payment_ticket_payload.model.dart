import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/payment_ticket_form.entity.dart';
part 'payment_ticket_payload.model.freezed.dart';
part 'payment_ticket_payload.model.g.dart';

@freezed
abstract class PaymentTicketPayload with _$PaymentTicketPayload {
  const factory PaymentTicketPayload({
    required String orderNumber,
  }) = _PaymentTicketPayload;

  factory PaymentTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$PaymentTicketPayloadFromJson(json);

  factory PaymentTicketPayload.fromDomain(PaymentTicketForm form) =>
      PaymentTicketPayload(orderNumber: form.orderNumber);
}
