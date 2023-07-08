import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/shared/categories/data/datasources/remote/clients/category_api_client.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';

abstract class CategoryRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> getParentCategories();
  Future<Either<Failure, List<CategoryModel>>> getChildrenCategoryOf(
    CategoryModel model,
  );
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  const CategoryRemoteDataSourceImpl(this._client, this._middlewareProvider);
  final CategoryApiClient _client;
  final MiddlewareProvider _middlewareProvider;

  @override
  Future<Either<Failure, List<CategoryModel>>> getChildrenCategoryOf(
    CategoryModel model,
  ) =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () => _client
            .getChildrenCategoryById(model.id)
            .then((value) => value.data!),
      );

  @override
  Future<Either<Failure, List<CategoryModel>>> getParentCategories() =>
      safeRemoteCall(
        middlewares: _middlewareProvider.getAll(),
        retrofitCall: () => _client.getParentCategoies().then(
              (value) => value.data!,
            ),
      );
}
