import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';
import 'package:wisatabumnag/shared/location/domain/repositories/location_repository.dart';

@injectable
class GetCurrentLocation extends UseCase<Location, NoParams> {
  const GetCurrentLocation(this._repository);
  final LocationRepository _repository;
  @override
  Future<Either<Failure, Location>> call(NoParams params) {
    return _repository.getCurrentLocation();
  }
}
