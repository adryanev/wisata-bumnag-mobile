import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/review/domain/entities/review_form.entity.dart';
part 'review_payload.model.freezed.dart';

@freezed
abstract class ReviewPayload with _$ReviewPayload {
  const factory ReviewPayload({
    required String title,
    required String description,
    required int rating,
    required int userId,
    required int orderDetailId,
    required String orderableType,
    required int reviewableId,
    required List<File>? media,
  }) = _ReviewPayload;

  factory ReviewPayload.fromDomain(ReviewForm form) => ReviewPayload(
        title: form.title,
        description: form.description,
        rating: form.rating,
        userId: form.user.id,
        orderDetailId: form.orderDetail.id,
        orderableType: form.orderDetail.orderableType,
        reviewableId: form.orderDetail.orderableId,
        media: form.media,
      );
}
