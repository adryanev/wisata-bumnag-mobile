import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/features/event/domain/repositories/event_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@injectable
class GetEvent extends UseCase<Paginable<Event>, GetEventParams> {
  const GetEvent(this._repository);
  final EventRepository _repository;

  @override
  Future<Either<Failure, Paginable<Event>>> call(
    GetEventParams params,
  ) =>
      _repository.getEvent(page: params.page);
}

class GetEventParams extends Equatable {
  const GetEventParams({
    this.page = 1,
  });
  final int page;
  @override
  List<Object?> get props => [page];
}
