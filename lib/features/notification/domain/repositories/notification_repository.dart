import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotification();
  Future<Either<Failure, Paginable<Notification>>> notificationPagination({
    required int page,
  });
  Future<Either<Failure, Unit>> read(String id);
  Future<Either<Failure, Unit>> readAll();
  Future<Either<Failure, Unit>> delete();
}
