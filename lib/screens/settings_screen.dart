import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import 'change_password_screen.dart';
import 'faq_screen.dart';
import 'referral_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
      ),
      body: !settings.loaded
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppColors.primaryBlue))
          : ListView(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              children: [
                // الإشعارات
                _SectionHeader(title: 'الإشعارات'),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.notifications_rounded,
                      title: 'الإشعارات',
                      subtitle: 'تفعيل/إيقاف جميع الإشعارات',
                      color: AppColors.primaryBlue,
                      value: settings.notificationsEnabled,
                      onChanged: (v) => settings.setNotificationsEnabled(v),
                    ),
                    const Divider(height: 1, indent: 60),
                    _SwitchTile(
                      icon: Icons.receipt_long_rounded,
                      title: 'إشعارات المعاملات',
                      subtitle: 'إشعار عند كل عملية تحويل أو إيداع',
                      color: AppColors.success,
                      value: settings.transactionAlerts && settings.notificationsEnabled,
                      onChanged: settings.notificationsEnabled
                          ? (v) => settings.setTransactionAlerts(v)
                          : null,
                    ),
                    const Divider(height: 1, indent: 60),
                    _SwitchTile(
                      icon: Icons.campaign_rounded,
                      title: 'إشعارات ترويجية',
                      subtitle: 'عروض وخدمات جديدة',
                      color: AppColors.warning,
                      value: settings.marketingNotifs && settings.notificationsEnabled,
                      onChanged: settings.notificationsEnabled
                          ? (v) => settings.setMarketingNotifs(v)
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),

                // الأمان
                _SectionHeader(title: 'الأمان والخصوصية'),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.fingerprint_rounded,
                      title: 'البصمة / Face ID',
                      subtitle: 'تسجيل الدخول بالمقاييس الحيوية',
                      color: AppColors.success,
                      value: settings.biometricEnabled,
                      onChanged: (v) {
                        settings.setBiometric(v);
                        if (v) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم تفعيل البصمة في الإصدار القادم',
                                  style: TextStyle(fontFamily: 'Cairo')),
                            ),
                          );
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'تغيير كلمة المرور',
                      color: AppColors.warning,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.devices_rounded,
                      title: 'الأجهزة المرتبطة',
                      subtitle: 'جهاز واحد نشط',
                      color: AppColors.info,
                      onTap: () => _showDevicesDialog(),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.shield_rounded,
                      title: 'حد الإنفاق اليومي',
                      subtitle:
                          '${AppConstants.dailyTransferLimit.toStringAsFixed(0)} ريال',
                      color: AppColors.primaryBlue,
                      onTap: () => _showLimitInfo(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),

                // المظهر
                _SectionHeader(title: 'المظهر'),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'الوضع الليلي',
                      subtitle: settings.isDarkMode
                          ? 'المظهر الداكن مفعّل'
                          : 'المظهر الفاتح مفعّل',
                      color: const Color(0xFF5C6BC0),
                      value: settings.isDarkMode,
                      onChanged: (v) => settings.setDarkMode(v),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.language_rounded,
                      title: 'اللغة',
                      subtitle: 'العربية',
                      color: Colors.teal,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('دعم لغات إضافية قريباً',
                                style: TextStyle(fontFamily: 'Cairo')),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),

                // حول التطبيق
                _SectionHeader(title: 'حول التطبيق'),
                _SettingsCard(
                  children: [
                    _ActionTile(
                      icon: Icons.card_giftcard_rounded,
                      title: 'ادعُ أصدقاءك',
                      subtitle: 'اكسب 500 ريال لكل صديق',
                      color: AppColors.accentYellow,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const ReferralScreen())),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.help_outline_rounded,
                      title: 'الأسئلة الشائعة',
                      subtitle: 'إجابات لأكثر الأسئلة شيوعاً',
                      color: AppColors.info,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const FaqScreen())),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.info_outline_rounded,
                      title: 'الإصدار ${AppConstants.appVersion}',
                      subtitle: 'Beepay — محفظتك الرقمية',
                      color: AppColors.grey,
                      onTap: () {},
                      showArrow: false,
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.description_rounded,
                      title: 'الشروط والأحكام',
                      color: AppColors.primaryBlue,
                      onTap: () => _showTerms(),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.privacy_tip_rounded,
                      title: 'سياسة الخصوصية',
                      color: AppColors.primaryBlue,
                      onTap: () => _showPrivacy(),
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.star_rounded,
                      title: 'قيّم التطبيق',
                      subtitle: 'ساعدنا في التحسين',
                      color: AppColors.accentYellow,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('شكراً لك! التقييم متاح بعد النشر',
                                style: TextStyle(fontFamily: 'Cairo')),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _ActionTile(
                      icon: Icons.headset_mic_rounded,
                      title: 'الدعم الفني',
                      subtitle: AppConstants.supportPhone,
                      color: AppColors.success,
                      onTap: () => _showSupport(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingXL),
              ],
            ),
    );
  }

  void _showDevicesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('الأجهزة المرتبطة',
            style: TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.phone_iphone, color: AppColors.success),
              ),
              title: const Text('هذا الجهاز',
                  style: TextStyle(fontFamily: 'Cairo')),
              subtitle: const Text('نشط الآن',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.success,
                      fontSize: 12)),
              trailing: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showLimitInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حدود الإنفاق',
            style: TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LimitRow('الحد اليومي للتحويل',
                '${AppConstants.dailyTransferLimit.toStringAsFixed(0)} ريال'),
            _LimitRow('الحد الأدنى للتحويل',
                '${AppConstants.minTransferAmount.toStringAsFixed(0)} ريال'),
            _LimitRow('الحد الأقصى للتحويل',
                '${AppConstants.maxTransferAmount.toStringAsFixed(0)} ريال'),
            _LimitRow('الحد الأدنى للسحب',
                '${AppConstants.minWithdrawalAmount.toStringAsFixed(0)} ريال'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _LimitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.grey, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('الشروط والأحكام',
            style: TextStyle(fontFamily: 'Cairo')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TermsParagraph('1. الاستخدام',
                  'يمنحك Beepay رخصة محدودة لاستخدام التطبيق للأغراض الشخصية غير التجارية.'),
              _TermsParagraph('2. الحساب',
                  'أنت مسؤول عن الحفاظ على سرية معلومات حسابك وكلمة المرور.'),
              _TermsParagraph('3. المعاملات',
                  'جميع المعاملات نهائية ولا يمكن التراجع عنها إلا في الحالات الاستثنائية.'),
              _TermsParagraph('4. الأمان',
                  'نستخدم تشفير SSL 256-bit لحماية جميع بياناتك ومعاملاتك.'),
              _TermsParagraph('5. الخصوصية',
                  'لن نشارك بياناتك الشخصية مع أطراف ثالثة دون موافقتك الصريحة.'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('موافق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showPrivacy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('سياسة الخصوصية',
            style: TextStyle(fontFamily: 'Cairo')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TermsParagraph('البيانات التي نجمعها',
                  'نجمع المعلومات الأساسية لتشغيل الخدمة: رقم الهاتف، بيانات المحفظة، وسجل المعاملات.'),
              _TermsParagraph('كيف نستخدم بياناتك',
                  'نستخدم بياناتك لتقديم الخدمة، وتحسين تجربتك، وضمان الأمان.'),
              _TermsParagraph('حفظ البيانات',
                  'يتم تخزين بياناتك على خوادم آمنة في اليمن وفق أحدث معايير الأمان.'),
              _TermsParagraph('حقوقك',
                  'يحق لك طلب حذف حسابك وبياناتك في أي وقت عبر التواصل مع فريق الدعم.'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('فهمت',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showSupport() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('الدعم الفني',
            style: TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SupportItem(Icons.phone_rounded, 'هاتف',
                AppConstants.supportPhone, AppColors.success),
            const SizedBox(height: 10),
            _SupportItem(Icons.email_rounded, 'بريد إلكتروني',
                AppConstants.supportEmail, AppColors.primaryBlue),
            const SizedBox(height: 10),
            _SupportItem(Icons.access_time_rounded, 'ساعات العمل',
                'الأحد - الخميس: 8ص - 8م', AppColors.warning),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _SupportItem(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 11)),
            Text(value,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class _TermsParagraph extends StatelessWidget {
  final String title;
  final String body;
  const _TermsParagraph(this.title, this.body, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 4),
          Text(body,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 13,
                  height: 1.5)),
        ],
      ),
    );
  }
}

// ========== Widgets مشتركة ==========
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppSizes.paddingS, right: AppSizes.paddingS),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.grey,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
            color:
                onChanged == null ? AppColors.grey : AppColors.black,
          )),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
              fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryBlue,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool showArrow;

  const _ActionTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
    this.showArrow = true,
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
      title: Text(title,
          style: const TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 12))
          : null,
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.grey)
          : null,
    );
  }
}
