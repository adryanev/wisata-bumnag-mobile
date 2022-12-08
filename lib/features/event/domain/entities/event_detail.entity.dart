import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/reviewable.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'event_detail.entity.freezed.dart';

@freezed
class EventDetail with _$EventDetail {
  const factory EventDetail({
    required int id,
    required String name,
    required String? description,
    required String address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double? longitude,
    required DateTime startDate,
    required DateTime endDate,
    required String? termAndCondition,
    required String? instagram,
    required String? website,
    required String? capacity,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> media,
    required Reviewable reviews,
    required List<Ticketable> tickets,
    required List<Event> recommendations,
  }) = _EventDetail;
}
