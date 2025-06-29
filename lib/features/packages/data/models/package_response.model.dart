import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/data/models/review_aggregate_response.model.dart';
import 'package:wisatabumnag/shared/data/models/ticketable_response.model.dart';
part 'package_response.model.freezed.dart';
part 'package_response.model.g.dart';

@freezed
abstract class PackageResponse with _$PackageResponse {
  const factory PackageResponse({
    required int id,
    required String name,
    required String? priceInclude,
    required String? priceExclude,
    required String? activities,
    required String? destination,
    required List<String> media,
    required List<CategoryModel> categories,
    required ReviewAggregateResponse reviews,
    required List<TicketableResponse> tickets,
  }) = _PackageResponse;

  factory PackageResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageResponseFromJson(json);
}

extension PackageResponseX on PackageResponse {
  Package toDomain() => Package(
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
      );
}
