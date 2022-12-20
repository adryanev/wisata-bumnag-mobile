import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/ticket_setting.entity.dart';
part 'ticket_setting_response.model.freezed.dart';
part 'ticket_setting_response.model.g.dart';

@freezed
class TicketSettingResponse with _$TicketSettingResponse {
  const factory TicketSettingResponse({
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
  }) = _TicketSettingResponse;

  factory TicketSettingResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketSettingResponseFromJson(json);
}

extension TicketSettingResponseX on TicketSettingResponse {
  TicketSetting toDomain() => TicketSetting(
        id: id,
        ticketId: ticketId,
        isPerPax: isPerPax,
        paxConstraint: paxConstraint,
        isPerDay: isPerDay,
        dayConstraint: dayConstraint,
        isPerAge: isPerAge,
        ageConstraint: ageConstraint,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
