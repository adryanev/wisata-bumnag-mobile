import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/approve_ticket_form.entity.dart';
part 'approve_ticket_payload.model.freezed.dart';
part 'approve_ticket_payload.model.g.dart';

@freezed
class ApproveTicketPayload with _$ApproveTicketPayload {
  const factory ApproveTicketPayload({
    required String number,
    required DateTime orderDate,
  }) = _ApproveTicketPayload;
  factory ApproveTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$ApproveTicketPayloadFromJson(json);

  factory ApproveTicketPayload.fromDomain(ApproveTicketForm form) =>
      ApproveTicketPayload(number: form.number, orderDate: form.orderDate);
}
