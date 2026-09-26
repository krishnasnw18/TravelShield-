import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/providers/location_provider.dart';
import 'package:wayfinder_bloom/services/location_service.dart';

class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedServiceIndex = -1;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Map'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Services', icon: Icon(Icons.local_hospital)),
            Tab(text: 'Alerts', icon: Icon(Icons.warning)),
            Tab(text: 'Map', icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServicesTab(),
          _buildAlertsTab(),
          _buildMapTab(),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (locationProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (locationProvider.currentPosition == null) {
          return _buildLocationDisabledMessage();
        }

        final services = locationProvider.nearbyServices;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Location Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Current Location',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            locationProvider.locationString,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                'Nearby Emergency Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ...services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                return _ServiceCard(
                  service: service,
                  isSelected: _selectedServiceIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedServiceIndex = _selectedServiceIndex == index ? -1 : index;
                    });
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsTab() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final restrictedZones = locationProvider.restrictedZones;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Geofencing is active and monitoring your location for restricted areas.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                'Restricted Zones',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ...restrictedZones.map((zone) => _RestrictedZoneCard(
                zone: zone,
                currentDistance: locationProvider.getDistanceToZone(zone),
              )),
              
              const SizedBox(height: 24),
              
              Text(
                'Recent Alerts',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              _AlertCard(
                icon: Icons.traffic,
                title: 'All Clear',
                subtitle: 'No active geofencing alerts in your area',
                timestamp: '2 minutes ago',
                alertType: AlertType.info,
              ),
              
              _AlertCard(
                icon: Icons.warning,
                title: 'Safety Reminder',
                subtitle: 'You approached a restricted zone 2 hours ago',
                timestamp: '2 hours ago',
                alertType: AlertType.warning,
              ),
              
              _AlertCard(
                icon: Icons.check_circle,
                title: 'Safe Zone',
                subtitle: 'You entered a tourist-friendly area',
                timestamp: '4 hours ago',
                alertType: AlertType.success,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapTab() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (locationProvider.currentPosition == null) {
          return _buildLocationDisabledMessage();
        }

        // Since we can't use Google Maps in this context, we'll show a placeholder
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Map Placeholder
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
                              'Interactive Safety Map',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Current Location: ${locationProvider.locationString}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // Simulated pins
                      Positioned(
                        top: 80,
                        left: 120,
                        child: _MapPin(
                          icon: Icons.my_location,
                          color: Theme.of(context).colorScheme.primary,
                          label: 'You',
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 100,
                        child: _MapPin(
                          icon: Icons.local_hospital,
                          color: Colors.red,
                          label: 'Hospital',
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: 80,
                        child: _MapPin(
                          icon: Icons.local_police,
                          color: Colors.blue,
                          label: 'Police',
                        ),
                      ),
                      Positioned(
                        top: 120,
                        right: 160,
                        child: _MapPin(
                          icon: Icons.dangerous,
                          color: Colors.orange,
                          label: 'Restricted',
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Legend
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Map Legend',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icons.my_location,
                        label: 'Your Current Location',
                      ),
                      _LegendItem(
                        color: Colors.red,
                        icon: Icons.local_hospital,
                        label: 'Emergency Services',
                      ),
                      _LegendItem(
                        color: Colors.blue,
                        icon: Icons.local_police,
                        label: 'Police Stations',
                      ),
                      _LegendItem(
                        color: Colors.orange,
                        icon: Icons.dangerous,
                        label: 'Restricted Zones',
                      ),
                      _LegendItem(
                        color: Colors.green,
                        icon: Icons.local_pharmacy,
                        label: 'Pharmacies',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationDisabledMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_disabled,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Location Services Disabled',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enable location services to view nearby emergency services and safety alerts.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final locationProvider = Provider.of<LocationProvider>(context, listen: false);
                locationProvider.initialize();
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Enable Location'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color serviceColor = _getServiceColor(service['type']);
    IconData serviceIcon = _getServiceIcon(service['type']);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? serviceColor.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
              ? serviceColor
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: serviceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    serviceIcon,
                    color: serviceColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['type'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: serviceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      service['distanceText'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          service['rating'].toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call service
                      },
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: serviceColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Get directions
                      },
                      icon: const Icon(Icons.directions, size: 16),
                      label: const Text('Directions'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getServiceColor(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
        return Colors.red;
      case 'police':
        return Colors.blue;
      case 'fire department':
        return Colors.orange;
      case 'pharmacy':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
        return Icons.local_hospital;
      case 'police':
        return Icons.local_police;
      case 'fire department':
        return Icons.local_fire_department;
      case 'pharmacy':
        return Icons.local_pharmacy;
      default:
        return Icons.location_on;
    }
  }
}

class _RestrictedZoneCard extends StatelessWidget {
  final dynamic zone;
  final double? currentDistance;

  const _RestrictedZoneCard({
    required this.zone,
    this.currentDistance,
  });

  @override
  Widget build(BuildContext context) {
    final isNearby = currentDistance != null && currentDistance! < 2000; // 2km
    final statusColor = isNearby ? Colors.orange : Colors.green;
    
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
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dangerous,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  zone.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (currentDistance != null)
                Text(
                  '${(currentDistance! / 1000).toStringAsFixed(1)} km',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            zone.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    zone.warningMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum AlertType { info, warning, error, success }

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timestamp;
  final AlertType alertType;

  const _AlertCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.alertType,
  });

  @override
  Widget build(BuildContext context) {
    Color alertColor;
    switch (alertType) {
      case AlertType.info:
        alertColor = Colors.blue;
        break;
      case AlertType.warning:
        alertColor = Colors.orange;
        break;
      case AlertType.error:
        alertColor = Colors.red;
        break;
      case AlertType.success:
        alertColor = Colors.green;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: alertColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            timestamp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _MapPin({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _LegendItem({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}