enum IncidentType { 
  sos, 
  geofenceViolation, 
  safetyAlert, 
  emergencyContact,
  medicalEmergency,
  locationLost 
}

enum IncidentStatus { 
  active, 
  acknowledged, 
  resolved, 
  dismissed 
}

class Incident {
  final String id;
  final String userId;
  final String userName;
  final IncidentType type;
  final IncidentStatus status;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String description;
  final String? additionalInfo;

  Incident({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.additionalInfo,
  });

  String get locationString => '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'type': type.name,
    'status': status.name,
    'timestamp': timestamp.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'description': description,
    'additionalInfo': additionalInfo,
  };

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    type: IncidentType.values.firstWhere((type) => type.name == json['type']),
    status: IncidentStatus.values.firstWhere((status) => status.name == json['status']),
    timestamp: DateTime.parse(json['timestamp']),
    latitude: json['latitude'],
    longitude: json['longitude'],
    description: json['description'],
    additionalInfo: json['additionalInfo'],
  );
}

class RestrictedZone {
  final String id;
  final String name;
  final double centerLatitude;
  final double centerLongitude;
  final double radius; // in meters
  final String description;
  final String warningMessage;

  RestrictedZone({
    required this.id,
    required this.name,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radius,
    required this.description,
    required this.warningMessage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'centerLatitude': centerLatitude,
    'centerLongitude': centerLongitude,
    'radius': radius,
    'description': description,
    'warningMessage': warningMessage,
  };

  factory RestrictedZone.fromJson(Map<String, dynamic> json) => RestrictedZone(
    id: json['id'],
    name: json['name'],
    centerLatitude: json['centerLatitude'],
    centerLongitude: json['centerLongitude'],
    radius: json['radius'],
    description: json['description'],
    warningMessage: json['warningMessage'],
  );
}