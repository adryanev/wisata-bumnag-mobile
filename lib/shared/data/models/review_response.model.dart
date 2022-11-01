import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/review.entity.dart';
part 'review_response.model.freezed.dart';
part 'review_response.model.g.dart';

@freezed
class ReviewResponse with _$ReviewResponse {
  const factory ReviewResponse({
    required int id,
    required String title,
    required String? description,
    required String reviewableId,
    required String reviewableType,
    required UserDataResponse user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReviewResponse;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);
}

extension ReviewResponseX on ReviewResponse {
  Review toDomain() => Review(
        id: id,
        title: title,
        description: description,
        reviewableId: reviewableId,
        reviewableType: reviewableType,
        user: user.toDomain(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
