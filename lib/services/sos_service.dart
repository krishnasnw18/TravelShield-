import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:wayfinder_bloom/models/incident.dart';
import 'package:wayfinder_bloom/services/location_service.dart';
import 'package:wayfinder_bloom/services/notification_service.dart';

class SOSService {
  static SOSService? _instance;
  SOSService._internal();
  
  static SOSService get instance {
    _instance ??= SOSService._internal();
    return _instance!;
  }

  final LocationService _locationService = LocationService.instance;
  final NotificationService _notificationService = NotificationService.instance;
  
  Future<Incident?> triggerSOS(String userId, String userName) async {
    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        throw Exception('Unable to get current location');
      }

      // Create SOS incident
      final incident = Incident(
        id: 'SOS-${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        userName: userName,
        type: IncidentType.sos,
        status: IncidentStatus.active,
        timestamp: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        description: 'Emergency SOS alert triggered',
        additionalInfo: 'User manually triggered SOS button',
      );

      // Log the incident (in real app, this would be sent to server)
      print('🆘 SOS ALERT TRIGGERED');
      print('User: $userName ($userId)');
      print('Location: ${incident.locationString}');
      print('Time: ${incident.timestamp}');

      // Send local notification
      await _notificationService.showSOSNotification(incident);

      // In real app: Send to emergency services, notify emergency contacts
      await _simulateEmergencyResponse(incident);

      return incident;
    } catch (e) {
      print('Error triggering SOS: $e');
      return null;
    }
  }

  Future<void> _simulateEmergencyResponse(Incident incident) async {
    // Simulate emergency response
    print('📱 Notifying emergency contacts...');
    print('🚓 Alerting nearest police units...');
    print('🏥 Notifying nearby hospitals...');
    
    // Simulate response time
    await Future.delayed(const Duration(seconds: 2));
    print('✅ Emergency services notified successfully');
  }

  List<Map<String, dynamic>> getNearbyEmergencyServices(
    double latitude, 
    double longitude
  ) {
    return LocationService.demoEmergencyServices.map((service) {
      final distance = _locationService.calculateDistance(
        latitude, longitude,
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

  String generateSOSMessage(Incident incident) {
    return '''🆘 EMERGENCY ALERT 🆘
    
Tourist: ${incident.userName}
Time: ${_formatTimestamp(incident.timestamp)}
Location: ${incident.locationString}
Type: Emergency SOS

This is an automated emergency alert from Wayfinder Bloom.
Please respond immediately.''';
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Demo incidents for police/admin dashboards
  static List<Incident> generateDemoIncidents() {
    final random = Random();
    final now = DateTime.now();
    
    return [
      Incident(
        id: 'INC-001',
        userId: '1',
        userName: 'John Smith',
        type: IncidentType.sos,
        status: IncidentStatus.active,
        timestamp: now.subtract(const Duration(minutes: 5)),
        latitude: 28.6139 + (random.nextDouble() - 0.5) * 0.01,
        longitude: 77.2090 + (random.nextDouble() - 0.5) * 0.01,
        description: 'Emergency SOS alert triggered',
        additionalInfo: 'Tourist in distress near Red Fort',
      ),
      Incident(
        id: 'INC-002',
        userId: '4',
        userName: 'Maria Garcia',
        type: IncidentType.geofenceViolation,
        status: IncidentStatus.acknowledged,
        timestamp: now.subtract(const Duration(hours: 2)),
        latitude: 28.5562 + (random.nextDouble() - 0.5) * 0.01,
        longitude: 77.1000 + (random.nextDouble() - 0.5) * 0.01,
        description: 'Entered restricted airport zone',
        additionalInfo: 'Tourist accidentally entered security perimeter',
      ),
      Incident(
        id: 'INC-003',
        userId: '5',
        userName: 'David Lee',
        type: IncidentType.medicalEmergency,
        status: IncidentStatus.resolved,
        timestamp: now.subtract(const Duration(hours: 6)),
        latitude: 28.6250 + (random.nextDouble() - 0.5) * 0.01,
        longitude: 77.2120 + (random.nextDouble() - 0.5) * 0.01,
        description: 'Medical emergency reported',
        additionalInfo: 'Tourist required immediate medical assistance',
      ),
    ];
  }
}