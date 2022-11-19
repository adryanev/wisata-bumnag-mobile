import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';
part 'orderable_model.model.freezed.dart';
part 'orderable_model.model.g.dart';

@freezed
class OrderableModel with _$OrderableModel {
  const factory OrderableModel({
    required String type,
    required int id,
    required String name,
    required double price,
    required int quantity,
    required String? media,
    required double subtotal,
  }) = _OrderableModel;

  factory OrderableModel.fromJson(Map<String, dynamic> json) =>
      _$OrderableModelFromJson(json);
}

extension OrderableModelX on OrderableModel {
  Orderable toDomain() => Orderable(
        type: OrderableTypeMapper.toOrderableType(type),
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        media: media,
        subtotal: subtotal,
      );
}
