import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class PackageRepository {
  Future<Either<Failure, Paginable<Package>>> getPackages({
    required Category category,
    required int page,
  });
  Future<Either<Failure, PackageDetail>> getPackageDetail(String packageId);
}
