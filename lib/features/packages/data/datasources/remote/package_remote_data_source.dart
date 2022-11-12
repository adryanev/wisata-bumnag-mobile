import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/features/packages/data/datasources/remote/client/packages_api_client.dart';
import 'package:wisatabumnag/features/packages/data/models/package_response.model.dart';

abstract class PackageRemoteDataSource {
  Future<Either<Failure, BasePaginationResponse<List<PackageResponse>>>>
      getPackages({
    required int categoryId,
    required int page,
  });
  Future<Either<Failure, PackageResponse>> getDetail({
    required String packageId,
  });
}

@LazySingleton(as: PackageRemoteDataSource)
class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  const PackageRemoteDataSourceImpl(this._client, this._provider);
  final PackagesApiClient _client;
  final MiddlewareProvider _provider;
  @override
  Future<Either<Failure, PackageResponse>> getDetail({
    required String packageId,
  }) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _client.getPackageDetail(packageId).then(
              (value) => value.data!,
            ),
      );

  @override
  Future<Either<Failure, BasePaginationResponse<List<PackageResponse>>>>
      getPackages({required int categoryId, required int page}) =>
          safeRemoteCall(
            middlewares: _provider.getAll(),
            retrofitCall: () => _client.getPackages(categoryId, page),
          );
}
