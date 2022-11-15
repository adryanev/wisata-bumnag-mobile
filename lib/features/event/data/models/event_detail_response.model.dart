import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/event/data/models/event_response.model.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/shared/data/models/review_response.model.dart';
import 'package:wisatabumnag/shared/data/models/reviewable_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';
part 'event_detail_response.model.freezed.dart';
part 'event_detail_response.model.g.dart';

@freezed
class EventDetailResponse with _$EventDetailResponse {
  const factory EventDetailResponse({
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
    required ReviewableResponse reviews,
    required List<TicketableResponse> tickets,
    required List<EventResponse> recommendations,
  }) = _EventDetailResponse;

  factory EventDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$EventDetailResponseFromJson(json);
}

extension EventDetailResponseX on EventDetailResponse {
  EventDetail toDomain() => EventDetail(
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
        recommendations: recommendations.map((e) => e.toDomain()).toList(),
      );
}
