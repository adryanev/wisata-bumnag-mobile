import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';

abstract class SouvenirRepository {
  Future<Either<Failure, List<Souvenir>>> getSouvenirByDestination(String id);
}
