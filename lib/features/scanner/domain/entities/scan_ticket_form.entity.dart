import 'package:freezed_annotation/freezed_annotation.dart';
part 'scan_ticket_form.entity.freezed.dart';

@freezed
class ScanTicketForm with _$ScanTicketForm {
  const factory ScanTicketForm({
    required String number,
    required DateTime orderDate,
  }) = _ScanTicketForm;
}
