# TravelShield - Architecture Plan

## App Overview

TravelShield is a comprehensive travel safety application with Digital Tourist ID, SOS functionality, geofencing alerts, AI travel assistance, and role-based access control.

## Core Features

### 1. Digital Tourist ID
- Digital ID wallet screen
- Name, nationality, trip duration, and emergency contact
- Secure local storage using flutter_secure_storage
- Documents-focused identity information

### 2. SOS Emergency Assistance
- Prominent SOS action on the dashboard
- Location capture using geolocator
- Emergency alert logging
- Local notifications for emergency contacts

### 3. Geo-Fencing Alerts
- Geofence integration
- Predefined restricted zones
- Warnings when entering restricted areas
- Incident logging

### 4. Role-Based Access Control
- Tourist
- Police / Responder
- Tourism Admin

Tourists access the safety features, police responders manage incidents and emergency location information, and tourism administrators access analytics and heatmaps.

## UI / UX Structure

### Screens
1. Login
2. Dashboard
3. Digital Tourist ID
4. Safety Map
5. AI Assistant
6. Profile
7. Police Dashboard
8. Admin Dashboard

### Navigation
- Bottom navigation: Dashboard, Wallet, Map, AI Assistant
- Profile in the dashboard header
- Prominent SOS control on the dashboard
- AI Assistant quick access

## Technical Implementation

### Project Structure

See the repository `lib/` structure documented in [README.md](README.md).

### Key Dependencies

- provider: State management
- geolocator: Location services
- google_maps_flutter / flutter_map: Maps
- flutter_secure_storage: secure local storage
- flutter_local_notifications: emergency notifications
- geofence_service: geofencing
- permission_handler: runtime permissions

## Privacy & Security

- DID information stored using secure storage
- Permission-based location and notification access
- Role-based access controls
- Selective data sharing

## Implementation Priorities

1. Core models and services
2. Authentication and role management
3. Dashboard and SOS functionality
4. Digital Tourist ID
5. Geofencing and safety map
6. AI assistant
7. Police and admin dashboards
8. Testing and error handling
