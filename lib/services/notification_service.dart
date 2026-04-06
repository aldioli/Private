import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final _supabase = Supabase.instance.client;

  // تهيئة الإشعارات
  static Future<void> initialize() async {
    // طلب إذن الإشعارات
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // حفظ الـ token
    await saveToken();

    // تحديث الـ token عند تغييره
    _messaging.onTokenRefresh.listen((token) {
      _saveTokenToSupabase(token);
    });

    // إشعار عند فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('تم فتح التطبيق من إشعار: ${message.notification?.title}');
    });

    // إشعار والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('إشعار جديد: ${message.notification?.title}');
    });
  }

  // حفظ الـ FCM token في Supabase
  static Future<void> saveToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }
    } catch (e) {
      debugPrint('خطأ في حفظ token: $e');
    }
  }

  static Future<void> _saveTokenToSupabase(String token) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('profiles')
          .update({'fcm_token': token})
          .eq('id', userId);
    } catch (e) {
      debugPrint('خطأ في حفظ token في Supabase: $e');
    }
  }

  // إرسال إشعار لمستخدم آخر عبر Supabase Edge Function
  static Future<void> sendNotification({
    required String toUserId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      await _supabase.functions.invoke(
        'send-notification',
        body: {
          'to_user_id': toUserId,
          'title': title,
          'body': body,
          'data': data ?? {},
        },
      );
    } catch (e) {
      debugPrint('خطأ في إرسال الإشعار: $e');
    }
  }

  // إشعار تحويل مُرسَل
  static Future<void> notifyTransferSent({
    required String toUserId,
    required String toName,
    required double amount,
  }) async {
    await sendNotification(
      toUserId: toUserId,
      title: 'تحويل مالي',
      body: 'استلمت ${amount.toStringAsFixed(0)} ر.ي',
      data: {'type': 'transfer_received', 'amount': amount.toString()},
    );
  }

  // إشعار إيداع
  static Future<void> notifyDeposit({
    required String userId,
    required double amount,
  }) async {
    await sendNotification(
      toUserId: userId,
      title: 'إيداع ناجح',
      body: 'تم إيداع ${amount.toStringAsFixed(0)} ر.ي في حسابك',
      data: {'type': 'deposit', 'amount': amount.toString()},
    );
  }

  // إشعار سحب
  static Future<void> notifyWithdraw({
    required String userId,
    required double amount,
  }) async {
    await sendNotification(
      toUserId: userId,
      title: 'سحب ناجح',
      body: 'تم سحب ${amount.toStringAsFixed(0)} ر.ي من حسابك',
      data: {'type': 'withdraw', 'amount': amount.toString()},
    );
  }

  // إشعار دفع فاتورة
  static Future<void> notifyBillPaid({
    required String userId,
    required String billName,
    required double amount,
  }) async {
    await sendNotification(
      toUserId: userId,
      title: 'دفع فاتورة',
      body: 'تم دفع فاتورة $billName بمبلغ ${amount.toStringAsFixed(0)} ر.ي',
      data: {'type': 'bill_paid', 'amount': amount.toString()},
    );
  }
}
