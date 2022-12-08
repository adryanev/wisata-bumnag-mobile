import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';

part 'notification_response.model.freezed.dart';
part 'notification_response.model.g.dart';

@freezed
class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required String id,
    required String type,
    required NotificationDataResponse data,
    required bool isRead,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

extension NotificationResponseX on NotificationResponse {
  Notification toDomain() => Notification(
        id: id,
        type: type,
        data: data.toDomain(),
        isRead: isRead,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

@freezed
class NotificationDataResponse with _$NotificationDataResponse {
  const factory NotificationDataResponse({
    @JsonKey(name: 'object_id') required int id,
    required String body,
    required String title,
    @JsonKey(name: 'object_type') required String type,
    required String? action,
  }) = _NotificationDataResponse;

  factory NotificationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataResponseFromJson(json);
}

extension NotificationDataResponseX on NotificationDataResponse {
  NotificationData toDomain() => NotificationData(
        id: id,
        body: body,
        title: title,
        type: type,
        action: action,
      );
}
