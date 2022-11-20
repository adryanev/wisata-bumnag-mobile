import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class EventRepository {
  Future<Either<Failure, Paginable<Event>>> getEvent({
    required int page,
  });
  Future<Either<Failure, EventDetail>> getEventDetail({
    required String eventId,
  });
}
