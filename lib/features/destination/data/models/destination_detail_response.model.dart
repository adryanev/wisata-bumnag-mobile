import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_response.model.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/data/models/reviewable_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';

part 'destination_detail_response.model.freezed.dart';
part 'destination_detail_response.model.g.dart';

@freezed
class DestinationDetailResponse with _$DestinationDetailResponse {
  const factory DestinationDetailResponse({
    required int id,
    required String name,
    required String description,
    required String address,
    required String? phoneNumber,
    required String? email,
    required String? latitude,
    required String? longitude,
    required String? openingHours,
    required String? closingHours,
    required String? workingDay,
    required String? instagram,
    required String? website,
    required String? capacity,
    required List<CategoryModel> categories,
    required List<String> media,
    required ReviewableResponse reviews,
    required List<TicketableResponse> tickets,
    required List<DestinationResponse> recommendations,
  }) = _DestinationDetailResponse;

  factory DestinationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationDetailResponseFromJson(json);
}

extension DestinationDetailResponseX on DestinationDetailResponse {
  DestinationDetail toDomain() => DestinationDetail(
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
        recommendations: recommendations.map((e) => e.toDomain()).toList(),
      );
}
