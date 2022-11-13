part of 'package_order_bloc.dart';

@freezed
class PackageOrderEvent with _$PackageOrderEvent {
  const factory PackageOrderEvent.started() = _Started;
}