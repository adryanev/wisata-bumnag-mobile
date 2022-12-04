import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/features/notification/domain/repositories/notification_repository.dart';

@lazySingleton
class GetNotifications extends UseCase<List<Notification>, NoParams> {
  const GetNotifications(this._repository);
  final NotificationRepository _repository;
  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) =>
      _repository.getNotification();
}
