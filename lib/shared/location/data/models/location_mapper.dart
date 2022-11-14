import 'package:geolocator/geolocator.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';

class LocationMapper {
  LocationMapper._();
  static Location toLocation(Position position, String? placemark) => Location(
        name: placemark ?? '',
        latitude: position.latitude,
        longitude: position.longitude,
        fetchOn: DateTime.now(),
      );
}
