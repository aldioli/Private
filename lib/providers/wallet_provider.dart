import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../services/notification_service.dart';

class WalletProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Wallet? _wallet;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get balance => _wallet?.balance ?? 0.0;

  String? get _userId => _supabase.auth.currentUser?.id;

  // تحميل بيانات المحفظة (الرصيد) من Supabase
  Future<void> loadWallet() async {
    final userId = _userId;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('profiles')
          .select('balance, phone')
          .eq('id', userId)
          .single();

      final phone = (data['phone'] ?? '').toString().replaceAll('+', '');
      _wallet = Wallet(
        walletNumber: phone,
        balance: (data['balance'] ?? 0).toDouble(),
        lastUpdate: DateTime.now(),
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'خطأ في تحميل بيانات المحفظة';
    }

    _isLoading = false;
    notifyListeners();
  }

  // تحديث الرصيد فقط
  Future<void> refreshBalance() async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final data = await _supabase
          .from('profiles')
          .select('balance')
          .eq('id', userId)
          .single();

      if (_wallet != null) {
        _wallet = _wallet!.copyWith(
          balance: (data['balance'] ?? 0).toDouble(),
          lastUpdate: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      // تجاهل أخطاء التحديث الصامت
    }
  }

  // تحميل المعاملات من Supabase
  Future<void> loadTransactions({bool refresh = false}) async {
    final userId = _userId;
    if (userId == null) return;
    if (!refresh && _transactions.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('transactions')
          .select(
              '*, sender:profiles!sender_id(full_name, phone), receiver:profiles!receiver_id(full_name, phone)')
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .order('created_at', ascending: false)
          .limit(50);

      _transactions =
          (data as List).map((row) => Transaction.fromSupabase(row, userId)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'خطأ في تحميل المعاملات';
    }

    _isLoading = false;
    notifyListeners();
  }

  // التحقق من رقم محفظة (بحث بالهاتف)
  Future<Map<String, dynamic>?> checkWalletNumber(String walletNumber) async {
    try {
      final phone = '+$walletNumber';
      final data = await _supabase
          .from('profiles')
          .select('full_name, phone')
          .eq('phone', phone)
          .maybeSingle();

      if (data != null) {
        return {'name': data['full_name'], 'phone': data['phone']};
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // إجراء تحويل عبر Supabase RPC
  Future<bool> makeTransfer({
    required String toWallet,
    required double amount,
    required String pin,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final receiverPhone = '+$toWallet';

      await _supabase.rpc('transfer_money', params: {
        'p_receiver_phone': receiverPhone,
        'p_amount': amount,
        'p_note': description ?? '',
      });

      // جلب ID المستلم لإرسال الإشعار
      try {
        final receiver = await _supabase
            .from('profiles')
            .select('id, full_name')
            .eq('phone', receiverPhone)
            .single();

        final senderProfile = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', _supabase.auth.currentUser!.id)
            .single();
        final senderName = senderProfile['full_name'] ?? 'مستخدم';
        await NotificationService.sendNotification(
          toUserId: receiver['id'],
          title: 'تحويل مالي جديد 💰',
          body: 'استلمت ${amount.toStringAsFixed(0)} ر.ي من $senderName',
          data: {'type': 'transfer_received'},
        );
      } catch (_) {}

      // تحديث الرصيد والمعاملات
      await refreshBalance();
      await loadTransactions(refresh: true);

      _isLoading = false;
      notifyListeners();
      return true;
    } on PostgrestException catch (e) {
      _errorMessage = e.message.contains('رصيدك')
          ? 'رصيدك غير كافٍ'
          : e.message.contains('غير موجود')
              ? 'رقم المحفظة غير موجود'
              : 'فشل التحويل';
    } catch (e) {
      _errorMessage = 'فشل التحويل، حاول مجدداً';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // طلب سحب - يُخزَّن في Supabase وينتظر موافقة الوكيل
  Future<Map<String, dynamic>?> requestWithdrawal({
    required double amount,
    required String pin,
  }) async {
    final userId = _userId;
    if (userId == null) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (balance < amount) {
        _errorMessage = 'رصيدك غير كافٍ';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final ref = 'WD${DateTime.now().millisecondsSinceEpoch}';
      await _supabase.from('transaction_requests').insert({
        'user_id': userId,
        'type': 'withdrawal',
        'amount': amount,
        'status': 'pending',
        'note': ref,
      });

      // إشعار السحب
      await NotificationService.sendNotification(
        toUserId: userId,
        title: 'طلب سحب 💸',
        body: 'تم تسجيل طلب سحب ${amount.toStringAsFixed(0)} ر.ي بنجاح',
        data: {'type': 'withdraw'},
      );

      _isLoading = false;
      notifyListeners();
      return {'success': true, 'reference': ref};
    } catch (e) {
      _errorMessage = 'خطأ في طلب السحب';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // طلب إيداع - يُخزَّن في Supabase وينتظر موافقة الوكيل
  Future<bool> depositDemo({
    required double amount,
    required String method,
  }) async {
    final userId = _userId;
    if (userId == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabase.from('transaction_requests').insert({
        'user_id': userId,
        'type': 'deposit',
        'amount': amount,
        'status': 'pending',
        'note': method,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'خطأ في طلب الإيداع';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // دفع فاتورة (تجريبي - يحتاج ربط مع مزودي الخدمة)
  Future<bool> payBill({
    required String billType,
    required String accountNumber,
    required double amount,
    required String pin,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // إشعار دفع الفاتورة
      final userId = _userId;
      if (userId != null) {
        await NotificationService.sendNotification(
          toUserId: userId,
          title: 'دفع فاتورة ✅',
          body: 'تم دفع فاتورة $billType بمبلغ ${amount.toStringAsFixed(0)} ر.ي',
          data: {'type': 'bill_paid'},
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'خطأ في دفع الفاتورة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // إعادة تعيين (عند تسجيل الخروج)
  void reset() {
    _wallet = null;
    _transactions = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
