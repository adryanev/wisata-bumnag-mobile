import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/packages/domain/entities/amenity.entity.dart';

part 'amenity_response.model.freezed.dart';
part 'amenity_response.model.g.dart';

@freezed
class AmenityResponse with _$AmenityResponse {
  const factory AmenityResponse({
    required int? id,
    required int? packageId,
    required String? name,
    required double? price,
    required String? description,
    required int? quantity,
  }) = _AmenityResponse;

  factory AmenityResponse.fromJson(Map<String, dynamic> json) =>
      _$AmenityResponseFromJson(json);
}

extension AmenityResponseX on AmenityResponse {
  Amenity toDomain() => Amenity(
        id: id ?? 0,
        packageId: packageId ?? 0,
        name: name ?? '',
        description: description ?? '',
        price: price ?? 0,
        quantity: quantity ?? 0,
      );
}
