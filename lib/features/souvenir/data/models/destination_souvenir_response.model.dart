import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
part 'destination_souvenir_response.model.freezed.dart';
part 'destination_souvenir_response.model.g.dart';

@freezed
class DestinationSouvenirResponse with _$DestinationSouvenirResponse {
  const factory DestinationSouvenirResponse({
    required int id,
    required String name,
    required String description,
    required String? address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double? longitude,
    required String? openingHours,
    required String? closingHours,
    required String? workingDay,
    required String? instagram,
    required String? website,
    required String? capacity,
    required List<SouvenirResponse> souvenirs,
  }) = _DestinationSouvenirResponse;

  factory DestinationSouvenirResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationSouvenirResponseFromJson(json);
}

extension DestinationSouvenirResponseX on DestinationSouvenirResponse {
  DestinationSouvenir toDomain() => DestinationSouvenir(
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
        workingDay: workingDay,
        instagram: instagram,
        website: website,
        capacity: capacity,
        souvenirs: souvenirs.map((e) => e.toDomain()).toList(),
      );
}
