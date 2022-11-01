import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/domain/repositories/destination_repository.dart';

@lazySingleton
class GetDestinationDetail
    extends UseCase<DestinationDetail, GetDestinationDetailParams> {
  const GetDestinationDetail(this._repository);
  final DestinationRepository _repository;
  @override
  Future<Either<Failure, DestinationDetail>> call(
    GetDestinationDetailParams params,
  ) =>
      _repository.getDestinationDetail(destinationId: params.destinationId);
}

class GetDestinationDetailParams extends Equatable {
  const GetDestinationDetailParams({
    required this.destinationId,
  });
  final String destinationId;

  @override
  List<Object?> get props => [];
}
