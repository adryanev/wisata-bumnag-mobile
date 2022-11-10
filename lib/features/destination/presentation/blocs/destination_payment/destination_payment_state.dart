part of 'destination_payment_bloc.dart';

@freezed
class DestinationPaymentState with _$DestinationPaymentState {
  const factory DestinationPaymentState({
    required bool isLoading,
    required PaymentType paymentType,
    required Order? order,
  }) = _DestinationPaymentState;
  factory DestinationPaymentState.initial() => const DestinationPaymentState(
        isLoading: false,
        paymentType: PaymentType.onsite,
        order: null,
      );
}
