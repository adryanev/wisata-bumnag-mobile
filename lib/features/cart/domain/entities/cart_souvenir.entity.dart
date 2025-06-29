import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
part 'cart_souvenir.entity.freezed.dart';

@freezed
abstract class CartSouvenir with _$CartSouvenir {
  const factory CartSouvenir({
    required int destinationId,
    required String destinationName,
    required String? destinationAddress,
    required List<Orderable> items,
  }) = _CartSouvenir;
}
