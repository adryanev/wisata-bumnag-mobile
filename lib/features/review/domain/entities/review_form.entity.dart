import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
part 'review_form.entity.freezed.dart';

@freezed
abstract class ReviewForm with _$ReviewForm {
  const factory ReviewForm({
    required String title,
    required String description,
    required int rating,
    required User user,
    required OrderDetail orderDetail,
    required List<File>? media,
  }) = _ReviewForm;
}
