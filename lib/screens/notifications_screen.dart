import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notifications_provider.dart';
import '../utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context);
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('الإشعارات',
                style: TextStyle(fontFamily: 'Cairo')),
            if (provider.unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${provider.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (provider.hasUnread)
            TextButton(
              onPressed: provider.markAllAsRead,
              child: const Text(
                'قراءة الكل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyNotifications()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              itemCount: notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSizes.paddingS),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _NotificationCard(
                  notification: notif,
                  onTap: () => provider.markAsRead(notif.id),
                  onDismiss: () => provider.remove(notif.id),
                );
              },
            ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded,
              size: 80, color: AppColors.lightGrey),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius:
              BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.white
                : AppColors.primaryBlue.withValues(alpha: 0.04),
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadiusLarge),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : AppColors.primaryBlue.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(notification.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (notification.type) {
      case 'transfer':
        return AppColors.primaryBlue;
      case 'receive':
        return AppColors.success;
      case 'payment':
        return const Color(0xFFFFB300);
      case 'deposit':
        return AppColors.success;
      case 'security':
        return AppColors.error;
      case 'promo':
        return AppColors.accentYellow;
      default:
        return AppColors.grey;
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'transfer':
        return Icons.send_rounded;
      case 'receive':
        return Icons.move_to_inbox_rounded;
      case 'payment':
        return Icons.receipt_rounded;
      case 'deposit':
        return Icons.add_circle_outline_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return DateFormat('dd/MM/yyyy').format(dt);
  }
}
