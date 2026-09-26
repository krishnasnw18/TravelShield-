import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayfinder_bloom/models/user.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Sample users for demo
  static final List<User> _demoUsers = [
    User(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@tourist.com',
      role: UserRole.tourist,
      profileImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=john',
    ),
    User(
      id: '2',
      name: 'Officer Martinez',
      email: 'officer.martinez@police.gov',
      role: UserRole.police,
      profileImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=martinez',
    ),
    User(
      id: '3',
      name: 'Admin Sarah',
      email: 'sarah.admin@tourism.gov',
      role: UserRole.admin,
      profileImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=sarah',
    ),
  ];

  Future<bool> login(String email, String password) async {
    try {
      // Simple demo authentication - in real app, this would be server-side
      final user = _demoUsers.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('User not found'),
      );

      // Store user data securely
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
      
      // Set logged in status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    await _storage.delete(key: _userKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  List<User> getDemoUsers() => _demoUsers;
}