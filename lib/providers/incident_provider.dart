import 'package:flutter/foundation.dart';
import 'package:wayfinder_bloom/models/incident.dart';
import 'package:wayfinder_bloom/services/sos_service.dart';

class IncidentProvider with ChangeNotifier {
  final SOSService _sosService = SOSService.instance;
  
  List<Incident> _incidents = [];
  bool _isLoading = false;
  String? _error;

  List<Incident> get incidents => _incidents;
  List<Incident> get activeIncidents => _incidents.where((i) => i.status == IncidentStatus.active).toList();
  List<Incident> get resolvedIncidents => _incidents.where((i) => i.status == IncidentStatus.resolved).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initialize() {
    // Load demo incidents for police/admin dashboards
    _incidents = SOSService.generateDemoIncidents();
    notifyListeners();
  }

  Future<Incident?> triggerSOS(String userId, String userName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final incident = await _sosService.triggerSOS(userId, userName);
      if (incident != null) {
        _incidents.insert(0, incident);
        notifyListeners();
      }
      return incident;
    } catch (e) {
      _error = e.toString();
      debugPrint('SOS trigger error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void acknowledgeIncident(String incidentId) {
    final index = _incidents.indexWhere((i) => i.id == incidentId);
    if (index != -1) {
      _incidents[index] = Incident(
        id: _incidents[index].id,
        userId: _incidents[index].userId,
        userName: _incidents[index].userName,
        type: _incidents[index].type,
        status: IncidentStatus.acknowledged,
        timestamp: _incidents[index].timestamp,
        latitude: _incidents[index].latitude,
        longitude: _incidents[index].longitude,
        description: _incidents[index].description,
        additionalInfo: _incidents[index].additionalInfo,
      );
      notifyListeners();
    }
  }

  void resolveIncident(String incidentId) {
    final index = _incidents.indexWhere((i) => i.id == incidentId);
    if (index != -1) {
      _incidents[index] = Incident(
        id: _incidents[index].id,
        userId: _incidents[index].userId,
        userName: _incidents[index].userName,
        type: _incidents[index].type,
        status: IncidentStatus.resolved,
        timestamp: _incidents[index].timestamp,
        latitude: _incidents[index].latitude,
        longitude: _incidents[index].longitude,
        description: _incidents[index].description,
        additionalInfo: _incidents[index].additionalInfo,
      );
      notifyListeners();
    }
  }

  void dismissIncident(String incidentId) {
    final index = _incidents.indexWhere((i) => i.id == incidentId);
    if (index != -1) {
      _incidents[index] = Incident(
        id: _incidents[index].id,
        userId: _incidents[index].userId,
        userName: _incidents[index].userName,
        type: _incidents[index].type,
        status: IncidentStatus.dismissed,
        timestamp: _incidents[index].timestamp,
        latitude: _incidents[index].latitude,
        longitude: _incidents[index].longitude,
        description: _incidents[index].description,
        additionalInfo: _incidents[index].additionalInfo,
      );
      notifyListeners();
    }
  }

  List<Incident> getIncidentsByType(IncidentType type) {
    return _incidents.where((i) => i.type == type).toList();
  }

  List<Incident> getIncidentsByStatus(IncidentStatus status) {
    return _incidents.where((i) => i.status == status).toList();
  }

  Map<String, int> getIncidentStats() {
    return {
      'total': _incidents.length,
      'active': activeIncidents.length,
      'resolved': resolvedIncidents.length,
      'sos': getIncidentsByType(IncidentType.sos).length,
      'geofence': getIncidentsByType(IncidentType.geofenceViolation).length,
      'medical': getIncidentsByType(IncidentType.medicalEmergency).length,
    };
  }
}