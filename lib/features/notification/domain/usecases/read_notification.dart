import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/notification/domain/repositories/notification_repository.dart';

@lazySingleton
class ReadNotification extends UseCase<Unit, ReadNotificationParams> {
  const ReadNotification(this._repository);

  final NotificationRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(ReadNotificationParams params) =>
      _repository.read(params.id);
}

class ReadNotificationParams extends Equatable {
  const ReadNotificationParams({required this.id});

  final String id;
  @override
  List<Object?> get props => [id];
}
