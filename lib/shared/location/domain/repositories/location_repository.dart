import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, Location>> getCurrentLocation();
}
