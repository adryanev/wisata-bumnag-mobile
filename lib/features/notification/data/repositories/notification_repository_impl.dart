import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/notification/data/datasources/remote/notification_remote_data_source.dart';
import 'package:wisatabumnag/features/notification/data/models/notification_response.model.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/features/notification/domain/repositories/notification_repository.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remoteDataSource);
  final NotificationRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, Unit>> delete() {
    return _remoteDataSource.delete();
  }

  @override
  Future<Either<Failure, List<Notification>>> getNotification() =>
      _remoteDataSource.getNotifications().then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );

  @override
  Future<Either<Failure, Paginable<Notification>>> notificationPagination({
    required int page,
  }) =>
      _remoteDataSource.getNotificationPagination(page: page).then(
            (value) => value.map(
              (r) => Paginable(
                data: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );

  @override
  Future<Either<Failure, Unit>> read(String id) => _remoteDataSource.read(id);

  @override
  Future<Either<Failure, Unit>> readAll() => _remoteDataSource.readAll();
}
