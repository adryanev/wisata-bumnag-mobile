import 'package:freezed_annotation/freezed_annotation.dart';
part 'souvenir.entity.freezed.dart';

@freezed
class Souvenir with _$Souvenir {
  const factory Souvenir({
    required int id,
    required String name,
    required double price,
    required bool isFree,
    required String? termAndConditions,
    required int? quantity,
    required String? description,
    required int destinationId,
    required List<String> media,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Souvenir;
}
