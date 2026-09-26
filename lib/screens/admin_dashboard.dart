import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/providers/auth_provider.dart';
import 'package:wayfinder_bloom/providers/incident_provider.dart';
import 'package:wayfinder_bloom/models/incident.dart';
import 'package:wayfinder_bloom/screens/profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
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
                const Text('Tourism Admin'),
                Text(
                  'Welcome, ${user.name.split(' ').first}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics),
                onPressed: () {
                  // Export analytics
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
                Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
                Tab(text: 'Heatmap', icon: Icon(Icons.heat_pump)),
                Tab(text: 'Reports', icon: Icon(Icons.bar_chart)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildHeatmapTab(),
              _buildReportsTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<IncidentProvider>(
      builder: (context, incidentProvider, child) {
        final stats = incidentProvider.getIncidentStats();
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Key Metrics
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Metrics',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Total Tourists',
                            value: '1,247',
                            change: '+12%',
                            isPositive: true,
                            icon: Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            title: 'Active Incidents',
                            value: '${stats['active']}',
                            change: '-8%',
                            isPositive: true,
                            icon: Icons.warning,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Safety Score',
                            value: '94.2%',
                            change: '+2.1%',
                            isPositive: true,
                            icon: Icons.security,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            title: 'Response Time',
                            value: '2.3 min',
                            change: '-0.5 min',
                            isPositive: true,
                            icon: Icons.timer,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tourist Clusters
              _buildTouristClusters(),
              
              // Recent Activity
              _buildRecentActivity(),
              
              // Trending Locations
              _buildTrendingLocations(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTouristClusters() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Icon(
                Icons.groups,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Tourist Clusters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Live',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ClusterItem(
            location: 'India Gate',
            touristCount: 89,
            safetyLevel: 'High',
            safetyColor: Colors.green,
            trend: '+12',
          ),
          _ClusterItem(
            location: 'Red Fort',
            touristCount: 67,
            safetyLevel: 'High',
            safetyColor: Colors.green,
            trend: '+8',
          ),
          _ClusterItem(
            location: 'Lotus Temple',
            touristCount: 45,
            safetyLevel: 'Medium',
            safetyColor: Colors.orange,
            trend: '-5',
          ),
          _ClusterItem(
            location: 'Qutub Minar',
            touristCount: 34,
            safetyLevel: 'High',
            safetyColor: Colors.green,
            trend: '+3',
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Icon(
                Icons.timeline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ActivityItem(
            icon: Icons.check_circle,
            title: 'SOS Incident Resolved',
            subtitle: 'Tourist assistance completed at Chandni Chowk',
            time: '5 minutes ago',
            color: Colors.green,
          ),
          _ActivityItem(
            icon: Icons.warning,
            title: 'Geofence Alert',
            subtitle: 'Tourist entered restricted zone near Parliament',
            time: '12 minutes ago',
            color: Colors.orange,
          ),
          _ActivityItem(
            icon: Icons.trending_up,
            title: 'Tourist Influx',
            subtitle: 'High tourist activity detected at Humayun\'s Tomb',
            time: '25 minutes ago',
            color: Colors.blue,
          ),
          _ActivityItem(
            icon: Icons.security,
            title: 'Safety Update',
            subtitle: 'Enhanced security measures deployed',
            time: '1 hour ago',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingLocations() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Trending Destinations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TrendingLocationItem(
            rank: 1,
            location: 'India Gate',
            visits: 1247,
            change: 15.2,
            rating: 4.8,
          ),
          _TrendingLocationItem(
            rank: 2,
            location: 'Red Fort',
            visits: 1056,
            change: 8.7,
            rating: 4.6,
          ),
          _TrendingLocationItem(
            rank: 3,
            location: 'Lotus Temple',
            visits: 892,
            change: -2.1,
            rating: 4.9,
          ),
          _TrendingLocationItem(
            rank: 4,
            location: 'Qutub Minar',
            visits: 734,
            change: 12.3,
            rating: 4.5,
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Heatmap Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Time Period',
                      border: OutlineInputBorder(),
                    ),
                    value: 'Today',
                    items: const [
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                      DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                      DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Data Type',
                      border: OutlineInputBorder(),
                    ),
                    value: 'Tourist Density',
                    items: const [
                      DropdownMenuItem(value: 'Tourist Density', child: Text('Tourist Density')),
                      DropdownMenuItem(value: 'Incidents', child: Text('Incidents')),
                      DropdownMenuItem(value: 'Safety Score', child: Text('Safety Score')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          
          // Heatmap Visualization
          Container(
            height: 400,
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
                        Icons.heat_pump,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tourist Density Heatmap',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Real-time tourist cluster visualization',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Simulated heat zones
                Positioned(
                  top: 80,
                  left: 100,
                  child: _HeatZone(intensity: 0.9, size: 80, color: Colors.red),
                ),
                Positioned(
                  top: 120,
                  right: 80,
                  child: _HeatZone(intensity: 0.7, size: 60, color: Colors.orange),
                ),
                Positioned(
                  bottom: 100,
                  left: 120,
                  child: _HeatZone(intensity: 0.5, size: 50, color: Colors.yellow),
                ),
                Positioned(
                  bottom: 120,
                  right: 120,
                  child: _HeatZone(intensity: 0.3, size: 40, color: Colors.green),
                ),
              ],
            ),
          ),
          
          // Heatmap Legend
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Density Legend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _LegendItem(color: Colors.red, label: 'Very High\n(80+ tourists)'),
                    _LegendItem(color: Colors.orange, label: 'High\n(50-80 tourists)'),
                    _LegendItem(color: Colors.yellow, label: 'Medium\n(20-50 tourists)'),
                    _LegendItem(color: Colors.green, label: 'Low\n(<20 tourists)'),
                  ],
                ),
              ],
            ),
          ),
          
          // Zone Statistics
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zone Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _ZoneStatItem(
                  zone: 'Central Delhi',
                  tourists: 1247,
                  incidents: 3,
                  safetyScore: 94.2,
                ),
                _ZoneStatItem(
                  zone: 'Old Delhi',
                  tourists: 892,
                  incidents: 5,
                  safetyScore: 91.8,
                ),
                _ZoneStatItem(
                  zone: 'South Delhi',
                  tourists: 634,
                  incidents: 1,
                  safetyScore: 96.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Reports',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Report Cards
            _ReportCard(
              title: 'Monthly Safety Report',
              description: 'Comprehensive safety analysis for November 2024',
              icon: Icons.security,
              color: Colors.green,
              onTap: () {},
            ),
            _ReportCard(
              title: 'Tourist Flow Analysis',
              description: 'Peak hours and popular destinations analysis',
              icon: Icons.analytics,
              color: Colors.blue,
              onTap: () {},
            ),
            _ReportCard(
              title: 'Incident Response Report',
              description: 'Response times and resolution efficiency',
              icon: Icons.timer,
              color: Colors.orange,
              onTap: () {},
            ),
            _ReportCard(
              title: 'Geofencing Effectiveness',
              description: 'Analysis of restricted zone monitoring',
              icon: Icons.location_on,
              color: Colors.purple,
              onTap: () {},
            ),
            _ReportCard(
              title: 'Tourist Satisfaction Survey',
              description: 'Feedback and ratings from tourist experiences',
              icon: Icons.sentiment_satisfied,
              color: Colors.teal,
              onTap: () {},
            ),
            
            const SizedBox(height: 24),
            
            // Quick Export Options
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Data',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.file_download),
                          label: const Text('Export CSV'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Export PDF'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget components for the admin dashboard...
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClusterItem extends StatelessWidget {
  final String location;
  final int touristCount;
  final String safetyLevel;
  final Color safetyColor;
  final String trend;

  const _ClusterItem({
    required this.location,
    required this.touristCount,
    required this.safetyLevel,
    required this.safetyColor,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$touristCount tourists',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: safetyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              safetyLevel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: safetyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            trend,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: trend.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingLocationItem extends StatelessWidget {
  final int rank;
  final String location;
  final int visits;
  final double change;
  final double rating;

  const _TrendingLocationItem({
    required this.rank,
    required this.location,
    required this.visits,
    required this.change,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? Theme.of(context).colorScheme.primary : Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$visits visits',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: change > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatZone extends StatelessWidget {
  final double intensity;
  final double size;
  final Color color;

  const _HeatZone({
    required this.intensity,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: intensity * 0.3),
        border: Border.all(
          color: color.withValues(alpha: intensity),
          width: 2,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ZoneStatItem extends StatelessWidget {
  final String zone;
  final int tourists;
  final int incidents;
  final double safetyScore;

  const _ZoneStatItem({
    required this.zone,
    required this.tourists,
    required this.incidents,
    required this.safetyScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              zone,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text('$tourists tourists', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 16),
          Text('$incidents incidents', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 16),
          Text(
            '${safetyScore.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: safetyScore > 90 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.download),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}