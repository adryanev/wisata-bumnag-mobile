import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/review_aggregate.entity.dart';
part 'destination.entity.freezed.dart';

@freezed
class Destination with _$Destination {
  const factory Destination({
    required int id,
    required String name,
    required String description,
    required String? address,
    required String? phoneNumber,
    required String? email,
    required String? latitude,
    required String? longitude,
    required int? openingHours,
    required int? closingHours,
    required String? instagram,
    required String? website,
    required String? capacity,
    required List<Category> categories,
    required List<String> media,
    required ReviewAggregate reviews,
  }) = _Destination;
}
