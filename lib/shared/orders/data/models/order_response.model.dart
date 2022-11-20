import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

part 'order_response.model.freezed.dart';
part 'order_response.model.g.dart';

@freezed
class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required String number,
    required String note,
    required int status,
    required DateTime orderDate,
    required double totalPrice,
    required List<OrderDetailResponse> orderDetails,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

extension OrderResponseX on OrderResponse {
  Order toDomain() => Order(
        number: number,
        note: note,
        status: OrderStatusMapper.fromResponse(status),
        orderDate: orderDate,
        totalPrice: totalPrice,
        orderDetails: orderDetails.map((e) => e.toDomain()).toList(),
      );
}

@freezed
class OrderDetailResponse with _$OrderDetailResponse {
  const factory OrderDetailResponse({
    required int id,
    required String orderableType,
    required int orderableId,
    required String orderableName,
    required double orderablePrice,
    required int quantity,
    required double subtotal,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderDetailResponse;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailResponseFromJson(json);
}

extension OrderDetailResponseX on OrderDetailResponse {
  OrderDetail toDomain() => OrderDetail(
        id: id,
        orderableType: orderableType,
        orderableId: orderableId,
        orderableName: orderableName,
        orderablePrice: orderablePrice,
        quantity: quantity,
        subtotal: subtotal,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
