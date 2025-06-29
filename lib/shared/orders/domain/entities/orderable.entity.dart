import 'package:freezed_annotation/freezed_annotation.dart';
part 'orderable.entity.freezed.dart';

@freezed
abstract class Orderable with _$Orderable {
  const factory Orderable({
    required OrderableType type,
    required int id,
    required String name,
    required double price,
    required int quantity,
    required String? media,
    required double subtotal,
  }) = _Orderable;
}

enum OrderableType { ticket, souvenir, amenity }
