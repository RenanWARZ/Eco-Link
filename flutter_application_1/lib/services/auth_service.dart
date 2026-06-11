import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService extends ChangeNotifier {
  static const _storageKey = 'ecolink_user';

  User? _currentUser;
  bool _initialized = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get initialized => _initialized;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        _currentUser = null;
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<User> login({
    required String name,
    required String email,
    required UserRole role,
  }) async {
    final payload = User(
      openId: email.trim().toLowerCase(),
      name: name.trim(),
      email: email.trim(),
      role: role,
      loginMethod: 'local',
    );
    final user = await UserService.createOrUpdate(payload);
    _currentUser = user;
    await _persist(user);
    notifyListeners();
    return user;
  }

  Future<void> refreshUser() async {
    final id = _currentUser?.id;
    if (id == null) return;
    final user = await UserService.getById(id);
    if (user != null) {
      _currentUser = user;
      await _persist(user);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }

  Future<void> _persist(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(user.toJson()));
  }
}
