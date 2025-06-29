import 'package:freezed_annotation/freezed_annotation.dart';
part 'explore.entity.freezed.dart';

@freezed
abstract class Explore with _$Explore {
  const factory Explore({
    required int id,
    required double rating,
    required String title,
    required String description,
    required ExploreUser user,
    required ExploreReviewable reviewable,
    required List<String> media,
    required DateTime createdAt,
  }) = _Explore;
}

@freezed
abstract class ExploreUser with _$ExploreUser {
  const factory ExploreUser({
    required int id,
    required String name,
    required String email,
    required String? avatar,
  }) = _ExploreUser;
}

@freezed
abstract class ExploreReviewable with _$ExploreReviewable {
  const factory ExploreReviewable({
    required int id,
    required String? type,
    required String name,
    required List<String> media,
  }) = _ExploreReviewable;
}
