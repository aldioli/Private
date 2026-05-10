import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _pinSalt = 'beepay_secure_v1_';

  /// تشفير PIN بـ SHA-256 قبل الإرسال للسيرفر
  static String hashPin(String pin) {
    final bytes = utf8.encode(_pinSalt + pin);
    return sha256.convert(bytes).toString();
  }

  // ======== إدارة توكن المصادقة ========

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // ======== تخزين آمن عام ========

  static Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// مسح كل البيانات المحفوظة (عند تسجيل الخروج)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
