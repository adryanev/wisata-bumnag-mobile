import 'package:freezed_annotation/freezed_annotation.dart';
part 'notification.entity.freezed.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String type,
    required NotificationData data,
    required bool isRead,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Notification;
}

@freezed
abstract class NotificationData with _$NotificationData {
  const factory NotificationData({
    required int id,
    required String body,
    required String title,
    required String type,
    required String? action,
  }) = _NotificationData;
}
