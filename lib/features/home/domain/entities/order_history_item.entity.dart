import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'order_history_item.entity.freezed.dart';

@freezed
abstract class OrderHistoryItem with _$OrderHistoryItem {
  const factory OrderHistoryItem({
    required int id,
    required String type,
    required String name,
    required List<String> media,
    required UserOrder order,
  }) = _OrderHistoryItem;
}
