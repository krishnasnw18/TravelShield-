import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/providers/auth_provider.dart';
import 'package:wayfinder_bloom/providers/incident_provider.dart';
import 'package:wayfinder_bloom/models/incident.dart';
import 'package:wayfinder_bloom/screens/profile_screen.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, IncidentProvider>(
      builder: (context, authProvider, incidentProvider, child) {
        final user = authProvider.currentUser;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Police Dashboard'),
                Text(
                  'Officer ${user.name.split(' ').last}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  incidentProvider.initialize();
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: user.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            user.profileImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Active', icon: Icon(Icons.warning)),
                Tab(text: 'All Incidents', icon: Icon(Icons.list)),
                Tab(text: 'Map View', icon: Icon(Icons.map)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildActiveIncidentsTab(),
              _buildAllIncidentsTab(),
              _buildMapViewTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveIncidentsTab() {
    return Consumer<IncidentProvider>(
      builder: (context, incidentProvider, child) {
        final activeIncidents = incidentProvider.activeIncidents;
        final stats = incidentProvider.getIncidentStats();

        return SingleChildScrollView(
          child: Column(
            children: [
              // Stats Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        title: 'Active Alerts',
                        value: '${stats['active']}',
                        icon: Icons.warning,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatsCard(
                        title: 'SOS Calls',
                        value: '${stats['sos']}',
                        icon: Icons.emergency,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Active Incidents List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Active Incidents',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${activeIncidents.length} active',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              if (activeIncidents.isEmpty)
                _buildEmptyState('No active incidents', Icons.check_circle)
              else
                ...activeIncidents.map((incident) => _IncidentCard(
                  incident: incident,
                  onAcknowledge: () => incidentProvider.acknowledgeIncident(incident.id),
                  onResolve: () => incidentProvider.resolveIncident(incident.id),
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllIncidentsTab() {
    return Consumer<IncidentProvider>(
      builder: (context, incidentProvider, child) {
        final incidents = incidentProvider.incidents;
        
        return Column(
          children: [
            // Filter chips
            Container(
              height: 60,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: true,
                      onSelected: (selected) {},
                    ),
                    _FilterChip(
                      label: 'SOS',
                      isSelected: false,
                      onSelected: (selected) {},
                    ),
                    _FilterChip(
                      label: 'Geofence',
                      isSelected: false,
                      onSelected: (selected) {},
                    ),
                    _FilterChip(
                      label: 'Medical',
                      isSelected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: incidents.isEmpty
                ? _buildEmptyState('No incidents found', Icons.inbox)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: incidents.length,
                    itemBuilder: (context, index) => _IncidentCard(
                      incident: incidents[index],
                      onAcknowledge: () => incidentProvider.acknowledgeIncident(incidents[index].id),
                      onResolve: () => incidentProvider.resolveIncident(incidents[index].id),
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapViewTab() {
    return Consumer<IncidentProvider>(
      builder: (context, incidentProvider, child) {
        final incidents = incidentProvider.incidents;
        
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            children: [
              // Map placeholder
              Container(
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Incident Map View',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Real-time incident locations',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Simulated incident markers
                    ...incidents.take(5).map((incident) {
                      final random = (incident.id.hashCode % 100) / 100;
                      return Positioned(
                        top: 80 + (random * 120),
                        left: 60 + (random * 200),
                        child: _MapPin(
                          incident: incident,
                          onTap: () => _showIncidentDetails(context, incident),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              
              // Incident list below map
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Incidents on Map',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: incidents.take(10).length,
                          itemBuilder: (context, index) {
                            final incident = incidents[index];
                            return _MapIncidentItem(incident: incident);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showIncidentDetails(BuildContext context, Incident incident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incident Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${incident.type.name}'),
            Text('Status: ${incident.status.name}'),
            Text('User: ${incident.userName}'),
            Text('Location: ${incident.locationString}'),
            Text('Time: ${_formatDateTime(incident.timestamp)}'),
            if (incident.additionalInfo != null)
              Text('Details: ${incident.additionalInfo}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onResolve;

  const _IncidentCard({
    required this.incident,
    this.onAcknowledge,
    this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(incident.status);
    Color typeColor = _getTypeColor(incident.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIncidentIcon(incident.type),
                  color: typeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.description,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tourist: ${incident.userName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  incident.status.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(incident.timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  incident.locationString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          if (incident.status == IncidentStatus.active) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAcknowledge,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Acknowledge'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onResolve,
                    icon: const Icon(Icons.done_all, size: 16),
                    label: const Text('Resolve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.active:
        return Colors.red;
      case IncidentStatus.acknowledged:
        return Colors.orange;
      case IncidentStatus.resolved:
        return Colors.green;
      case IncidentStatus.dismissed:
        return Colors.grey;
    }
  }

  Color _getTypeColor(IncidentType type) {
    switch (type) {
      case IncidentType.sos:
        return Colors.red;
      case IncidentType.geofenceViolation:
        return Colors.orange;
      case IncidentType.medicalEmergency:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getIncidentIcon(IncidentType type) {
    switch (type) {
      case IncidentType.sos:
        return Icons.emergency;
      case IncidentType.geofenceViolation:
        return Icons.dangerous;
      case IncidentType.medicalEmergency:
        return Icons.medical_services;
      default:
        return Icons.warning;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Incident incident;
  final VoidCallback onTap;

  const _MapPin({
    required this.incident,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = _getIncidentColor(incident.type);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _getIncidentIcon(incident.type),
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Color _getIncidentColor(IncidentType type) {
    switch (type) {
      case IncidentType.sos:
        return Colors.red;
      case IncidentType.geofenceViolation:
        return Colors.orange;
      case IncidentType.medicalEmergency:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getIncidentIcon(IncidentType type) {
    switch (type) {
      case IncidentType.sos:
        return Icons.emergency;
      case IncidentType.geofenceViolation:
        return Icons.dangerous;
      case IncidentType.medicalEmergency:
        return Icons.medical_services;
      default:
        return Icons.warning;
    }
  }
}

class _MapIncidentItem extends StatelessWidget {
  final Incident incident;

  const _MapIncidentItem({required this.incident});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getIncidentColor(incident.type),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident.userName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  incident.type.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(incident.timestamp),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIncidentColor(IncidentType type) {
    switch (type) {
      case IncidentType.sos:
        return Colors.red;
      case IncidentType.geofenceViolation:
        return Colors.orange;
      case IncidentType.medicalEmergency:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}