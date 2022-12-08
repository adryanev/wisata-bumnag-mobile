import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
part 'recommendation.entity.freezed.dart';

@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    required int id,
    required String name,
    required String rank,
    required Destination destination,
  }) = _Recommendation;
}
