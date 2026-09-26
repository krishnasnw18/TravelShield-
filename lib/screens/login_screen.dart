import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/providers/auth_provider.dart';
import 'package:wayfinder_bloom/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedUserType;

  final List<Map<String, String>> _demoUsers = [
    {
      'type': '🏖️ Tourist',
      'email': 'john.smith@tourist.com',
      'name': 'John Smith',
      'description': 'Digital ID • SOS • Geofencing',
    },
    {
      'type': '👮 Police Officer',
      'email': 'officer.martinez@police.gov',
      'name': 'PSI Gaitonde',
      'description': 'Incident Management • Location Tracking',
    },
    {
      'type': '👨‍💼 Tourism Admin',
      'email': 'sarah.admin@tourism.gov',
      'name': 'Krishna Sonawnae',
      'description': 'Analytics • Heatmaps • Reports',
    },
  ];

  void _handleLogin() async {
    if (_selectedUserType == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedUser = _demoUsers.firstWhere(
      (user) => user['type'] == _selectedUserType,
    );

    final success = await authProvider.login(
      selectedUser['email']!,
      'password123', // Demo password
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // App Logo and Title
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.travel_explore,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'TravelShield',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Smart Travel Safety Companion',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // User Selection Cards
                Text(
                  'Choose Your Role',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                ...(_demoUsers.map((user) => _UserTypeCard(
                  type: user['type']!,
                  name: user['name']!,
                  description: user['description']!,
                  isSelected: _selectedUserType == user['type'],
                  onTap: () {
                    setState(() {
                      _selectedUserType = user['type'];
                    });
                  },
                ))),
                
                const SizedBox(height: 32),
                
                // Login Button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedUserType != null ? _handleLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.isLoading) {
                          return const CircularProgressIndicator();
                        }
                        return Text(
                          'Start Journey',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Demo Mode - All accounts are for demonstration purposes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  final String type;
  final String name;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.type,
    required this.name,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.white 
            : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.7),
                    ),
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