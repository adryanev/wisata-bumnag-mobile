import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/home/domain/entities/explore.entity.dart';
import 'package:wisatabumnag/features/home/domain/repositories/home_front_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@lazySingleton
class GetExplore extends UseCase<Paginable<Explore>, GetExploreParams> {
  const GetExplore(this._repository);

  final HomeFrontRepository _repository;
  @override
  Future<Either<Failure, Paginable<Explore>>> call(GetExploreParams params) =>
      _repository.getExplore(page: params.page);
}

@immutable
class GetExploreParams extends Equatable {
  const GetExploreParams({this.page = 1});

  final int page;
  @override
  List<Object?> get props => [page];
}
