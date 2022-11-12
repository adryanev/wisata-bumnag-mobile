import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/packages/data/datasources/remote/package_remote_data_source.dart';
import 'package:wisatabumnag/features/packages/data/models/package_response.model.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_pagination.entity.dart';
import 'package:wisatabumnag/features/packages/domain/repositories/package_repository.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';

@LazySingleton(as: PackageRepository)
class PackageRepositoryImpl implements PackageRepository {
  const PackageRepositoryImpl(this._remoteDataSource);

  final PackageRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, Package>> getPackageDetail(String packageId) =>
      _remoteDataSource
          .getDetail(packageId: packageId)
          .then((value) => value.map((r) => r.toDomain()));

  @override
  Future<Either<Failure, PackagePagination>> getPackages({
    required Category category,
    required int page,
  }) =>
      _remoteDataSource.getPackages(categoryId: category.id, page: page).then(
            (value) => value.map(
              (r) => PackagePagination(
                packages: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );
}
