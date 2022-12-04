import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/notification/domain/repositories/notification_repository.dart';

@lazySingleton
class ReadAllNotification extends UseCase<Unit, NoParams> {
  const ReadAllNotification(this._repository);

  final NotificationRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(NoParams params) => _repository.readAll();
}
