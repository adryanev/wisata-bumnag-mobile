import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_ticket_form.entity.freezed.dart';

@freezed
class PaymentTicketForm with _$PaymentTicketForm {
  const factory PaymentTicketForm({
    required String orderNumber,
  }) = _PaymentTicketForm;
}
