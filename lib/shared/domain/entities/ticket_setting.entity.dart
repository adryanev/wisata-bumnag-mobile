import 'package:freezed_annotation/freezed_annotation.dart';
part 'ticket_setting.entity.freezed.dart';

@freezed
abstract class TicketSetting with _$TicketSetting {
  const factory TicketSetting({
    required int id,
    required int ticketId,
    required bool isPerPax,
    required int? paxConstraint,
    required bool isPerDay,
    required String? dayConstraint,
    required bool isPerAge,
    required int? ageConstraint,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TicketSetting;
}
