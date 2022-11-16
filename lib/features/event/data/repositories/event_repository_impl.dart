import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/event/data/datasources/remote/event_remote_data_source.dart';
import 'package:wisatabumnag/features/event/data/models/event_detail_response.model.dart';
import 'package:wisatabumnag/features/event/data/models/event_response.model.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_detail.entity.dart';
import 'package:wisatabumnag/features/event/domain/entities/event_pagination.entity.dart';
import 'package:wisatabumnag/features/event/domain/repositories/event_repository.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';

@LazySingleton(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  const EventRepositoryImpl(this._remoteSource);

  final EventRemoteDataSource _remoteSource;
  @override
  Future<Either<Failure, EventPagination>> getEvent({required int page}) =>
      _remoteSource.getEvents(page: page).then(
            (value) => value.map(
              (r) => EventPagination(
                events: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );

  @override
  Future<Either<Failure, EventDetail>> getEventDetail({
    required String eventId,
  }) =>
      _remoteSource.getEventDetail(eventId: eventId).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );
}
