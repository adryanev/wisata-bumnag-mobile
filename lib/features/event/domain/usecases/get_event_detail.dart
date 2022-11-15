import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/features/event/domain/repositories/event_repository.dart';

@lazySingleton
class GetEventDetail extends UseCase<EventDetail, GetEventDetailParams> {
  const GetEventDetail(this._repository);
  final EventRepository _repository;
  @override
  Future<Either<Failure, EventDetail>> call(
    GetEventDetailParams params,
  ) =>
      _repository.getEventDetail(eventId: params.eventId);
}

class GetEventDetailParams extends Equatable {
  const GetEventDetailParams({
    required this.eventId,
  });
  final String eventId;

  @override
  List<Object?> get props => [];
}
