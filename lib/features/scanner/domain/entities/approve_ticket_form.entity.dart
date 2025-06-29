import 'package:freezed_annotation/freezed_annotation.dart';
part 'approve_ticket_form.entity.freezed.dart';

@freezed
abstract class ApproveTicketForm with _$ApproveTicketForm {
  const factory ApproveTicketForm({
    required String number,
    required DateTime orderDate,
  }) = _ApproveTicketForm;
}
