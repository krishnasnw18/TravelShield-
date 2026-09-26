import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wayfinder_bloom/providers/auth_provider.dart';
import 'package:wayfinder_bloom/providers/incident_provider.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSOSPress() async {
    if (_isPressed) return;
    
    setState(() => _isPressed = true);
    
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    // Get current user
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final incidentProvider = Provider.of<IncidentProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      // Trigger SOS
      final incident = await incidentProvider.triggerSOS(
        authProvider.currentUser!.id,
        authProvider.currentUser!.name,
      );
      
      if (incident != null && mounted) {
        // Show success dialog
        _showSOSConfirmation();
      }
    }
    
    setState(() => _isPressed = false);
  }

  void _showSOSConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '🆘 Alert Sent!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Your emergency alert has been sent successfully. Emergency services and your emergency contacts have been notified of your location.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: GestureDetector(
              onTap: _handleSOSPress,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isPressed 
                      ? [
                          Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                          Theme.of(context).colorScheme.error,
                        ]
                      : [
                          Theme.of(context).colorScheme.error,
                          Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                        ],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emergency,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SOS',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}