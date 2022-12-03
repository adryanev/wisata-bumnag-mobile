import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/features/notification/domain/repositories/notification_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@lazySingleton
class GetNotificationPagination
    extends UseCase<Paginable<Notification>, GetNotificationPaginationParams> {
  const GetNotificationPagination(this._repository);
  final NotificationRepository _repository;
  @override
  Future<Either<Failure, Paginable<Notification>>> call(
    GetNotificationPaginationParams params,
  ) =>
      _repository.notificationPagination(page: params.page);
}

class GetNotificationPaginationParams extends Equatable {
  const GetNotificationPaginationParams({
    this.page = 1,
  });

  final int page;
  @override
  List<Object?> get props => [page];
}
