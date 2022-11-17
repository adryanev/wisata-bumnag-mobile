import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
part 'destination_souvenir.entity.freezed.dart';

@freezed
class DestinationSouvenir with _$DestinationSouvenir {
  const factory DestinationSouvenir({
    required int id,
    required String name,
    required List<Souvenir> souvenirs,
  }) = _DestinationSouvenir;
}
