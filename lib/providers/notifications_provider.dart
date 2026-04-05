import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // transfer, receive, payment, deposit, security, promo, system
  bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class NotificationsProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final List<AppNotification> _notifications = [];
  bool _isLoading = false;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;
  bool get isLoading => _isLoading;

  String? get _userId => _supabase.auth.currentUser?.id;

  // تحميل الإشعارات من Supabase
  Future<void> loadNotifications() async {
    final userId = _userId;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      _notifications.clear();
      _notifications.addAll(
        (data as List).map((row) => AppNotification.fromJson(row)),
      );
    } catch (e) {
      // إذا فشل التحميل نبقي القائمة كما هي
    }

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !_notifications[idx].isRead) {
      _notifications[idx].isRead = true;
      notifyListeners();

      // تحديث في Supabase
      try {
        await _supabase
            .from('notifications')
            .update({'is_read': true})
            .eq('id', id);
      } catch (_) {}
    }
  }

  void markAllAsRead() async {
    final userId = _userId;
    bool changed = false;
    for (final n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();

      // تحديث في Supabase
      if (userId != null) {
        try {
          await _supabase
              .from('notifications')
              .update({'is_read': true})
              .eq('user_id', userId)
              .eq('is_read', false);
        } catch (_) {}
      }
    }
  }

  void remove(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();

    try {
      await _supabase.from('notifications').delete().eq('id', id);
    } catch (_) {}
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // إعادة تعيين عند تسجيل الخروج
  void reset() {
    _notifications.clear();
    notifyListeners();
  }
}
