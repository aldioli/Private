import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app_user;

class AuthProvider with ChangeNotifier {
  static const _supabaseUrl = 'https://wiqldyzkqsehfcwhakws.supabase.co';
  static const _serviceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpcWxkeXprcXNlaGZjd2hha3dzIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NTMxMDE0MCwiZXhwIjoyMDkwODg2MTQwfQ.nXX6JpU6oI184fnQ1lWMrhp9kNzfomOlkUL-qX6KdJ0';
  app_user.User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isGuest = false;
  String? _errorMessage;

  final _supabase = Supabase.instance.client;

  app_user.User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', session.user.id)
            .single();
        _user = app_user.User.fromJson(data);
        _isAuthenticated = true;
      }
    } catch (e) {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String phoneNumber, String pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final email = 'p${phoneNumber.replaceAll('+', '')}@gmail.com';
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: pin,
      );

      if (response.user != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();
        _user = app_user.User.fromJson(data);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      throw Exception('خطأ في تسجيل الدخول');
    } on AuthException catch (e) {
      _errorMessage = 'رقم الهاتف أو كلمة المرور غير صحيحة';
      if (e.message.contains('Email not confirmed')) {
        _errorMessage = 'يرجى تأكيد البريد الإلكتروني';
      }
    } catch (e) {
      final s = e.toString().toLowerCase();
      final isNetwork = s.contains('socketexception') ||
          s.contains('failed host') ||
          s.contains('connection refused') ||
          s.contains('network is unreachable') ||
          s.contains('failed to fetch') ||
          s.contains('clientexception') ||
          s.contains('xmlhttprequest') ||
          s.contains('net::err') ||
          s.contains('errno = 7') ||
          s.contains('errno = 101');
      if (isNetwork) {
        // خطأ شبكة — ارمِه للـ overlay حتى يُعيد المحاولة
        _isLoading = false;
        notifyListeners();
        rethrow;
      }
      _errorMessage = 'حدث خطأ، يرجى المحاولة مجدداً';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String nationalId,
    required String pin,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final email = 'p${phoneNumber.replaceAll('+', '')}@gmail.com';

      // استخدام Admin API لتجاوز email rate limit
      final adminResponse = await http.post(
        Uri.parse('$_supabaseUrl/auth/v1/admin/users'),
        headers: {
          'Authorization': 'Bearer $_serviceRoleKey',
          'apikey': _serviceRoleKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': pin,
          'email_confirm': true,
          'user_metadata': {
            'full_name': fullName,
            'phone': phoneNumber,
            'national_id': nationalId,
          },
        }),
      );

      if (adminResponse.statusCode == 200 || adminResponse.statusCode == 201) {
        // تسجيل الدخول تلقائياً بعد إنشاء الحساب
        final loginResponse = await _supabase.auth.signInWithPassword(
          email: email,
          password: pin,
        );

        if (loginResponse.user != null) {
          // حفظ national_id في profiles
          await _supabase
              .from('profiles')
              .update({'national_id': nationalId})
              .eq('id', loginResponse.user!.id);

          await Future.delayed(const Duration(milliseconds: 500));
          await loadUserData();
          if (_user == null) {
            _user = app_user.User(
              id: loginResponse.user!.id,
              fullName: fullName,
              phoneNumber: phoneNumber,
              nationalId: nationalId,
              balance: 0,
            );
          }
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } else {
        final body = jsonDecode(adminResponse.body);
        final msg = body['msg'] ?? body['message'] ?? '';
        if (msg.toString().contains('already registered') ||
            adminResponse.statusCode == 422) {
          _errorMessage = 'رقم الهاتف مسجل مسبقاً';
        } else {
          _errorMessage = 'فشل التسجيل';
        }
      }

    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('profiles_national_id_unique') ||
          errStr.contains('23505')) {
        _errorMessage = 'رقم الهوية مسجل مسبقاً بحساب آخر';
      } else {
        _errorMessage = 'حدث خطأ، يرجى المحاولة مجدداً';
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void loginAsGuest() {
    _user = app_user.User(
      id: 'guest_001',
      fullName: 'أحمد علي الحمدي',
      phoneNumber: '+967777123456',
      walletNumber: '120000000001',
      balance: 150500,
      isVerified: true,
    );
    _isAuthenticated = true;
    _isGuest = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.signOut();
      _user = null;
      _isAuthenticated = false;
      _isGuest = false;
    } catch (e) {
      // ignore
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
