import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/reviewable.entity.dart';
part 'souvenir_detail.entity.freezed.dart';

@freezed
class SouvenirDetail with _$SouvenirDetail {
  const factory SouvenirDetail({
    required int id,
    required String name,
    required double price,
    required bool isFree,
    required String? termAndConditions,
    required int? quantity,
    required String? description,
    required int destinationId,
    required List<String> media,
    required Reviewable reviews,
    required List<Category> categories,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SouvenirDetail;
}
