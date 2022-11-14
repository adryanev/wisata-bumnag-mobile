import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package_detail.entity.dart';
import 'package:wisatabumnag/features/packages/domain/repositories/package_repository.dart';

@lazySingleton
class GetPackageDetail extends UseCase<PackageDetail, GetPackageDetailParams> {
  const GetPackageDetail(this._repository);

  final PackageRepository _repository;
  @override
  Future<Either<Failure, PackageDetail>> call(GetPackageDetailParams params) =>
      _repository.getPackageDetail(
        params.packageId,
      );
}

@immutable
class GetPackageDetailParams extends Equatable {
  const GetPackageDetailParams({required this.packageId});

  final String packageId;

  @override
  List<Object?> get props => [packageId];
}
