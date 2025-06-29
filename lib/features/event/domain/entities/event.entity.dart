import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/review_aggregate.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'event.entity.freezed.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    required int id,
    required String name,
    required String? description,
    required String address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required String? termAndCondition,
    required String? instagram,
    required String? website,
    required String? capacity,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> media,
    required ReviewAggregate reviews,
    required List<Ticketable> tickets,
  }) = _Event;
}
