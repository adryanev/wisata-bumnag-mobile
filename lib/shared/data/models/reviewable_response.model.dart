import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/data/models/review_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/reviewable.entity.dart';
part 'reviewable_response.model.freezed.dart';
part 'reviewable_response.model.g.dart';

@freezed
class ReviewableResponse with _$ReviewableResponse {
  const factory ReviewableResponse({
    required int count,
    required double? rating,
    required List<ReviewResponse> data,
  }) = _ReviewableResponse;

  factory ReviewableResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewableResponseFromJson(json);
}

extension ReviewableResponseX on ReviewableResponse {
  Reviewable toDomain() => Reviewable(
        count: count,
        rating: rating,
        data: data.map((e) => e.toDomain()).toList(),
      );
}
