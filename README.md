# TravelShield

![TravelShield](https://github.com/user-attachments/assets/bd9eec3b-6870-4b75-9d7e-cb8ac3cf190e)

## Overview

**TravelShield** is a smart travel safety application designed to improve tourist security through digital identity, emergency assistance, location-aware safety features, and incident monitoring.

The application provides a unified safety platform for tourists, police/emergency responders, and tourism administrators.

## Key Features

### For Tourists
- **Digital Tourist ID (DID):** Secure digital identity wallet containing name, nationality, trip duration, and emergency contact information
- **SOS Emergency Button:** Instant emergency assistance with location capture and alert notifications
- **Geo-Fencing Alerts:** Warnings when entering predefined restricted or dangerous zones
- **Safety Map:** Interactive map for nearby services and restricted areas
- **AI Travel Assistant:** Travel guidance and assistance through an intelligent chat interface
- **Weather Information:** Weather updates for travel planning

### For Police / Emergency Responders
- **Incident Dashboard:** View reported safety incidents
- **Tourist Location Tracking:** Access tourist location information during emergencies
- **Incident Management:** Review and manage SOS alerts

### For Tourism Administrators
- **Analytics Dashboard:** Safety metrics and incident insights
- **Heatmap Visualization:** Identify incident hotspots
- **Incident Logs:** Historical records for safety analysis and planning

## User Interface

![TravelShield User Interface](https://github.com/user-attachments/assets/7d4c1701-ea1a-4907-94f4-815eb3e2fd8c)

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider
- **Maps:** Google Maps Flutter, Flutter Map
- **Location Services:** Geolocator, Geofence Service
- **Secure Storage:** Flutter Secure Storage
- **Notifications:** Flutter Local Notifications
- **Permissions:** Permission Handler
- **UI:** Material Design, Google Fonts

## Getting Started

### Prerequisites

- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / Xcode
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/krishnasnw18/TravelShield-.git
   cd TravelShield-
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API keys if required**

   Add the required Google Maps configuration to the Android and iOS platform files according to the Flutter project setup.

4. **Run the application**

   ```bash
   flutter run
   ```

## Project Structure

```text
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── user.dart
│   ├── did.dart
│   ├── incident.dart
│   └── role.dart
├── services/
│   ├── auth_service.dart
│   ├── did_service.dart
│   ├── geofence_service.dart
│   ├── sos_service.dart
│   ├── notification_service.dart
│   └── location_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── location_provider.dart
│   └── incident_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── wallet_screen.dart
│   ├── safety_map_screen.dart
│   ├── ai_assistant_screen.dart
│   ├── profile_screen.dart
│   ├── police_dashboard.dart
│   └── admin_dashboard.dart
└── widgets/
    ├── did_card.dart
    ├── sos_button.dart
    ├── incident_card.dart
    ├── safety_status_card.dart
    ├── weather_card.dart
    └── document_card.dart
```

## User Roles

1. **Tourist:** Digital ID, SOS, geofencing, map, AI assistant, and safety information
2. **Police / Responder:** Incident management and emergency location monitoring
3. **Tourism Admin:** Analytics, heatmaps, and incident logs

## Security & Privacy

- DID information is stored using Flutter Secure Storage
- Location and notification access is permission-based
- Role-based access controls restrict features by user role
- Selective information sharing is supported by the application design

## Building for Release

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## Testing

```bash
flutter test
```

## Code Analysis

```bash
flutter analyze
```

## Architecture

See [architecture.md](architecture.md) for the application architecture and implementation plan.

## License

See the repository license information.

---

Built with Flutter for safer travel experiences.
