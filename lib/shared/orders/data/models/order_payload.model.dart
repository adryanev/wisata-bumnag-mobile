import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order_form.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

part 'order_payload.model.freezed.dart';
part 'order_payload.model.g.dart';

@freezed
abstract class OrderPayload with _$OrderPayload {
  const factory OrderPayload({
    required double totalPrice,
    required String orderDate,
    required List<OrderablePayload> orderDetails,
  }) = _OrderPayload;

  factory OrderPayload.fromJson(Map<String, dynamic> json) =>
      _$OrderPayloadFromJson(json);
  factory OrderPayload.fromDomain(OrderForm form) => OrderPayload(
        totalPrice: form.totalPrice,
        orderDate: form.orderDate.toIso8601String(),
        orderDetails:
            form.orderDetails.map(OrderablePayload.fromDomain).toList(),
      );
}

@freezed
abstract class OrderablePayload with _$OrderablePayload {
  const factory OrderablePayload({
    @JsonKey(name: 'orderable_type') required String type,
    @JsonKey(name: 'orderable_id') required int id,
    @JsonKey(name: 'orderable_name') required String name,
    @JsonKey(name: 'orderable_price') required double price,
    required int quantity,
    required double subtotal,
  }) = _OrderablePayload;

  factory OrderablePayload.fromJson(Map<String, dynamic> json) =>
      _$OrderablePayloadFromJson(json);

  factory OrderablePayload.fromDomain(Orderable form) => OrderablePayload(
        type: OrderableTypeMapper.toStringType(form.type),
        id: form.id,
        name: form.name,
        price: form.price,
        quantity: form.quantity,
        subtotal: form.subtotal,
      );
}
