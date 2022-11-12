import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_pagination.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

abstract class PackageRepository {
  Future<Either<Failure, PackagePagination>> getPackages({
    required Category category,
    required int page,
  });
  Future<Either<Failure, Package>> getPackageDetail(String packageId);
}
