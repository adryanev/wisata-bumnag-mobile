import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/repositories/souvenir_repository.dart';

@lazySingleton
class GetSouvenirDetail
    extends UseCase<SouvenirDetail, GetSouvenirDetailParams> {
  const GetSouvenirDetail(this._repository);

  final SouvenirRepository _repository;
  @override
  Future<Either<Failure, SouvenirDetail>> call(
    GetSouvenirDetailParams params,
  ) =>
      _repository.getSouvenirDetail(souvenirId: params.souvenirId);
}

class GetSouvenirDetailParams extends Equatable {
  const GetSouvenirDetailParams(this.souvenirId);

  final int souvenirId;
  @override
  List<Object?> get props => [souvenirId];
}
