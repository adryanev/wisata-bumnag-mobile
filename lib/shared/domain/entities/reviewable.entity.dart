import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/review.entity.dart';
part 'reviewable.entity.freezed.dart';

@freezed
abstract class Reviewable with _$Reviewable {
  const factory Reviewable({
    required int count,
    required double? rating,
    required List<Review> data,
  }) = _Reviewable;
}
