import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../shared_functions.dart';
import '../../user_location.dart';

class BackgroundMap extends StatefulWidget {
  const BackgroundMap({super.key});

  @override
  State<BackgroundMap> createState() => _BackgroundMapState();
}

class _BackgroundMapState extends State<BackgroundMap> {
  final MapController _mapController = MapController();
  final TileLayer _tileLayer = TileLayer(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  );
  LatLng _currentLocation = const LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
  }

  Future<void> onLocationDisabled() async {
    if (!mounted) return;
    showSnackBar(
      context,
      "Location access is denied. Opening Location Settings",
    );

    Timer(const Duration(seconds: 3), () async {
      await Geolocator.openLocationSettings();
    });
  }

  Future<void> getCurrentLatLngLocation() async {
    Position? position = await UserLocation().getCurrentLocation(
      onLocationDisabled,
    );
    if (position != null) {
      _currentLocation = LatLng(position.latitude, position.longitude);
    } else {
      _currentLocation = const LatLng(37.7749, -122.4194); // San Francisco
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentLatLngLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 13.0,
                maxZoom: 18.0,
                minZoom: 3.0,
              ),
              children: [
                _tileLayer,
              ],
            );
          }
        });
  }
}

class CurrentCityBox extends StatefulWidget {
  const CurrentCityBox({
    super.key,
  });

  @override
  State<CurrentCityBox> createState() => _CurrentCityBoxState();
}

class _CurrentCityBoxState extends State<CurrentCityBox> {
  String _currentCity = 'Loading..';

  Future<void> onLocationDisabled() async {
    _currentCity = 'Denied';
  }

  String getCityByPosition(Position? position) {
    // TODO() Добавить определение города по позиции
    return 'Your city';
  }

  Future<void> setCurrentCity() async {
    Position? position =
        await UserLocation().getCurrentLocation(onLocationDisabled);
    _currentCity = getCityByPosition(position);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setCurrentCity(),
      builder: (context, snapshot) {
        String text;
        if (snapshot.connectionState == ConnectionState.waiting) {
          text = 'Loading...';
        } else if (snapshot.hasError) {
          text = 'Error: ${snapshot.error}';
        } else {
          text = _currentCity;
        }
        return Container(
          color: Colors.white.withOpacity(0.7),
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }
    );
  }
}
