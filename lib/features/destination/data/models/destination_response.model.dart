import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/data/models/review_aggregate_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';

part 'destination_response.model.freezed.dart';
part 'destination_response.model.g.dart';

@freezed
abstract class DestinationResponse with _$DestinationResponse {
  const factory DestinationResponse({
    required int id,
    required String name,
    required String description,
    required String? address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double? longitude,
    required String? openingHours,
    required String? closingHours,
    required String? workingDay,
    required String? instagram,
    required String? website,
    required int? capacity,
    required List<CategoryModel> categories,
    required List<String> media,
    @JsonKey(name: 'reviews') required ReviewAggregateResponse reviews,
    @JsonKey(name: 'tickets') required List<TicketableResponse> tickets,
  }) = _DestinationResponse;

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationResponseFromJson(json);
}

extension DestinationResponseX on DestinationResponse {
  Destination toDomain() => Destination(
        id: id,
        name: name,
        description: description,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        latitude: latitude,
        longitude: longitude,
        openingHours: openingHours,
        closingHours: closingHours,
        workingDay: workingDay,
        instagram: instagram,
        website: website,
        capacity: capacity,
        categories: categories.map((e) => e.toDomain()).toList(),
        media: media,
        reviews: reviews.toDomain(),
        tickets: tickets.map((e) => e.toDomain()).toList(),
      );
}
