import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/packages/data/models/package_detail_response.model.dart';
import 'package:wisatabumnag/features/packages/data/models/package_response.model.dart';

part 'packages_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class PackagesApiClient {
  @factoryMethod
  factory PackagesApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _PackagesApiClient;

  @GET('v1/packages')
  Future<BasePaginationResponse<List<PackageResponse>>> getPackages(
    @Query('category') int categoryId,
    @Query('page') int page,
  );

  @GET('v1/packages/{id}')
  Future<BaseResponse<PackageDetailResponse>> getPackageDetail(
    @Path('id') String packageId,
  );
}
