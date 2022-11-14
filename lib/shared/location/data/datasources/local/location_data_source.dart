import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/services/location/location_service.dart';

abstract class LocationDataSource {
  Future<Either<Failure, Position>> getCurrentLocation();
  Future<Either<Failure, String?>> getCurrentPlaceName(Position position);
}

@LazySingleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  const LocationDataSourceImpl(this._service);
  final LocationService _service;
  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    final result = await _service.getCurrentLocation();
    if (result == null) {
      return left(
        const Failure.locationFailure(
          message: 'Cannot fetch your location',
        ),
      );
    }
    return right(result);
  }

  @override
  Future<Either<Failure, String?>> getCurrentPlaceName(
    Position position,
  ) async {
    final location = await _service.getCurrentPlaceName(position);
    if (location == null) {
      const Failure.locationFailure(
        message: 'Cannot decode your current location',
      );
    }
    return right(location);
  }
}
