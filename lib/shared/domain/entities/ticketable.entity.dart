import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/ticket_setting.entity.dart';
part 'ticketable.entity.freezed.dart';

@freezed
abstract class Ticketable with _$Ticketable {
  const factory Ticketable({
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
    required TicketSetting? settings,
  }) = _Ticketable;
}
