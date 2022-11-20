import 'package:freezed_annotation/freezed_annotation.dart';
part 'ticket_setting.entity.freezed.dart';

@freezed
class TicketSetting with _$TicketSetting {
  const factory TicketSetting({
    required int id,
    required int ticketId,
    required bool isPerPax,
    required String? paxConstraint,
    required bool isPerDay,
    required String? dayConstraint,
    required bool isPerAge,
    required String? ageConstraint,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TicketSetting;
}
