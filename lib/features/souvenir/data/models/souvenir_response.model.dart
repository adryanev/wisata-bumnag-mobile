import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/data/models/review_aggregate_response.model.dart';

part 'souvenir_response.model.freezed.dart';
part 'souvenir_response.model.g.dart';

@freezed
abstract class SouvenirResponse with _$SouvenirResponse {
  const factory SouvenirResponse({
    required int id,
    required String name,
    required double? price,
    required bool isFree,
    required String? termAndConditions,
    required int? quantity,
    required String? description,
    required int destinationId,
    required List<String> media,
    @JsonKey(name: 'reviews') required ReviewAggregateResponse reviews,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SouvenirResponse;

  factory SouvenirResponse.fromJson(Map<String, dynamic> json) =>
      _$SouvenirResponseFromJson(json);
}

extension SouvenirResponseX on SouvenirResponse {
  Souvenir toDomain() => Souvenir(
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
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
