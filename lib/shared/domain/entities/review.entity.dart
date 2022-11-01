import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
part 'review.entity.freezed.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required int id,
    required String title,
    required String? description,
    required String reviewableId,
    required String reviewableType,
    required User user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Review;
}
