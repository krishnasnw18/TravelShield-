import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  // Demo weather data
  static final Map<String, dynamic> _demoWeather = {
    'temperature': 28,
    'condition': 'Partly Cloudy',
    'humidity': 65,
    'windSpeed': 12,
    'icon': Icons.wb_cloudy,
    'forecast': [
      {'day': 'Today', 'high': 28, 'low': 22, 'icon': Icons.wb_cloudy},
      {'day': 'Tomorrow', 'high': 30, 'low': 24, 'icon': Icons.wb_sunny},
      {'day': 'Thursday', 'high': 26, 'low': 20, 'icon': Icons.cloud},
      {'day': 'Friday', 'high': 25, 'low': 19, 'icon': Icons.grain},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weather Forecast',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                _demoWeather['icon'] as IconData,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_demoWeather['temperature']}°C',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text(
                      _demoWeather['condition'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _WeatherDetail(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${_demoWeather['humidity']}%',
                ),
              ),
              Expanded(
                child: _WeatherDetail(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${_demoWeather['windSpeed']} km/h',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '5-Day Forecast',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (_demoWeather['forecast'] as List<Map<String, dynamic>>)
                  .map((day) => _ForecastItem(
                        day: day['day'],
                        high: day['high'],
                        low: day['low'],
                        icon: day['icon'],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final String day;
  final int high;
  final int low;
  final IconData icon;

  const _ForecastItem({
    required this.day,
    required this.high,
    required this.low,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
            '$high°',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$low°',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}