import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/features/packages/domain/repositories/package_repository.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@lazySingleton
class GetPackages extends UseCase<Paginable<Package>, GetPackagesParams> {
  const GetPackages(this._repository);

  final PackageRepository _repository;
  @override
  Future<Either<Failure, Paginable<Package>>> call(GetPackagesParams params) =>
      _repository.getPackages(category: params.category, page: params.page);
}

@immutable
class GetPackagesParams extends Equatable {
  const GetPackagesParams({
    required this.category,
    this.page = 1,
  });

  final Category category;
  final int page;

  @override
  List<Object?> get props => [
        category,
        page,
      ];
}
