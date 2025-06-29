import 'package:freezed_annotation/freezed_annotation.dart';
part 'location.entity.freezed.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({
    required String name,
    required double latitude,
    required double longitude,
    required DateTime fetchOn,
  }) = _Location;
}
