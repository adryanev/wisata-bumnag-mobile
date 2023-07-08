import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/categories/data/datasources/remote/category_remote_data_source.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/repositories/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remoteDataSource);

  // final CategoryLocalDataSource _localDataSource;
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
  Future<Either<Failure, List<Category>>> getMainCategory() async =>
      _remoteDataSource.getParentCategories().then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );
}
