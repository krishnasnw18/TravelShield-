import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/models/user.dart';
import 'package:wayfinder_bloom/providers/auth_provider.dart';
import 'package:wayfinder_bloom/providers/location_provider.dart';
import 'package:wayfinder_bloom/providers/incident_provider.dart';
import 'package:wayfinder_bloom/screens/wallet_screen.dart';
import 'package:wayfinder_bloom/screens/safety_map_screen.dart';
import 'package:wayfinder_bloom/screens/ai_assistant_screen.dart';
import 'package:wayfinder_bloom/screens/profile_screen.dart';
import 'package:wayfinder_bloom/screens/police_dashboard.dart';
import 'package:wayfinder_bloom/screens/admin_dashboard.dart';
import 'package:wayfinder_bloom/widgets/did_card.dart';
import 'package:wayfinder_bloom/widgets/sos_button.dart';
import 'package:wayfinder_bloom/widgets/safety_status_card.dart';
import 'package:wayfinder_bloom/widgets/weather_card.dart';
import 'package:wayfinder_bloom/services/did_service.dart';
import 'package:wayfinder_bloom/models/did.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  DigitalID? _digitalID;
  
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadDigitalID();
  }

  void _initializeServices() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      final incidentProvider = Provider.of<IncidentProvider>(context, listen: false);
      
      locationProvider.initialize();
      incidentProvider.initialize();
    });
  }

  void _loadDigitalID() async {
    final didService = DIDService();
    final digitalID = await didService.getDigitalID();
    setState(() {
      _digitalID = digitalID;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        if (user == null) return const SizedBox();

        // Show role-specific dashboard
        if (user.role == UserRole.police) {
          return const PoliceDashboard();
        } else if (user.role == UserRole.admin) {
          return const AdminDashboard();
        }

        // Tourist dashboard
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildTouristDashboard(user),
              const WalletScreen(),
              const SafetyMapScreen(),
              const AIAssistantScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(),
          floatingActionButton: _buildAIAssistantFAB(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        );
      },
    );
  }

  Widget _buildTouristDashboard(User user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.name.split(' ')[0]}'),
        actions: [
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Digital ID Card
            if (_digitalID != null)
              DIDCard(
                digitalID: _digitalID!,
                onTap: () => _onTabTapped(1), // Navigate to wallet
              ),
            
            // SOS Button (moved here from emergency screen)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Emergency Assistance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SOSButton(),
                  const SizedBox(height: 12),
                  Text(
                    'Press and hold in case of emergency',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Safety Status Card
            const SafetyStatusCard(),
            
            // Weather Card
            const WeatherCard(),
            
            // Recent Safety Alerts
            _buildSafetyAlerts(),
            
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyAlerts() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Safety Alerts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SafetyAlertItem(
            icon: Icons.info,
            title: 'Weather Advisory',
            subtitle: 'Light rain expected this evening',
            time: '2 hours ago',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _SafetyAlertItem(
            icon: Icons.traffic,
            title: 'Traffic Update',
            subtitle: 'Heavy traffic near India Gate',
            time: '4 hours ago',
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          _SafetyAlertItem(
            icon: Icons.security,
            title: 'Safety Reminder',
            subtitle: 'Keep your documents secure',
            time: '1 day ago',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Safety Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy),
          label: 'AI Assistant',
        ),
      ],
    );
  }

  Widget _buildAIAssistantFAB() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: FloatingActionButton(
        onPressed: () => _onTabTapped(3),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.smart_toy,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _SafetyAlertItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _SafetyAlertItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
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
    );
  }
}