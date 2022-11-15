import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/event/data/datasources/remote/client/event_api_client.dart';
import 'package:wisatabumnag/features/event/data/models/event_detail_response.model.dart';
import 'package:wisatabumnag/features/event/data/models/event_response.model.dart';

abstract class EventRemoteDataSource {
  Future<Either<Failure, BasePaginationResponse<List<EventResponse>>>>
      getEvents({
    required int page,
  });

  Future<Either<Failure, EventDetailResponse>> getEventDetail({
    required String eventId,
  });
}

@LazySingleton(as: EventRemoteDataSource)
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  const EventRemoteDataSourceImpl(this._provider, this._client);

  final MiddlewareProvider _provider;
  final EventApiClient _client;
  @override
  Future<Either<Failure, BasePaginationResponse<List<EventResponse>>>>
      getEvents({
    required int page,
  }) =>
          safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _client.getEvent(
              page: page,
            ),
          );

  @override
  Future<Either<Failure, EventDetailResponse>> getEventDetail({
    required String eventId,
  }) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () =>
            _client.getEventDetail(eventId).then((value) => value.data!),
      );
}
