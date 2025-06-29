import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/shared/orders/data/models/orderable_model.model.dart';
part 'cart_souvenir_model.model.freezed.dart';
part 'cart_souvenir_model.model.g.dart';

@freezed
abstract class CartSouvenirModel with _$CartSouvenirModel {
  const factory CartSouvenirModel({
    required int destinationId,
    required String destinationName,
    required String? destinationAddress,
    required List<OrderableModel> items,
  }) = _CartSouvenirModel;

  factory CartSouvenirModel.fromJson(Map<String, dynamic> json) =>
      _$CartSouvenirModelFromJson(json);

  factory CartSouvenirModel.fromDomain(CartSouvenir form) => CartSouvenirModel(
        destinationId: form.destinationId,
        destinationName: form.destinationName,
        destinationAddress: form.destinationAddress,
        items: form.items.map(OrderableModel.fromDomain).toList(),
      );
}

extension CartSouvenirModelX on CartSouvenirModel {
  CartSouvenir toDomain() => CartSouvenir(
        destinationId: destinationId,
        destinationName: destinationName,
        destinationAddress: destinationAddress,
        items: items.map((e) => e.toDomain()).toList(),
      );
}
