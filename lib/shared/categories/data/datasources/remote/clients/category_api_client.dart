import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';

part 'category_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class CategoryApiClient {
  @factoryMethod
  factory CategoryApiClient(@Named(InjectionConstants.publicDio) Dio dio) =
      _CategoryApiClient;

  @GET('v1/categories/child')
  Future<BaseResponse<List<CategoryModel>>> getChildrenCategoryById(
    @Query('parent') int parent,
  );

  @GET('v1/categories/main')
  Future<BaseResponse<List<CategoryModel>>> getParentCategoies();
}
