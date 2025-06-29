import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/midtrans_payment.entity.dart';
part 'midtrans_payment_response.model.freezed.dart';
part 'midtrans_payment_response.model.g.dart';

@freezed
abstract class MidtransPaymentResponse with _$MidtransPaymentResponse {
  const factory MidtransPaymentResponse({
    required String token,
    required String url,
  }) = _MidtransPaymentResponse;

  factory MidtransPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$MidtransPaymentResponseFromJson(json);
}

extension MidtransPaymentResponseX on MidtransPaymentResponse {
  MidtransPayment toDomain() => MidtransPayment(token: token, url: url);
}
