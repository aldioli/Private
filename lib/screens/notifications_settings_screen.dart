import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  // General
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = true;

  // Transactions
  bool _onTransfer = true;
  bool _onReceive = true;
  bool _onDeposit = true;
  bool _onWithdraw = true;
  bool _onBillPaid = true;

  // Security
  bool _onLogin = true;
  bool _onPasswordChange = true;
  bool _onSuspicious = true;

  // Promotions
  bool _onOffers = false;
  bool _onNews = false;
  bool _onTips = true;

  // Quiet hours
  bool _quietHours = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietStart : _quietEnd,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietStart = picked;
        } else {
          _quietEnd = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master toggles
            _SectionTitle(title: 'قنوات الإشعارات'),
            _Card(children: [
              _Toggle(
                icon: Icons.notifications_active_rounded,
                iconColor: AppColors.primaryBlue,
                title: 'إشعارات الجهاز (Push)',
                subtitle: 'إشعارات فورية على هاتفك',
                value: _pushEnabled,
                onChanged: (v) => setState(() => _pushEnabled = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.email_outlined,
                iconColor: const Color(0xFFE53935),
                title: 'البريد الإلكتروني',
                subtitle: 'ملخص المعاملات والتقارير',
                value: _emailEnabled,
                onChanged: (v) => setState(() => _emailEnabled = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.sms_outlined,
                iconColor: const Color(0xFF388E3C),
                title: 'رسائل SMS',
                subtitle: 'رموز التحقق والتنبيهات المهمة',
                value: _smsEnabled,
                onChanged: (v) => setState(() => _smsEnabled = v),
              ),
            ]),
            const SizedBox(height: AppSizes.paddingM),

            // Transactions
            _SectionTitle(title: 'إشعارات المعاملات'),
            _Card(children: [
              _Toggle(
                icon: Icons.send_rounded,
                iconColor: AppColors.primaryBlue,
                title: 'التحويلات',
                subtitle: 'عند إرسال أو تأكيد تحويل',
                value: _onTransfer,
                onChanged: (v) => setState(() => _onTransfer = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.call_received_rounded,
                iconColor: AppColors.success,
                title: 'الاستلام',
                subtitle: 'عند استلام مبلغ في محفظتك',
                value: _onReceive,
                onChanged: (v) => setState(() => _onReceive = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.add_circle_outline,
                iconColor: AppColors.success,
                title: 'الإيداع',
                subtitle: 'عند إيداع رصيد في المحفظة',
                value: _onDeposit,
                onChanged: (v) => setState(() => _onDeposit = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.remove_circle_outline,
                iconColor: AppColors.warning,
                title: 'السحب',
                subtitle: 'عند سحب رصيد من المحفظة',
                value: _onWithdraw,
                onChanged: (v) => setState(() => _onWithdraw = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.receipt_long_rounded,
                iconColor: const Color(0xFFE53935),
                title: 'دفع الفواتير',
                subtitle: 'عند دفع فاتورة بنجاح',
                value: _onBillPaid,
                onChanged: (v) => setState(() => _onBillPaid = v),
              ),
            ]),
            const SizedBox(height: AppSizes.paddingM),

            // Security
            _SectionTitle(title: 'إشعارات الأمان'),
            _Card(children: [
              _Toggle(
                icon: Icons.login_rounded,
                iconColor: AppColors.info,
                title: 'تسجيل الدخول',
                subtitle: 'عند تسجيل الدخول من جهاز جديد',
                value: _onLogin,
                onChanged: (v) => setState(() => _onLogin = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.lock_reset,
                iconColor: AppColors.warning,
                title: 'تغيير كلمة المرور',
                subtitle: 'عند تغيير أو إعادة تعيين كلمة المرور',
                value: _onPasswordChange,
                onChanged: (v) => setState(() => _onPasswordChange = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.error,
                title: 'نشاط مشبوه',
                subtitle: 'تنبيه فوري عند اكتشاف نشاط غير عادي',
                value: _onSuspicious,
                onChanged: (v) => setState(() => _onSuspicious = v),
              ),
            ]),
            const SizedBox(height: AppSizes.paddingM),

            // Promotions
            _SectionTitle(title: 'العروض والمحتوى'),
            _Card(children: [
              _Toggle(
                icon: Icons.local_offer_rounded,
                iconColor: const Color(0xFFFA709A),
                title: 'العروض والخصومات',
                subtitle: 'عروض حصرية وكاشباك',
                value: _onOffers,
                onChanged: (v) => setState(() => _onOffers = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.newspaper_rounded,
                iconColor: AppColors.grey,
                title: 'الأخبار والتحديثات',
                subtitle: 'آخر أخبار Beepay والميزات الجديدة',
                value: _onNews,
                onChanged: (v) => setState(() => _onNews = v),
              ),
              const Divider(height: 1),
              _Toggle(
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFFFA000),
                title: 'نصائح مالية',
                subtitle: 'نصائح لإدارة أموالك بذكاء',
                value: _onTips,
                onChanged: (v) => setState(() => _onTips = v),
              ),
            ]),
            const SizedBox(height: AppSizes.paddingM),

            // Quiet hours
            _SectionTitle(title: 'ساعات الصمت'),
            _Card(children: [
              _Toggle(
                icon: Icons.do_not_disturb_on_rounded,
                iconColor: const Color(0xFF5E35B1),
                title: 'تفعيل ساعات الصمت',
                subtitle: 'إيقاف الإشعارات في أوقات محددة',
                value: _quietHours,
                onChanged: (v) => setState(() => _quietHours = v),
              ),
              if (_quietHours) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bedtime_outlined,
                      color: AppColors.grey, size: 22),
                  title: const Text('وقت البداية',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
                  trailing: GestureDetector(
                    onTap: () => _pickTime(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _quietStart.format(context),
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.wb_sunny_outlined,
                      color: AppColors.grey, size: 22),
                  title: const Text('وقت الانتهاء',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
                  trailing: GestureDetector(
                    onTap: () => _pickTime(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _quietEnd.format(context),
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ]),
            const SizedBox(height: AppSizes.paddingL),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ إعدادات الإشعارات',
                          style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
                child: const Text('حفظ الإعدادات',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.grey)),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Toggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
