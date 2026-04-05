import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _transactionAlerts = true;
  bool _marketingNotifs = false;
  bool _biometricEnabled = false;
  bool _loaded = false;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get transactionAlerts => _transactionAlerts;
  bool get marketingNotifs => _marketingNotifs;
  bool get biometricEnabled => _biometricEnabled;
  bool get loaded => _loaded;

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _notificationsEnabled = prefs.getBool('notif_enabled') ?? true;
    _transactionAlerts = prefs.getBool('notif_transactions') ?? true;
    _marketingNotifs = prefs.getBool('notif_marketing') ?? false;
    _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', value);
  }

  Future<void> setTransactionAlerts(bool value) async {
    _transactionAlerts = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_transactions', value);
  }

  Future<void> setMarketingNotifs(bool value) async {
    _marketingNotifs = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_marketing', value);
  }

  Future<void> setBiometric(bool value) async {
    _biometricEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
  }
}
