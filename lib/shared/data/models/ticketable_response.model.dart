import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/data/models/ticket_setting_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'ticketable_response.model.freezed.dart';
part 'ticketable_response.model.g.dart';

@freezed
abstract class TicketableResponse with _$TicketableResponse {
  const factory TicketableResponse({
    required int id,
    required String name,
    required double price,
    required bool isFree,
    required String? termAndConditions,
    required bool? isQuantityLimited,
    required int? quantity,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required String? description,
    required String? ticketableType,
    required int? ticketableId,
    required TicketSettingResponse? settings,
  }) = _TicketableResponse;

  factory TicketableResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketableResponseFromJson(json);
}

extension TicketableResponseX on TicketableResponse {
  Ticketable toDomain() => Ticketable(
        id: id,
        name: name,
        price: price,
        isFree: isFree,
        termAndConditions: termAndConditions,
        isQuantityLimited: isQuantityLimited,
        quantity: quantity,
        createdAt: createdAt,
        updatedAt: updatedAt,
        description: description,
        ticketableType: ticketableType,
        ticketableId: ticketableId,
        settings: settings?.toDomain(),
      );
}
