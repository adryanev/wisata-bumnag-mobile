import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_pagination.entity.dart';

abstract class EventRepository {
  Future<Either<Failure, EventPagination>> getEvent({
    required int page,
  });
  Future<Either<Failure, EventDetail>> getEventDetail({
    required String eventId,
  });
}
