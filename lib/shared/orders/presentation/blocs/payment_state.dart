part of 'payment_bloc.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState({
    required bool isLoading,
    required PaymentType paymentType,
    required Order? order,
    required Option<Either<Failure, MidtransPayment>>
        successOnlineOrFailureOption,
  }) = _PaymentState;
  factory PaymentState.initial() => PaymentState(
        isLoading: false,
        paymentType: PaymentType.online,
        order: null,
        successOnlineOrFailureOption: none(),
      );
}
