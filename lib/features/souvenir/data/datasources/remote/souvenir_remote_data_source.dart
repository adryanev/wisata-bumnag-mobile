import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/souvenir/data/datasources/remote/client/souvenir_api_client.dart';
import 'package:wisatabumnag/features/souvenir/data/models/destination_souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';

abstract class SouvenirRemoteDataSource {
  Future<Either<Failure, List<SouvenirResponse>>> getSouvenirByDestination(
    String id,
  );
  Future<
          Either<Failure,
              BasePaginationResponse<List<DestinationSouvenirResponse>>>>
      getSouvenirs({
    required int page,
  });
}

@LazySingleton(as: SouvenirRemoteDataSource)
class SouvenirRemoteDataSourceImpl implements SouvenirRemoteDataSource {
  const SouvenirRemoteDataSourceImpl(
    this._client,
    this._middlewareProvider,
  );
  final SouvenirApiClient _client;
  final MiddlewareProvider _middlewareProvider;
  @override
  Future<Either<Failure, List<SouvenirResponse>>> getSouvenirByDestination(
    String id,
  ) =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () =>
            _client.getSouvenirByDestination(id).then((value) => value.data!),
      );

  @override
  Future<
          Either<Failure,
              BasePaginationResponse<List<DestinationSouvenirResponse>>>>
      getSouvenirs({required int page}) => safeRemoteCall(
            middlewares: _middlewareProvider.getAll(),
            retrofitCall: () => _client.getSouvenirLists(page: page),
          );
}
