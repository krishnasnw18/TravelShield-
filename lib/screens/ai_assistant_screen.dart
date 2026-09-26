import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> 
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late AnimationController _typingController;
  bool _isTyping = false;

  // Quick action buttons
  final List<QuickAction> _quickActions = [
    QuickAction(
      icon: Icons.restaurant,
      label: 'Find restaurants',
      message: 'What are the best restaurants near India Gate?',
    ),
    QuickAction(
      icon: Icons.directions,
      label: 'Plan route',
      message: 'How do I get from Red Fort to Lotus Temple?',
    ),
    QuickAction(
      icon: Icons.security,
      label: 'Safety tips',
      message: 'Give me safety tips for traveling in Delhi',
    ),
    QuickAction(
      icon: Icons.help,
      label: 'Emergency help',
      message: 'What should I do in case of an emergency?',
    ),
    QuickAction(
      icon: Icons.wb_sunny,
      label: 'Weather update',
      message: 'What\'s the weather forecast for today?',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // Add welcome message
    _messages.add(ChatMessage(
      text: "Hello! I'm your AI travel assistant. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _generateAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('restaurant') || message.contains('food') || message.contains('eat')) {
      return "I found 5 highly-rated restaurants near India Gate:\n\n"
          "🍽️ **Karim's** - Famous for Mughlai cuisine\n"
          "📍 Jama Masjid • ⭐ 4.2 • 🚗 2.8 km\n\n"
          "🍽️ **Paranthe Wali Gali** - Traditional paranthas\n"
          "📍 Chandni Chowk • ⭐ 4.3 • 🚗 3.1 km\n\n"
          "🍽️ **Bukhara** - Fine dining, North Indian\n"
          "📍 ITC Maurya • ⭐ 4.8 • 🚗 8.2 km\n\n"
          "Would you like directions to any of these places?";
    } else if (message.contains('route') || message.contains('directions') || message.contains('get')) {
      return "Here's the best route from Red Fort to Lotus Temple:\n\n"
          "🚗 **By Car** (45 mins, 18.5 km)\n"
          "→ Head south on Netaji Subhash Marg\n"
          "→ Take Ring Road towards Lajpat Nagar\n"
          "→ Turn left at Kalkaji Extension\n\n"
          "🚇 **By Metro** (55 mins)\n"
          "→ Red Fort → Kashmere Gate (Red Line)\n"
          "→ Transfer to Violet Line\n"
          "→ Kashmere Gate → Kalkaji Mandir\n"
          "→ 5 min walk to Lotus Temple\n\n"
          "Current traffic is moderate. Safe travels! 🛡️";
    } else if (message.contains('safety') || message.contains('tip') || message.contains('secure')) {
      return "Here are essential safety tips for Delhi:\n\n"
          "🛡️ **General Safety**\n"
          "• Keep your digital documents secure in the app\n"
          "• Avoid displaying expensive items publicly\n"
          "• Stay in well-lit, populated areas after dark\n\n"
          "📱 **Emergency Contacts**\n"
          "• Police: 100 | Tourist Helpline: 1363\n"
          "• Women's Helpline: 181\n\n"
          "🚨 **Use SOS Feature**\n"
          "• Your SOS button is always available on the dashboard\n"
          "• It will share your exact location with authorities\n\n"
          "Remember, I'm monitoring restricted zones for your safety!";
    } else if (message.contains('emergency') || message.contains('help') || message.contains('sos')) {
      return "🚨 **In case of emergency:**\n\n"
          "1️⃣ **Use SOS Button** - Available on your dashboard\n"
          "   • Sends your location to emergency services\n"
          "   • Notifies your emergency contacts\n\n"
          "2️⃣ **Call Emergency Numbers:**\n"
          "   • Police: 100\n"
          "   • Fire: 101\n"
          "   • Ambulance: 108\n"
          "   • Tourist Helpline: 1363\n\n"
          "3️⃣ **Find Nearby Services:**\n"
          "   • Check the Safety Map tab\n"
          "   • Nearest hospital: AIIMS (2.8 km)\n"
          "   • Nearest police: CP Police Station (0.9 km)\n\n"
          "Stay calm and stay safe! I'm here to help. 🛡️";
    } else if (message.contains('weather') || message.contains('forecast')) {
      return "🌤️ **Today's Weather in Delhi:**\n\n"
          "Current: 28°C, Partly Cloudy\n"
          "High: 30°C | Low: 24°C\n"
          "Humidity: 65% | Wind: 12 km/h\n\n"
          "📅 **5-Day Forecast:**\n"
          "• Tomorrow: 30°C ☀️ Sunny\n"
          "• Thursday: 26°C ☁️ Cloudy\n"
          "• Friday: 25°C 🌧️ Light rain expected\n\n"
          "💡 **Travel Tips:**\n"
          "• Perfect weather for sightseeing today!\n"
          "• Carry an umbrella for Friday\n"
          "• Stay hydrated and use sunscreen";
    } else {
      return "I'm here to help with your travel needs! I can assist with:\n\n"
          "🍽️ Restaurant recommendations\n"
          "🗺️ Directions and routes\n"
          "🛡️ Safety tips and emergency info\n"
          "🌤️ Weather updates\n"
          "📱 Using app features\n"
          "🏛️ Tourist attractions info\n\n"
          "Try asking me about restaurants, directions, safety tips, or the weather!";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.smart_toy,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Travel Assistant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online • Ready to help',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text: "Hello! I'm your AI travel assistant. How can I help you today?",
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickActions.map((action) => 
                        _QuickActionButton(
                          action: action,
                          onPressed: () => _sendMessage(action.message),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _TypingIndicator(controller: _typingController);
                }
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about travel...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {
                          // Handle attachment
                        },
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () => _sendMessage(_messageController.text),
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

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class QuickAction {
  final IconData icon;
  final String label;
  final String message;

  QuickAction({
    required this.icon,
    required this.label,
    required this.message,
  });
}

class _QuickActionButton extends StatelessWidget {
  final QuickAction action;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(action.icon),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: onPressed,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 70,
            child: Text(
              action.label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: message.isUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: message.isUser 
                    ? const Radius.circular(4) 
                    : const Radius.circular(16),
                  bottomLeft: message.isUser 
                    ? const Radius.circular(16) 
                    : const Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class _TypingIndicator extends StatelessWidget {
  final AnimationController controller;

  const _TypingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(3, (index) => 
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final value = (controller.value + index * 0.2) % 1.0;
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: 0.3 + (0.4 * (1 - (value - 0.5).abs() * 2).clamp(0, 1)),
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}