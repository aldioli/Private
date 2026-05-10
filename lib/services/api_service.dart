import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/user.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import 'encryption_service.dart';

// خدمة الاتصال بالسيرفر
class ApiService {
  static const String baseUrl = AppConstants.baseUrl;
  static String? _authToken;

  // ========== وضع تجريبي ==========
  static bool _demoMode = false;
  static double _demoBalance = 150500.0;
  static double _demoUsedLimit = 50000.0;
  static User? _demoUser;

  static final List<Transaction> _demoTransactions = [
    Transaction(
      id: 'TXN001',
      type: 'deposit',
      amount: 200000,
      status: 'completed',
      description: 'إيداع نقدي',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 'TXN002',
      type: 'transfer',
      amount: 15000,
      status: 'completed',
      toWallet: '120000000002',
      recipientName: 'محمد أحمد السلامي',
      description: 'تحويل شخصي',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 'TXN003',
      type: 'payment',
      amount: 8500,
      status: 'completed',
      description: 'فاتورة كهرباء - يناير',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 'TXN004',
      type: 'transfer',
      amount: 25000,
      status: 'completed',
      fromWallet: '120000000003',
      recipientName: 'خالد عبدالله المقرمي',
      description: 'استلام تحويل',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      completedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: 'TXN005',
      type: 'withdrawal',
      amount: 30000,
      status: 'completed',
      description: 'سحب نقدي',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      completedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Transaction(
      id: 'TXN006',
      type: 'payment',
      amount: 3000,
      status: 'completed',
      description: 'شحن رصيد - يمن موبايل',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      completedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Transaction(
      id: 'TXN007',
      type: 'deposit',
      amount: 50000,
      status: 'completed',
      description: 'إيداع بنكي',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      completedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Transaction(
      id: 'TXN008',
      type: 'payment',
      amount: 4200,
      status: 'completed',
      description: 'فاتورة مياه - ديسمبر',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      completedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  static bool get isDemoMode => _demoMode;

  static void enableDemoMode() {
    _demoMode = true;
    _authToken = 'demo_token';
    _demoUser = User(
      id: 'demo_001',
      fullName: 'أحمد علي الحمدي',
      phoneNumber: '+967777123456',
      walletNumber: '120000000001',
      email: 'ahmed@beepay.ye',
      isVerified: true,
      createdAt: DateTime(2024, 1, 15),
    );
  }

  static void disableDemoMode() {
    _demoMode = false;
    _authToken = null;
    _demoUser = null;
    _demoBalance = 150500.0;
    _demoUsedLimit = 50000.0;
  }

  // ========== نهاية وضع تجريبي ==========

  // تعيين التوكن
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // مسح التوكن
  static void clearAuthToken() {
    _authToken = null;
  }

  // الحصول على الهيدرز
  static Map<String, String> _getHeaders({bool withAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }
  
  // ========== التسجيل والدخول ==========
  
  // تسجيل حساب جديد
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String pin,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      _demoUser = User(
        id: 'demo_new_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName,
        phoneNumber: phoneNumber,
        walletNumber:
            '12${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        isVerified: false,
        createdAt: DateTime.now(),
      );
      return {
        'token': 'demo_token',
        'user': _demoUser!.toJson(),
      };
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(withAuth: false),
        body: jsonEncode({
          'full_name': fullName,
          'phone_number': phoneNumber,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('فشل التسجيل: ${response.body}');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String pin,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return {
        'token': 'demo_token',
        'user': _demoUser!.toJson(),
      };
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(withAuth: false),
        body: jsonEncode({
          'phone_number': phoneNumber,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        throw Exception('رقم الهاتف أو الرقم السري غير صحيح');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }
  
  // إرسال OTP
  static Future<bool> sendOTP(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: _getHeaders(withAuth: false),
        body: jsonEncode({
          'phone_number': phoneNumber,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('خطأ في إرسال الرمز: $e');
    }
  }
  
  // التحقق من OTP
  static Future<bool> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: _getHeaders(withAuth: false),
        body: jsonEncode({
          'phone_number': phoneNumber,
          'otp': otp,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('خطأ في التحقق: $e');
    }
  }
  
  // ========== المحفظة ==========
  
  // الحصول على معلومات المحفظة
  static Future<Wallet> getWallet() async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return Wallet(
        walletNumber: _demoUser?.walletNumber ?? '120000000001',
        balance: _demoBalance,
        dailyLimit: 1000000.0,
        usedDailyLimit: _demoUsedLimit,
        isActive: true,
        lastUpdate: DateTime.now(),
      );
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Wallet.fromJson(data['wallet']);
      } else {
        throw Exception('فشل الحصول على بيانات المحفظة');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // الحصول على الرصيد
  static Future<double> getBalance() async {
    if (_demoMode) return _demoBalance;
    try {
      final wallet = await getWallet();
      return wallet.balance;
    } catch (e) {
      throw Exception('خطأ في الحصول على الرصيد: $e');
    }
  }
  
  // ========== المعاملات ==========
  
  // تحويل أموال
  static Future<Transaction> transfer({
    required String toWallet,
    required double amount,
    required String pin,
    String? description,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (amount > _demoBalance) {
        throw Exception('رصيدك غير كافٍ');
      }
      _demoBalance -= amount;
      _demoUsedLimit += amount;
      final txn = Transaction(
        id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        type: 'transfer',
        amount: amount,
        status: 'completed',
        toWallet: toWallet,
        recipientName: 'مستخدم Beepay',
        description: description ?? 'تحويل',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      _demoTransactions.insert(0, txn);
      return txn;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/transfer'),
        headers: _getHeaders(),
        body: jsonEncode({
          'to_wallet': toWallet,
          'amount': amount,
          'pin': EncryptionService.hashPin(pin),
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Transaction.fromJson(data['transaction']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'فشل التحويل');
      }
    } catch (e) {
      throw Exception('خطأ في التحويل: $e');
    }
  }

  // طلب سحب
  static Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    required String pin,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (amount > _demoBalance) {
        throw Exception('رصيدك غير كافٍ');
      }
      _demoBalance -= amount;
      final txn = Transaction(
        id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        type: 'withdrawal',
        amount: amount,
        status: 'completed',
        description: 'سحب نقدي',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      _demoTransactions.insert(0, txn);
      return {'success': true, 'reference': 'WD${DateTime.now().millisecondsSinceEpoch}'};
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/withdrawal'),
        headers: _getHeaders(),
        body: jsonEncode({
          'amount': amount,
          'pin': EncryptionService.hashPin(pin),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('فشل طلب السحب');
      }
    } catch (e) {
      throw Exception('خطأ في السحب: $e');
    }
  }

  // دفع فاتورة
  static Future<Transaction> payBill({
    required String billType,
    required String accountNumber,
    required double amount,
    required String pin,
    String? description,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (amount > _demoBalance) {
        throw Exception('رصيدك غير كافٍ');
      }
      _demoBalance -= amount;
      final txn = Transaction(
        id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        type: 'payment',
        amount: amount,
        status: 'completed',
        description: description ?? 'دفع فاتورة $billType',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      _demoTransactions.insert(0, txn);
      return txn;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/pay-bill'),
        headers: _getHeaders(),
        body: jsonEncode({
          'bill_type': billType,
          'account_number': accountNumber,
          'amount': amount,
          'pin': EncryptionService.hashPin(pin),
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Transaction.fromJson(data['transaction']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'فشل الدفع');
      }
    } catch (e) {
      throw Exception('خطأ في الدفع: $e');
    }
  }

  // إيداع رصيد (demo)
  static Future<Transaction> deposit({
    required double amount,
    required String method,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      _demoBalance += amount;
      final txn = Transaction(
        id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        type: 'deposit',
        amount: amount,
        status: 'completed',
        description: 'إيداع - $method',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      _demoTransactions.insert(0, txn);
      return txn;
    }
    throw Exception('غير متاح بعد');
  }

  // الحصول على سجل المعاملات
  static Future<List<Transaction>> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return List.from(_demoTransactions);
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions?page=$page&limit=$limit'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List transactions = data['transactions'] ?? [];
        return transactions.map((t) => Transaction.fromJson(t)).toList();
      } else {
        throw Exception('فشل الحصول على المعاملات');
      }
    } catch (e) {
      throw Exception('خطأ في الحصول على المعاملات: $e');
    }
  }
  
  // ========== معلومات المستخدم ==========
  
  // الحصول على معلومات المستخدم
  static Future<User> getUserProfile() async {
    if (_demoMode && _demoUser != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _demoUser!;
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('فشل الحصول على معلومات المستخدم');
      }
    } catch (e) {
      throw Exception('خطأ في الحصول على البيانات: $e');
    }
  }

  // التحقق من رقم محفظة
  static Future<Map<String, dynamic>> checkWalletNumber(
      String walletNumber) async {
    if (_demoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (walletNumber.length >= 10) {
        return {'name': 'مستخدم Beepay', 'wallet_number': walletNumber};
      }
      throw Exception('رقم المحفظة غير موجود');
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/check'),
        headers: _getHeaders(),
        body: jsonEncode({
          'wallet_number': walletNumber,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('رقم المحفظة غير موجود');
      }
    } catch (e) {
      throw Exception('خطأ في التحقق: $e');
    }
  }
}
