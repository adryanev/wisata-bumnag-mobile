import 'package:freezed_annotation/freezed_annotation.dart';
part 'review_aggregate.entity.freezed.dart';

@freezed
class ReviewAggregate with _$ReviewAggregate {
  const factory ReviewAggregate({
    required int count,
    required double? rating,
  }) = _ReviewAggregate;
}
