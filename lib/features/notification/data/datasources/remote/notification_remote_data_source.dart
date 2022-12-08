import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/notification/data/datasources/remote/client/notification_api_client.dart';
import 'package:wisatabumnag/features/notification/data/models/notification_response.model.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<Failure, List<NotificationResponse>>> getNotifications();
  Future<Either<Failure, BasePaginationResponse<List<NotificationResponse>>>>
      getNotificationPagination({
    required int page,
  });

  Future<Either<Failure, Unit>> read(String id);
  Future<Either<Failure, Unit>> readAll();
  Future<Either<Failure, Unit>> delete();
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl(this._apiClient, this._provider);
  final NotificationApiClient _apiClient;
  final MiddlewareProvider _provider;
  @override
  Future<Either<Failure, Unit>> delete() => safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.delete().then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, BasePaginationResponse<List<NotificationResponse>>>>
      getNotificationPagination({required int page}) => safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _apiClient.withPagination(
              page: page,
            ),
          );

  @override
  Future<Either<Failure, List<NotificationResponse>>> getNotifications() =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.getNotification().then(
              (value) => value.data!,
            ),
      );

  @override
  Future<Either<Failure, Unit>> read(String id) => safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.read(id).then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, Unit>> readAll() => safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.readAll().then((value) => unit),
      );
}
