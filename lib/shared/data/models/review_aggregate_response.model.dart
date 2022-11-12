import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/review_aggregate.entity.dart';
part 'review_aggregate_response.model.freezed.dart';
part 'review_aggregate_response.model.g.dart';

@freezed
class ReviewAggregateResponse with _$ReviewAggregateResponse {
  const factory ReviewAggregateResponse({
    required int count,
    required double? rating,
  }) = _ReviewAggregateResponse;

  factory ReviewAggregateResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewAggregateResponseFromJson(json);
}

extension ReviewAggregateResponseX on ReviewAggregateResponse {
  ReviewAggregate toDomain() => ReviewAggregate(
        count: count,
        rating: rating,
      );
}
