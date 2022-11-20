import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/shared/data/models/review_aggregate_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';
part 'event_response.model.freezed.dart';
part 'event_response.model.g.dart';

@freezed
class EventResponse with _$EventResponse {
  const factory EventResponse({
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
    required ReviewAggregateResponse reviews,
    required List<TicketableResponse> tickets,
  }) = _EventResponse;

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);
}

extension EventResponseX on EventResponse {
  Event toDomain() => Event(
        id: id,
        name: name,
        description: description,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        latitude: latitude,
        longitude: longitude,
        startDate: startDate,
        endDate: endDate,
        termAndCondition: termAndCondition,
        instagram: instagram,
        website: website,
        capacity: capacity,
        createdAt: createdAt,
        updatedAt: updatedAt,
        media: media,
        reviews: reviews.toDomain(),
        tickets: tickets.map((e) => e.toDomain()).toList(),
      );
}
