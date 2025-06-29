import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.entity.freezed.dart';

@freezed
abstract class UserOrder with _$UserOrder {
  const factory UserOrder({
    required String number,
    required String note,
    required OrderStatus status,
    required DateTime orderDate,
    required double totalPrice,
    required String? qrCode,
    required PaymentType? paymentType,
    required List<OrderDetail> orderDetails,
  }) = _UserOrder;
}

@freezed
abstract class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required int id,
    required String orderableType,
    required int orderableId,
    required String orderableName,
    required double orderablePrice,
    required int quantity,
    required double subtotal,
    required DateTime createdAt,
    required DateTime updatedAt,
    required OrderableDetail orderableDetail,
  }) = _OrderDetail;
}

@freezed
abstract class OrderableDetail with _$OrderableDetail {
  const factory OrderableDetail({
    required int id,
    required String name,
    required String type,
    required List<String> media,
  }) = _OrderableDetail;
}

enum PaymentType { online }

enum OrderStatus {
  created,
  paid,
  cancelled,
  completed,
  refunded,
}
