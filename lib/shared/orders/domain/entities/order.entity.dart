import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.entity.freezed.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String number,
    required String note,
    required int status,
    required DateTime orderDate,
    required double totalPrice,
    required List<OrderDetail> orderDetails,
  }) = _Order;
}

@freezed
class OrderDetail with _$OrderDetail {
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
  }) = _OrderDetail;
}

enum PaymentType { onsite, online }
