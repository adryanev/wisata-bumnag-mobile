import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/destination/data/datasources/remote/client/destination_api_client.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_detail_response.model.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_response.model.dart';

abstract class DestinationRemoteDataSource {
  Future<Either<Failure, BasePaginationResponse<List<DestinationResponse>>>>
      getDestination({
    required int categoryId,
    required int page,
  });
  Future<Either<Failure, DestinationDetailResponse>> getDestinationDetail({
    required String destinationId,
  });
}

@LazySingleton(as: DestinationRemoteDataSource)
class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  const DestinationRemoteDataSourceImpl(this._client, this._provider);
  final DestinationApiClient _client;
  final MiddlewareProvider _provider;
  @override
  Future<Either<Failure, BasePaginationResponse<List<DestinationResponse>>>>
      getDestination({required int categoryId, required int page}) =>
          safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _client.getDestination(categoryId, page),
          );

  @override
  Future<Either<Failure, DestinationDetailResponse>> getDestinationDetail({
    required String destinationId,
  }) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client
            .getDestinationDetail(destinationId)
            .then((value) => value.data!),
      );
}
