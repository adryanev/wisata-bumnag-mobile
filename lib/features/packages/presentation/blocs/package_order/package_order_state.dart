part of 'package_order_bloc.dart';

@freezed
abstract class PackageOrderState with _$PackageOrderState {
  const factory PackageOrderState({
    required bool isLoading,
    required List<Ticketable> tickets,
    required List<Amenity> amenities,
    required PackageDetail? packageDetail,
    required List<Orderable> cart,
    required DateTime orderForDate,
    required bool isSubmitting,
    required Option<Either<Failure, UserOrder>> createOrderOfFailureOption,
  }) = _PackageOrderState;
  factory PackageOrderState.initial() => PackageOrderState(
        isLoading: false,
        tickets: [],
        amenities: [],
        packageDetail: null,
        cart: [],
        orderForDate: DateTime.now(),
        isSubmitting: false,
        createOrderOfFailureOption: none(),
      );
}
