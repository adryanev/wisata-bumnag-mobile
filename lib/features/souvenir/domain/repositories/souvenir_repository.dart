import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class SouvenirRepository {
  Future<Either<Failure, List<Souvenir>>> getSouvenirByDestination(String id);
  Future<Either<Failure, Paginable<DestinationSouvenir>>> getSouvenirs({
    required int page,
  });
  Future<Either<Failure, SouvenirDetail>> getSouvenirDetail({
    required int souvenirId,
  });
}
