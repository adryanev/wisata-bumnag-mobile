import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/repositories/souvenir_repository.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@lazySingleton
class GetSouvenirs
    extends UseCase<Paginable<DestinationSouvenir>, GetSouvenirsParams> {
  const GetSouvenirs(this._repo);
  final SouvenirRepository _repo;
  @override
  Future<Either<Failure, Paginable<DestinationSouvenir>>> call(
    GetSouvenirsParams params,
  ) =>
      _repo.getSouvenirs(
        page: params.page,
      );
}

class GetSouvenirsParams extends Equatable {
  const GetSouvenirsParams({
    this.page = 1,
  });

  final int page;
  @override
  List<Object?> get props => [page];
}
