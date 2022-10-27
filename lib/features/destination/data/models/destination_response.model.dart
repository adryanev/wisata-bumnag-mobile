import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';

part 'destination_response.model.freezed.dart';
part 'destination_response.model.g.dart';

@freezed
class DestinationResponse with _$DestinationResponse {
  const factory DestinationResponse({
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
    required List<CategoryModel> categories,
    required List<String> media,
  }) = _DestinationResponse;

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationResponseFromJson(json);
}

extension DestinationResponseX on DestinationResponse {
  Destination toDomain() => Destination(
        id: id,
        name: name,
        description: description,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        latitude: latitude,
        longitude: longitude,
        openingHours: openingHours,
        closingHours: closingHours,
        instagram: instagram,
        website: website,
        capacity: capacity,
        categories: categories.map((e) => e.toDomain()).toList(),
        media: media,
      );
}
