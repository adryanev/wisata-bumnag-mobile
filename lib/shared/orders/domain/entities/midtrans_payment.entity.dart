import 'package:freezed_annotation/freezed_annotation.dart';

part 'midtrans_payment.entity.freezed.dart';

@freezed
abstract class MidtransPayment with _$MidtransPayment {
  const factory MidtransPayment({
    required String token,
    required String url,
  }) = _MidtransPayment;
}
