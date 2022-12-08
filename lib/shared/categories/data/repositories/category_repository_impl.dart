import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/categories/data/datasources/local/category_local_data_source.dart';
import 'package:wisatabumnag/shared/categories/data/datasources/remote/category_remote_data_source.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/repositories/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final CategoryLocalDataSource _localDataSource;
  final CategoryRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, List<Category>>> getCategoryByParent(
    Category category,
  ) =>
      _remoteDataSource
          .getChildrenCategoryOf(CategoryModel.fromDomain(category))
          .then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );

  @override
  Future<Either<Failure, List<Category>>> getMainCategory() async => right(
        _localDataSource.getRootCategory().map((e) => e.toDomain()).toList(),
      );

  @override
  Future<Either<Failure, Category>> getMainCategoryByType(
    MainCategoryType type,
  ) async {
    final result = _localDataSource.getRootCategoryByName(type.toStringName());
    if (result == null) {
      return left(
        const Failure.localFailure(message: 'error fetching category'),
      );
    }
    return right(result.toDomain());
  }
}
