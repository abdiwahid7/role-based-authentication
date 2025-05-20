import 'package:geolocator/geolocator.dart';

/// Service to handle location fetching with high accuracy.
class LocationService {
  /// Returns the current device location.
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}