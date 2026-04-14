import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/notifications_provider.dart';
import '../utils/constants.dart';
import 'settings_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'referral_screen.dart';
import 'my_card_screen.dart';
import 'beneficiaries_screen.dart';
import 'account_level_screen.dart';
import 'kyc_screen.dart';
import 'offers_screen.dart';
import 'statement_screen.dart';
import 'support_screen.dart';
import 'exchange_screen.dart';
import 'agents_screen.dart';
import 'request_money_screen.dart';
import 'app_security_screen.dart';
import 'about_screen.dart';
import 'scheduled_payments_screen.dart';
import 'savings_screen.dart';
import 'split_bill_screen.dart';
import 'loyalty_screen.dart';
import 'help_center_screen.dart';
import 'notifications_settings_screen.dart';
import 'transactions_screen.dart';
import 'mobile_recharge_screen.dart';
import 'currency_converter_screen.dart';
import 'international_transfer_screen.dart';
import 'cards_screen.dart';
import 'donations_screen.dart';
import 'contact_us_screen.dart';
import 'investment_screen.dart';
import 'insurance_screen.dart';
import 'microfinance_screen.dart';
import 'vouchers_screen.dart';
import 'government_services_screen.dart';
import 'parcel_tracking_screen.dart';
import 'market_rates_screen.dart';
import 'budget_planner_screen.dart';
import 'e_commerce_screen.dart';
import 'food_delivery_screen.dart';
import 'ride_hailing_screen.dart';
import 'hotel_booking_screen.dart';
import 'flight_booking_screen.dart';
import 'business_account_screen.dart';
import 'friends_payments_screen.dart';
import 'subscriptions_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('حسابي', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, WalletProvider>(
        builder: (context, authProvider, walletProvider, _) {
          final user = authProvider.user;
          final wallet = walletProvider.wallet;

          return SingleChildScrollView(
            child: Column(
              children: [
                // رأس الملف الشخصي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.paddingXL),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Column(
                    children: [
                      // صورة الملف
                      Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryBlue.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user?.fullName.isNotEmpty == true
                                    ? user!.fullName[0].toUpperCase()
                                    : 'Y',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.accentYellow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Text(
                        user?.fullName ?? 'المستخدم',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phoneNumber ?? '',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      // شارة التحقق
                      if (user?.isVerified == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppColors.success.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified,
                                  color: AppColors.success, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'حساب موثق',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingS),

                // إحصائيات
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'رقم المحفظة',
                          value: wallet?.walletNumber ?? '---',
                          icon: Icons.account_balance_wallet_outlined,
                          color: AppColors.primaryBlue,
                          onTap: wallet?.walletNumber != null
                              ? () {
                                  Clipboard.setData(ClipboardData(
                                      text: wallet!.walletNumber));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('تم النسخ',
                                          style: TextStyle(
                                              fontFamily: 'Cairo')),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: _StatCard(
                          title: 'الحد اليومي المتبقي',
                          value:
                              '${(wallet?.remainingDailyLimit ?? 0).toStringAsFixed(0)} ريال',
                          icon: Icons.bar_chart_outlined,
                          color: AppColors.accentYellow,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // قائمة الخيارات
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'تعديل الملف الشخصي',
                        color: AppColors.primaryBlue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditProfileScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'تغيير كلمة المرور',
                        color: AppColors.warning,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.fingerprint_rounded,
                        title: 'تسجيل الدخول بالبصمة',
                        color: AppColors.success,
                        onTap: () => _showComingSoon(context),
                        trailing: Switch(
                          value: false,
                          onChanged: (_) => _showComingSoon(context),
                          activeColor: AppColors.primaryBlue,
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.workspace_premium_rounded,
                        title: 'مستوى حسابي',
                        color: const Color(0xFFFFD600),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const AccountLevelScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.credit_card_rounded,
                        title: 'بطاقتي الرقمية',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const MyCardScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.people_outline_rounded,
                        title: 'المستفيدون',
                        color: AppColors.success,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const BeneficiariesScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.qr_code_rounded,
                        title: 'رمز QR الخاص بي',
                        color: Colors.purple,
                        onTap: () => _showMyQR(context),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.card_giftcard_rounded,
                        title: 'ادعُ أصدقاءك',
                        color: AppColors.accentYellow,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ReferralScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.currency_exchange_rounded,
                        title: 'الصرافة',
                        color: const Color(0xFF388E3C),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const ExchangeScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.store_rounded,
                        title: 'الوكلاء والفروع',
                        color: const Color(0xFF8E24AA),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const AgentsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.verified_user_rounded,
                        title: 'توثيق الهوية (KYC)',
                        color: const Color(0xFF43E97B),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const KycScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.receipt_long_rounded,
                        title: 'كشف الحساب',
                        color: const Color(0xFF667EEA),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const StatementScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.local_offer_rounded,
                        title: 'العروض والمكافآت',
                        color: const Color(0xFFFA709A),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const OffersScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.support_agent_rounded,
                        title: 'الدعم الفني',
                        color: AppColors.info,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SupportScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.request_page_rounded,
                        title: 'طلب مبلغ',
                        color: const Color(0xFF00897B),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RequestMoneyScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.schedule_rounded,
                        title: 'الدفعات المجدولة',
                        color: const Color(0xFF5E35B1),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScheduledPaymentsScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.shield_rounded,
                        title: 'أمان التطبيق',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AppSecurityScreen()),
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.credit_card_outlined,
                        title: 'بطاقاتي',
                        color: const Color(0xFF1A237E),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const CardsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.flight_takeoff_rounded,
                        title: 'التحويل الدولي',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const InternationalTransferScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.phone_android_rounded,
                        title: 'شحن رصيد الهاتف',
                        color: const Color(0xFF00897B),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const MobileRechargeScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.currency_exchange_rounded,
                        title: 'محول العملات',
                        color: const Color(0xFF0097A7),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const CurrencyConverterScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.savings_rounded,
                        title: 'خطط الادخار',
                        color: const Color(0xFF00ACC1),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const SavingsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.call_split_rounded,
                        title: 'تقسيم الفاتورة',
                        color: const Color(0xFF43A047),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const SplitBillScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.stars_rounded,
                        title: 'نقاط الولاء',
                        color: const Color(0xFFFFA000),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const LoyaltyScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.receipt_long_outlined,
                        title: 'كل المعاملات',
                        color: const Color(0xFF667EEA),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const TransactionsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'إعدادات الإشعارات',
                        color: AppColors.info,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const NotificationsSettingsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.shopping_bag_rounded,
                        title: 'التسوق',
                        color: const Color(0xFF43A047),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const ECommerceScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.delivery_dining_rounded,
                        title: 'توصيل الطعام',
                        color: const Color(0xFFE53935),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const FoodDeliveryScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.local_taxi_rounded,
                        title: 'حجز رحلة (تاكسي)',
                        color: const Color(0xFF0097A7),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const RideHailingScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.hotel_rounded,
                        title: 'حجز فنادق',
                        color: const Color(0xFF1A237E),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const HotelBookingScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.flight_takeoff_rounded,
                        title: 'حجز طيران',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const FlightBookingScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'مخطط الميزانية',
                        color: const Color(0xFF43A047),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const BudgetPlannerScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.show_chart_rounded,
                        title: 'أسعار الصرف والسوق',
                        color: const Color(0xFF1B5E20),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const MarketRatesScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.local_shipping_rounded,
                        title: 'تتبع الشحنات',
                        color: const Color(0xFF0097A7),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const ParcelTrackingScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'الخدمات الحكومية',
                        color: const Color(0xFF5E35B1),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const GovernmentServicesScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.confirmation_number_rounded,
                        title: 'قسائم الخصم',
                        color: const Color(0xFFFA709A),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const VouchersScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.account_balance_rounded,
                        title: 'التمويل والقروض',
                        color: const Color(0xFF1B5E20),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const MicrofinanceScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.health_and_safety_rounded,
                        title: 'التأمين',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const InsuranceScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.trending_up_rounded,
                        title: 'الاستثمار',
                        color: const Color(0xFF1B5E20),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const InvestmentScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.favorite_rounded,
                        title: 'التبرعات والصدقات',
                        color: const Color(0xFFE53935),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const DonationsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.people_alt_rounded,
                        title: 'مدفوعات الأصدقاء',
                        color: const Color(0xFF00897B),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const FriendsPaymentsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.subscriptions_rounded,
                        title: 'اشتراكاتي',
                        color: const Color(0xFF7B1FA2),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const SubscriptionsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.business_center_rounded,
                        title: 'الحساب التجاري',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const BusinessAccountScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.headset_mic_rounded,
                        title: 'تواصل معنا',
                        color: AppColors.primaryBlue,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const ContactUsScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'مركز المساعدة',
                        color: const Color(0xFF546E7A),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const HelpCenterScreen())),
                      ),
                      const Divider(height: 1, indent: 60),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        title: 'حول التطبيق',
                        color: AppColors.grey,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutScreen()),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // زر تسجيل الخروج
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: () => _handleLogout(context, authProvider,
                          walletProvider),
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.error),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: AppColors.error,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingXL),

                Text(
                  'Beepay v${AppConstants.appVersion}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontFamily: 'Cairo',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('قريباً...', style: TextStyle(fontFamily: 'Cairo')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMyQR(BuildContext context) {
    final walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رمز QR الخاص بي',
            style: TextStyle(fontFamily: 'Cairo'),
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primaryBlue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: QrImageView(
                data: walletProvider.wallet?.walletNumber ?? 'Beepay',
                version: QrVersions.auto,
                size: 180,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.primaryBlue,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              walletProvider.wallet?.walletNumber ?? '',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اعرض هذا الرمز للدفع أو الاستلام',
              style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الدعم الفني',
            style: TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SupportRow(
                icon: Icons.phone, label: AppConstants.supportPhone),
            _SupportRow(
                icon: Icons.email, label: AppConstants.supportEmail),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthProvider authProvider,
    WalletProvider walletProvider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج',
            style: TextStyle(fontFamily: 'Cairo')),
        content: const Text(
          'هل تريد تسجيل الخروج من حسابك؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('خروج',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authProvider.logout();
      walletProvider.reset();
      if (context.mounted) {
        Provider.of<NotificationsProvider>(context, listen: false).reset();
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (onTap != null)
              const Text(
                'انقر للنسخ',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.grey),
    );
  }
}

class _SupportRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SupportRow({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
