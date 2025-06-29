import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable_mapper.dart';

part 'order_response.model.freezed.dart';
part 'order_response.model.g.dart';

@freezed
abstract class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required String number,
    required String note,
    required int status,
    required DateTime orderDate,
    required double totalPrice,
    required String? qrCode,
    required String? paymentType,
    required List<OrderDetailResponse> orderDetails,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

extension OrderResponseX on OrderResponse {
  UserOrder toDomain() => UserOrder(
        number: number,
        note: note,
        status: OrderStatusMapper.fromResponse(status),
        orderDate: orderDate,
        totalPrice: totalPrice,
        qrCode: qrCode,
        paymentType: paymentType == null
            ? null
            : PaymentTypeMapper.toPaymentType(paymentType!),
        orderDetails: orderDetails.map((e) => e.toDomain()).toList(),
      );
}

@freezed
abstract class OrderDetailResponse with _$OrderDetailResponse {
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
    required OrderableDetailResponse orderableDetail,
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
        orderableDetail: orderableDetail.toDomain(),
      );
}

@freezed
abstract class OrderableDetailResponse with _$OrderableDetailResponse {
  const factory OrderableDetailResponse({
    required int id,
    required String name,
    required String type,
    required List<String> media,
  }) = _OrderableDetailResponse;

  factory OrderableDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderableDetailResponseFromJson(json);
}

extension OrderableDetailResponseX on OrderableDetailResponse {
  OrderableDetail toDomain() =>
      OrderableDetail(id: id, name: name, type: type, media: media);
}
