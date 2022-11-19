import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/data/models/reviewable_response.model.dart';

part 'souvenir_detail_response.model.freezed.dart';
part 'souvenir_detail_response.model.g.dart';

@freezed
class SouvenirDetailResponse with _$SouvenirDetailResponse {
  const factory SouvenirDetailResponse({
    required int id,
    required String name,
    required double? price,
    required bool isFree,
    required String? termAndConditions,
    required int? quantity,
    required String? description,
    required int destinationId,
    required List<String> media,
    required List<CategoryModel> categories,
    @JsonKey(name: 'reviews') required ReviewableResponse reviews,
    required List<SouvenirResponse> recommendations,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SouvenirDetailResponse;

  factory SouvenirDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$SouvenirDetailResponseFromJson(json);
}

extension SouvenirDetailResponseX on SouvenirDetailResponse {
  SouvenirDetail toDomain() => SouvenirDetail(
        id: id,
        name: name,
        price: price ?? 0,
        isFree: isFree,
        termAndConditions: termAndConditions,
        quantity: quantity,
        description: description,
        destinationId: destinationId,
        media: media,
        reviews: reviews.toDomain(),
        categories: categories.map((e) => e.toDomain()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
        recommendations: recommendations.map((e) => e.toDomain()).toList(),
      );
}
