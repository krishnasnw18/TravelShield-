# Wayfinder Bloom - Architecture Plan

## App Overview
Wayfinder Bloom is a comprehensive travel safety app with Digital Tourist ID, SOS functionality, geofencing alerts, and role-based access control.

## Core Features (MVP)

### 1. Digital Tourist ID (DID Wallet + Verifiable Credentials)
- Simple DID wallet screen displaying digital ID
- Contains: Name, Nationality, Trip Duration, Emergency Contact
- Uses flutter_secure_storage for secure local storage
- Documents-only approach (removing wallet/payment sections)

### 2. SOS Button (Emergency Triage)
- Prominent SOS button on dashboard screen (moved from emergency screen)
- Location capture using geolocator
- Emergency alert logging and UI feedback
- Local notifications for emergency contacts

### 3. Geo-Fencing Alerts
- Integration with geofence_service
- Predefined restricted zones (hardcoded coordinates)
- Popup warnings when entering restricted areas
- Incident logging system

### 4. Role-Based Access Control (RBAC)
- Three user roles: Tourist, Police/Responder, Tourism Admin
- Tourist: DID + SOS button + geofencing alerts
- Police: Incident list + tourist location tracking
- Admin: Heatmap + incident logs
- Role-based navigation and UI elements

## UI/UX Structure

### Screen Architecture
1. **Login Screen** - Role-based authentication
2. **Dashboard Screen** - Main hub with safety status, SOS button, weather
3. **Digital Wallet Screen** - Documents only (no payments)
4. **Safety Map Screen** - Geofencing and nearby services
5. **AI Assistant Screen** - Travel assistance chat
6. **Profile Screen** - Moved to top-right corner
7. **Police Dashboard** - Incident management
8. **Admin Dashboard** - Analytics and heatmaps

### Navigation Structure
- Bottom navigation: Dashboard, Wallet, Map, AI Assistant
- Profile icon in top-right corner of dashboard
- AI Assistant button at bottom-right corner (above bottom nav)
- Remove quick actions from dashboard
- SOS button prominent on dashboard

## Technical Implementation

### File Structure
```
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

### Key Dependencies
- provider: State management
- geolocator: Location tracking
- google_maps_flutter: Map views and clusters
- flutter_secure_storage: DID wallet simulation
- flutter_local_notifications: Emergency alerts
- geofence_service: Geofencing triggers
- permission_handler: Location/notification permissions

### Privacy & Security
- Local secure storage for DID data
- Encrypted storage using flutter_secure_storage
- Selective data sharing (simulated with logging)
- Location data handled with proper permissions

## Implementation Priority
1. Core models and services setup
2. Authentication and role management
3. Dashboard with SOS functionality
4. Digital wallet (documents only)
5. Geofencing and safety map
6. AI assistant interface
7. Police and admin dashboards
8. Testing and error handling