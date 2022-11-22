import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/home/domain/entities/explore.entity.dart';
part 'explore_response.model.freezed.dart';
part 'explore_response.model.g.dart';

@freezed
class ExploreResponse with _$ExploreResponse {
  const factory ExploreResponse({
    required int id,
    required double rating,
    required String title,
    required String description,
    required ExploreUserResponse user,
    required ExploreReviewableResponse reviewable,
    required List<String> media,
    required DateTime createdAt,
  }) = _ExploreResponse;

  factory ExploreResponse.fromJson(Map<String, dynamic> json) =>
      _$ExploreResponseFromJson(json);
}

extension ExploreResponseX on ExploreResponse {
  Explore toDomain() => Explore(
        id: id,
        rating: rating,
        title: title,
        description: description,
        user: user.toDomain(),
        reviewable: reviewable.toDomain(),
        media: media,
        createdAt: createdAt,
      );
}

@freezed
class ExploreUserResponse with _$ExploreUserResponse {
  const factory ExploreUserResponse({
    required int id,
    required String name,
    required String email,
    required String? avatar,
  }) = _ExploreUserResponse;
  factory ExploreUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ExploreUserResponseFromJson(json);
}

extension ExploreUserResponseX on ExploreUserResponse {
  ExploreUser toDomain() => ExploreUser(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
      );
}

@freezed
class ExploreReviewableResponse with _$ExploreReviewableResponse {
  const factory ExploreReviewableResponse({
    required int id,
    required String? type,
    required String name,
    required List<String> media,
  }) = _ExploreReviewableResponse;
  factory ExploreReviewableResponse.fromJson(Map<String, dynamic> json) =>
      _$ExploreReviewableResponseFromJson(json);
}

extension ExploreReviewableResponseX on ExploreReviewableResponse {
  ExploreReviewable toDomain() => ExploreReviewable(
        id: id,
        type: type,
        name: name,
        media: media,
      );
}
