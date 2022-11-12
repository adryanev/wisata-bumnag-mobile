import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/shared/location/data/datasources/local/location_data_source.dart';
import 'package:wisatabumnag/shared/location/data/models/location_mapper.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';
import 'package:wisatabumnag/shared/location/domain/repositories/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this._dataSource);
  final LocationDataSource _dataSource;
  @override
  Future<Either<Failure, Location>> getCurrentLocation() async {
    final position = await _dataSource.getCurrentLocation();

    if (position.isLeft()) {
      return left(position.getLeft()!);
    }
    final placemark = await _dataSource
        .getCurrentPlaceName(position.toOption().toNullable()!);

    if (placemark.isLeft()) {
      return left(placemark.getLeft()!);
    }

    return right(
      LocationMapper.toLocation(position.getRight()!, placemark.getRight()),
    );
  }
}
