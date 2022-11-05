import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/repositories/souvenir_repository.dart';

@lazySingleton
class GetSouvenirByDestination
    extends UseCase<List<Souvenir>, GetSouvenirByDestinationParams> {
  const GetSouvenirByDestination(this._repo);
  final SouvenirRepository _repo;
  @override
  Future<Either<Failure, List<Souvenir>>> call(
          GetSouvenirByDestinationParams params) =>
      _repo.getSouvenirByDestination(
        params.destinationId,
      );
}

class GetSouvenirByDestinationParams extends Equatable {
  const GetSouvenirByDestinationParams({
    required this.destinationId,
  });

  final String destinationId;
  @override
  List<Object?> get props => [destinationId];
}
