import 'dart:async';
import 'dart:developer' as developer;

import 'package:geolocator/geolocator.dart';

class UserLocation {
  static final UserLocation _instance = UserLocation._internal();
  factory UserLocation() => _instance;

  UserLocation._internal();

  Position? _currentPosition;

  Future<void> onLocationDisabledDefault() async {
    return;
  }

  Future<Position?> getCurrentLocation(
    Future<void> Function() onLocationDisabled,
  ) async {
    _currentPosition ??= await _determinePosition(
      onLocationDisabled = onLocationDisabledDefault,
    );
    return _currentPosition;
  }

  Future<Position?> _determinePosition(
    Future<void> Function() onLocationDisabled,
  ) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        developer.debugger(
          when: false,
          message:
              "Location permission denied. Status: ${permission.toString()}",
        );

        await onLocationDisabled();
        return null;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      developer.debugger(
        message: "Could not get location: ${e.toString()}",
      );
      return null;
    }
  }
}
