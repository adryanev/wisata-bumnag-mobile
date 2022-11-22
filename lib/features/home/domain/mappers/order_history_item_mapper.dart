import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

class OrderHistoryItemMapper {
  const OrderHistoryItemMapper._();

  static List<OrderHistoryItem> mapFromOrderList(List<Order> orders) {
    final tempOrders = [...orders];

    final result = tempOrders
        .map(
          (order) => OrderHistoryItem(
            id: order.orderDetails.first.orderableDetail.id,
            type: order.orderDetails.first.orderableDetail.type,
            name: order.orderDetails.first.orderableDetail.name,
            media: order.orderDetails.first.orderableDetail.media,
            order: order,
          ),
        )
        .toList();
    return result;
  }

  static OrderHistoryItem mapFromOrder(Order order) {
    final result = OrderHistoryItem(
      id: order.orderDetails.first.orderableDetail.id,
      type: order.orderDetails.first.orderableDetail.type,
      name: order.orderDetails.first.orderableDetail.name,
      media: order.orderDetails.first.orderableDetail.media,
      order: order,
    );
    return result;
  }
}
