import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/scan_ticket_form.entity.dart';
part 'scan_ticket_payload.model.freezed.dart';
part 'scan_ticket_payload.model.g.dart';

@freezed
class ScanTicketPayload with _$ScanTicketPayload {
  const factory ScanTicketPayload({
    required String number,
    required DateTime orderDate,
  }) = _ScanTicketPayload;
  factory ScanTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$ScanTicketPayloadFromJson(json);

  factory ScanTicketPayload.fromDomain(ScanTicketForm form) =>
      ScanTicketPayload(number: form.number, orderDate: form.orderDate);
}
