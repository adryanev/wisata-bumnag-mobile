import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_response.model.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
part 'recommendation_response.model.freezed.dart';

part 'recommendation_response.model.g.dart';

@freezed
class RecommendationResponse with _$RecommendationResponse {
  const factory RecommendationResponse({
    required int id,
    required String name,
    required String rank,
    required DestinationResponse destination,
  }) = _RecommendationResponse;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);
}

extension RecommendationResponseX on RecommendationResponse {
  Recommendation toDomain() => Recommendation(
        id: id,
        name: name,
        rank: rank,
        destination: destination.toDomain(),
      );
}
