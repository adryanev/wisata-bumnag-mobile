import 'package:freezed_annotation/freezed_annotation.dart';
part 'amenity.entity.freezed.dart';

@freezed
class Amenity with _$Amenity {
  const factory Amenity({
    required int id,
    required int packageId,
    required String name,
    required String description,
    required double price,
    required int quantity,
  }) = _Amenity;
}
