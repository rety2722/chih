import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'account.dart';
import 'friends.dart';
import 'events.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapController _mapController;
  Position? _currentLocation;
  String _currentCity = "Loading...";

  final TileLayer _tileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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
        _showSnackBar(
            "Permission is ${permission.toString()}. Opening Location Settings");

        Timer(const Duration(seconds: 3), () async {
          await Geolocator.openLocationSettings();
        });
        return;
      }
    }

    try {
      _currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (_currentLocation != null) {
        _mapController.move(
          LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          13.0,
        );
        _getCityFromLocation(_currentLocation!);
      }
    } catch (e) {
      setState(() {
        _currentCity = "Unable to retrieve location";
      });
    }
  }

  Future<void> _getCityFromLocation(Position currentLocation) async {
    // TODO Добавить определение города по локации
    setState(() {
      _currentCity = "Your City"; // TODO заменить на результат
    });
  }

  Future<void> _navigateToAccountPage() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountPage()),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  LatLng _getCurrentLatLngLocation() {
    return LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
  }

  void _processSearch() {
    // TODO()
    return;
  }

  Future<void> _processManageEvents() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventsPage()),
    );
  }

  Future<void> _processManageFriends() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundMap(),
          Positioned(
            top: 40,
            left: 16,
            child: _currentCityWidget(),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: _accountPageButton(),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _bottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _backgroundMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation != null
            ? _getCurrentLatLngLocation()
            : const LatLng(37.7749, -122.4194), // San Francisco
        initialZoom: 13.0,
        maxZoom: 18.0,
        minZoom: 3.0,
      ),
      children: [
        _tileLayer,
      ],
    );
  }

  Widget _currentCityWidget() {
    return Container(
      color: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(8),
      child: Text(
        _currentCity,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _accountPageButton() {
    return IconButton(
      icon: const Icon(Icons.account_circle, size: 30),
      onPressed: _navigateToAccountPage,
    );
  }

  Widget _bottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _searchButton(),
        _eventButton(),
        _friendsButton(),
      ],
    );
  }

  Widget _searchButton() {
    return ElevatedButton(
      onPressed: _processSearch,
      child: const Icon(Icons.search),
    );
  }

  Widget _eventButton() {
    return ElevatedButton(
      onPressed: _processManageEvents,
      child: const Icon(Icons.event),
    );
  }

  Widget _friendsButton() {
    return ElevatedButton(
      onPressed: _processManageFriends,
      child: const Icon(Icons.person_add),
    );
  }
}
