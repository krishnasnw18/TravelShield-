import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static LocationService? _instance;
  LocationService._internal();
  
  static LocationService get instance {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  Future<bool> requestLocationPermission() async {
    final permission = await Permission.location.request();
    return permission == PermissionStatus.granted;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Stream<Position> getLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  double calculateDistance(
    double lat1, double lon1, 
    double lat2, double lon2
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Demo locations for restricted zones
  static const List<Map<String, dynamic>> demoRestrictedZones = [
    {
      'id': 'zone-1',
      'name': 'Military Base',
      'centerLatitude': 28.6139,
      'centerLongitude': 77.2090,
      'radius': 1000.0,
      'description': 'Restricted military area',
      'warningMessage': 'You are entering a restricted military zone. Please turn back immediately.',
    },
    {
      'id': 'zone-2',
      'name': 'Airport Security Zone',
      'centerLatitude': 28.5562,
      'centerLongitude': 77.1000,
      'radius': 500.0,
      'description': 'Airport restricted area',
      'warningMessage': 'You are near a restricted airport zone. Unauthorized access is prohibited.',
    },
    {
      'id': 'zone-3',
      'name': 'Government Building',
      'centerLatitude': 28.6129,
      'centerLongitude': 77.2295,
      'radius': 200.0,
      'description': 'Government restricted zone',
      'warningMessage': 'This is a restricted government area. Photography and loitering are prohibited.',
    },
  ];

  // Demo emergency services locations
  static const List<Map<String, dynamic>> demoEmergencyServices = [
    {
      'id': 'police-1',
      'name': 'Delhi Police Station',
      'type': 'Police',
      'latitude': 28.6300,
      'longitude': 77.2200,
      'phone': '+91-11-23456789',
      'distance': '1.2 km',
      'rating': 4.2,
    },
    {
      'id': 'hospital-1',
      'name': 'All India Institute of Medical Sciences',
      'type': 'Hospital',
      'latitude': 28.5672,
      'longitude': 77.2100,
      'phone': '+91-11-26588500',
      'distance': '2.8 km',
      'rating': 4.8,
    },
    {
      'id': 'fire-1',
      'name': 'Fire Station CP',
      'type': 'Fire Department',
      'latitude': 28.6290,
      'longitude': 77.2070,
      'phone': '+91-11-23456101',
      'distance': '0.9 km',
      'rating': 4.1,
    },
    {
      'id': 'pharmacy-1',
      'name': 'Apollo Pharmacy',
      'type': 'Pharmacy',
      'latitude': 28.6250,
      'longitude': 77.2120,
      'phone': '+91-11-23456555',
      'distance': '0.5 km',
      'rating': 4.3,
    },
  ];
}