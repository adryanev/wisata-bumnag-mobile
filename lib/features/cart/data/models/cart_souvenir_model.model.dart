import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/data/models/orderable_model.model.dart';
part 'cart_souvenir_model.model.freezed.dart';
part 'cart_souvenir_model.model.g.dart';

@freezed
class CartSouvenirModel with _$CartSouvenirModel {
  const factory CartSouvenirModel({
    required int destinationId,
    required String destinationName,
    required String? destinationAddress,
    required List<OrderableModel> items,
  }) = _CartSouvenirModel;

  factory CartSouvenirModel.fromJson(Map<String, dynamic> json) =>
      _$CartSouvenirModelFromJson(json);
}
