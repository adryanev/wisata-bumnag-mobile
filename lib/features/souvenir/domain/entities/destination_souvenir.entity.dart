import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
part 'destination_souvenir.entity.freezed.dart';

@freezed
class DestinationSouvenir with _$DestinationSouvenir {
  const factory DestinationSouvenir({
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
    required List<Souvenir> souvenirs,
  }) = _DestinationSouvenir;
}
