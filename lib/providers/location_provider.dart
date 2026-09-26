import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wayfinder_bloom/models/incident.dart';
import 'package:wayfinder_bloom/services/location_service.dart';
import 'package:wayfinder_bloom/services/notification_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService.instance;
  final NotificationService _notificationService = NotificationService.instance;
  
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  List<RestrictedZone> _restrictedZones = [];
  List<Map<String, dynamic>> _nearbyServices = [];
  bool _isLoading = false;
  String? _error;

  Position? get currentPosition => _currentPosition;
  List<RestrictedZone> get restrictedZones => _restrictedZones;
  List<Map<String, dynamic>> get nearbyServices => _nearbyServices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Request location permission
      final hasPermission = await _locationService.requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      // Get current location
      await updateLocation();

      // Initialize restricted zones
      _initializeRestrictedZones();

      // Start location tracking
      _startLocationTracking();
    } catch (e) {
      _error = e.toString();
      debugPrint('Location initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;
        _updateNearbyServices();
        _checkGeofences();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  void _startLocationTracking() {
    _positionStream = _locationService.getLocationStream().listen(
      (position) {
        _currentPosition = position;
        _updateNearbyServices();
        _checkGeofences();
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
      },
    );
  }

  void _initializeRestrictedZones() {
    _restrictedZones = LocationService.demoRestrictedZones
        .map((zoneData) => RestrictedZone.fromJson(zoneData))
        .toList();
  }

  void _updateNearbyServices() {
    if (_currentPosition != null) {
      _nearbyServices = LocationService.demoEmergencyServices.map((service) {
        final distance = _locationService.calculateDistance(
          _currentPosition!.latitude, _currentPosition!.longitude,
          service['latitude'], service['longitude']
        );
        
        return {
          ...service,
          'actualDistance': distance,
          'distanceText': distance < 1000 
            ? '${distance.round()} m' 
            : '${(distance / 1000).toStringAsFixed(1)} km',
        };
      }).toList()
        ..sort((a, b) => (a['actualDistance'] as double).compareTo(b['actualDistance']));
    }
  }

  void _checkGeofences() {
    if (_currentPosition == null) return;

    for (final zone in _restrictedZones) {
      final distance = _locationService.calculateDistance(
        _currentPosition!.latitude, _currentPosition!.longitude,
        zone.centerLatitude, zone.centerLongitude
      );

      if (distance <= zone.radius) {
        _handleGeofenceViolation(zone);
      }
    }
  }

  void _handleGeofenceViolation(RestrictedZone zone) async {
    // Show notification
    await _notificationService.showGeofenceAlert(zone.name, zone.warningMessage);
    
    // Log incident
    debugPrint('🚨 GEOFENCE VIOLATION');
    debugPrint('Zone: ${zone.name}');
    debugPrint('Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
    debugPrint('Warning: ${zone.warningMessage}');
  }

  String get locationString {
    if (_currentPosition == null) return 'Location unavailable';
    return '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}';
  }

  double? getDistanceToZone(RestrictedZone zone) {
    if (_currentPosition == null) return null;
    return _locationService.calculateDistance(
      _currentPosition!.latitude, _currentPosition!.longitude,
      zone.centerLatitude, zone.centerLongitude
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}