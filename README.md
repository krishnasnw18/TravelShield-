# TravelShield 
![travelshield](https://github.com/user-attachments/assets/bd9eec3b-6870-4b75-9d7e-cb8ac3cf190e)

## Overview

**TravelShield** (formerly Wayfinder Bloom / VoyageGuard) is a comprehensive travel safety application designed to provide tourists with enhanced security and peace of mind. The app offers a secure digital ID, instant SOS assistance, real-time geofencing alerts, while enabling police responders to monitor incidents and tourism administrators to analyze safety data through cluster heatmaps.

## Key Features

### For Tourists
- **Digital Tourist ID (DID)**: Secure digital identity wallet with name, nationality, trip duration, and emergency contact information
- **SOS Emergency Button**: Instant emergency assistance with location capture and alert notifications
- **Geo-Fencing Alerts**: Real-time warnings when entering restricted or dangerous zones
- **Safety Map**: Interactive map showing nearby services and restricted areas
- **AI Travel Assistant**: Intelligent chat assistant for travel queries and guidance
- **Weather Information**: Current weather updates for travel planning

### For Police/Emergency Responders
- **Incident Dashboard**: Real-time view of all reported incidents
- **Tourist Location Tracking**: Monitor tourist locations during emergencies
- **Incident Management**: Review and respond to SOS alerts

### For Tourism Administrators
- **Analytics Dashboard**: Comprehensive overview of tourist safety metrics
- **Heatmap Visualization**: Cluster analysis of incident hotspots
- **Incident Logs**: Historical data for safety planning and policy-making

## User Interface
![A Tourist Safety App](https://github.com/user-attachments/assets/7d4c1701-ea1a-4907-94f4-815eb3e2fd8c)


## Technology Stack

- **Framework**: Flutter (Dart SDK ^3.6.0)
- **State Management**: Provider
- **Maps**: Google Maps Flutter, Flutter Map
- **Location Services**: Geolocator, Geofence Service
- **Storage**: Flutter Secure Storage (for DID wallet)
- **Notifications**: Flutter Local Notifications
- **UI/UX**: Material Design with Google Fonts

## Getting Started

### Prerequisites

- Flutter SDK (3.6.0 or higher)
- Dart SDK (3.6.0 or higher)
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/codygharte/TravelShield.git
   cd TravelShield
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API keys** (if required)
   - Add your Google Maps API key to:
     - `android/app/src/main/AndroidManifest.xml`
     - `ios/Runner/AppDelegate.swift`

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: Check `android/app/build.gradle`
- Enable location permissions in AndroidManifest.xml

#### iOS
- Update Info.plist with location usage descriptions
- Configure signing in Xcode

#### Web
- Web support is available for limited functionality
- Run with: `flutter run -d chrome`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme.dart                # App theme configuration
├── models/                   # Data models
│   ├── user.dart
│   ├── did.dart
│   ├── incident.dart
│   └── role.dart
├── services/                 # Business logic services
│   ├── auth_service.dart
│   ├── did_service.dart
│   ├── geofence_service.dart
│   ├── sos_service.dart
│   ├── notification_service.dart
│   └── location_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── location_provider.dart
│   └── incident_provider.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── wallet_screen.dart
│   ├── safety_map_screen.dart
│   ├── ai_assistant_screen.dart
│   ├── profile_screen.dart
│   ├── police_dashboard.dart
│   └── admin_dashboard.dart
└── widgets/                  # Reusable UI components
    ├── did_card.dart
    ├── sos_button.dart
    ├── incident_card.dart
    ├── safety_status_card.dart
    ├── weather_card.dart
    └── document_card.dart
```

## User Roles

The app supports three distinct user roles:

1. **Tourist**: Access to digital ID, SOS functionality, and safety features
2. **Police/Responder**: Incident management and tourist tracking
3. **Tourism Admin**: Analytics, heatmaps, and comprehensive incident logs

## Security & Privacy

- **Local Secure Storage**: All DID data is encrypted using flutter_secure_storage
- **Permission-Based Access**: Location and notification permissions are requested appropriately
- **Role-Based Access Control**: Feature access restricted based on user roles
- **Selective Data Sharing**: Users control what information is shared

## Development

### Building for Release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## Architecture

For detailed architecture documentation, see [architecture.md](architecture.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms specified in the repository.

## Support

For issues, questions, or contributions, please open an issue on the GitHub repository.

---

**Made with ❤️ for safer travel experiences**
