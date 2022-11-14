import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';

abstract class LocationService {
  Future<Position?> getCurrentLocation();
  Future<bool> checkPermission();
  Future<bool> isLocationServiceEnable();
  Future<String?> getCurrentPlaceName(Position position);
}

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  const LocationServiceImpl(this._preference);
  final LocalStorage _preference;

  @override
  Future<bool> checkPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        '''
Location permissions are permanently denied, we cannot request permissions.
''',
      );
    }
    return true;
  }

  @override
  Future<Position?> getCurrentLocation() async {
    try {
      final isEnabled = await isLocationServiceEnable();
      final allowed = await checkPermission();
      if (isEnabled && allowed) {
        final position = await Geolocator.getCurrentPosition();
        return position;
      }
      return null;
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      return null;
    }
  }

  @override
  Future<String?> getCurrentPlaceName(Position position) async {
    try {
      final apiKey = await _preference.getMapApiKey();
      final geocoder = GoogleGeocodingApi(apiKey!);
      final data = await geocoder.reverse(
        '${position.latitude},${position.longitude}',
        resultType: 'administrative_area_level_2|administrative_area_level_1',
        language: 'id',
      );

      return data.results.firstOrNull?.addressComponents
          .map((e) => e.longName)
          .toList()
          .join(', ');
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      return null;
    }
  }

  @override
  Future<bool> isLocationServiceEnable() async {
    // Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    return true;
  }
}
