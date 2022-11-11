part of 'destination_payment_bloc.dart';

@freezed
class DestinationPaymentState with _$DestinationPaymentState {
  const factory DestinationPaymentState({
    required bool isLoading,
    required PaymentType paymentType,
    required Order? order,
    required Option<Either<Failure, MidtransPayment>>
        successOnlineOrFailureOption,
    required Option<Either<Failure, Order>> successOnsiteOrFailureOption,
  }) = _DestinationPaymentState;
  factory DestinationPaymentState.initial() => DestinationPaymentState(
        isLoading: false,
        paymentType: PaymentType.onsite,
        order: null,
        successOnlineOrFailureOption: none(),
        successOnsiteOrFailureOption: none(),
      );
}
