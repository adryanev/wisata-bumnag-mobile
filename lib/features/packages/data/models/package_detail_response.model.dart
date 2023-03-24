import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/packages/data/models/amenity_response.model.dart';
import 'package:wisatabumnag/features/packages/data/models/package_response.model.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/data/models/reviewable_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';

part 'package_detail_response.model.freezed.dart';
part 'package_detail_response.model.g.dart';

@freezed
class PackageDetailResponse with _$PackageDetailResponse {
  const factory PackageDetailResponse({
    required int id,
    required String name,
    required String? priceInclude,
    required String? priceExclude,
    required String? activities,
    required String? destination,
    required List<String> media,
    required List<CategoryModel> categories,
    required ReviewableResponse reviews,
    required List<TicketableResponse> tickets,
    required List<PackageResponse> recommendations,
    required List<AmenityResponse> amenities,
  }) = _PackageDetailResponse;

  factory PackageDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageDetailResponseFromJson(json);
}

extension PackageDetailResponseX on PackageDetailResponse {
  PackageDetail toDomain() => PackageDetail(
        id: id,
        name: name,
        priceInclude: priceInclude,
        priceExclude: priceExclude,
        activities: activities,
        destination: destination,
        media: media,
        categories: categories.map((e) => e.toDomain()).toList(),
        reviews: reviews.toDomain(),
        tickets: tickets.map((e) => e.toDomain()).toList(),
        recommendations: recommendations.map((e) => e.toDomain()).toList(),
        amenities: amenities.map((e) => e.toDomain()).toList(),
      );
}
