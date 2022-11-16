part of 'order_list_bloc.dart';

@freezed
class OrderListEvent with _$OrderListEvent {
  const factory OrderListEvent.started() = _OrderListStarted;
}
