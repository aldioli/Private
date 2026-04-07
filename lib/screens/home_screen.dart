import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_services.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/currency_rates.dart';
import '../widgets/promo_banner.dart';
import '../widgets/upcoming_payments_widget.dart';
import '../widgets/monthly_summary_widget.dart';
import '../widgets/pinned_shortcuts_widget.dart';
import 'notifications_screen.dart';
import 'qr_scan_screen.dart';
import '../services/api_service.dart';
import '../providers/notifications_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final notifProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    await Future.wait([
      walletProvider.loadWallet(),
      walletProvider.loadTransactions(),
      notifProvider.loadNotifications(),
    ]);
  }

  Future<void> _refresh() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final notifProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    await Future.wait([
      walletProvider.loadWallet(),
      walletProvider.loadTransactions(refresh: true),
      notifProvider.loadNotifications(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationsProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'مسح QR',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QrScanScreen()),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  );
                },
              ),
              if (notifProvider.hasUnread)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: notifProvider.unreadCount > 9 ? 18 : 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        notifProvider.unreadCount > 9
                            ? '9+'
                            : '${notifProvider.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بانر الوضع التجريبي
              if (ApiService.isDemoMode)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(
                        color: AppColors.accentYellow.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Color(0xFFB8860B), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'أنت في الوضع التجريبي — البيانات افتراضية',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xFFB8860B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // بطاقة الرصيد
              const BalanceCard(),
              const SizedBox(height: AppSizes.paddingL),

              // وصول سريع (اختصارات مخصصة)
              const PinnedShortcutsWidget(),
              const SizedBox(height: AppSizes.paddingL),

              // الخدمات السريعة
              const QuickServices(),
              const SizedBox(height: AppSizes.paddingL),

              // ملخص الشهر
              const MonthlySummaryWidget(),
              const SizedBox(height: AppSizes.paddingL),

              // بانر العروض
              const PromoBanner(),
              const SizedBox(height: AppSizes.paddingL),

              // أسعار العملات
              const CurrencyRates(),
              const SizedBox(height: AppSizes.paddingL),

              // دفعات قادمة
              const UpcomingPaymentsWidget(),
              const SizedBox(height: AppSizes.paddingL),

              // آخر المعاملات
              const RecentTransactions(),
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

}
