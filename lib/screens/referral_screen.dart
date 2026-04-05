import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen>
    with TickerProviderStateMixin {
  static const _referralCode = 'YEMEN2024';
  static const _rewardPerFriend = 500;

  // محاكاة قائمة المدعوين
  final _invited = [
    {'name': 'محمد أحمد', 'status': 'مكتمل', 'reward': 500, 'done': true},
    {'name': 'سارة علي', 'status': 'في الانتظار', 'reward': 0, 'done': false},
  ];

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(const ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تم نسخ رمز الدعوة', style: TextStyle(fontFamily: 'Cairo')),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareCode() {
    Clipboard.setData(const ClipboardData(
      text:
          'انضم إلى YemenPay واحصل على مكافأة ترحيبية!\nرمز الدعوة: YEMEN2024\nحمّل التطبيق الآن',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رسالة المشاركة',
            style: TextStyle(fontFamily: 'Cairo')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int get _totalEarned => _invited
      .where((f) => f['done'] == true)
      .fold(0, (sum, f) => sum + (f['reward'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('ادعُ أصدقاءك',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            // البطاقة الرئيسية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1565C0),
                    Color(0xFF1976D2),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.45),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // أيقونة مع نبض
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3), width: 2),
                        ),
                        child: const Icon(Icons.card_giftcard_rounded,
                            color: Colors.white, size: 44),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ادعُ صديقاً واكسب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_rewardPerFriend ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.accentYellow,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'لكل صديق يسجّل ويُكمل أول معاملة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // رمز الدعوة
                  GestureDetector(
                    onTap: _copyCode,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _referralCode,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.copy_rounded,
                                color: AppColors.primaryBlue, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'انقر للنسخ',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // زر المشاركة
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: _shareCode,
                icon: const Icon(Icons.share_rounded),
                label: const Text('شارك مع أصدقائك',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentYellow,
                  foregroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // إحصائيات
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.people_outline_rounded,
                    value: '${_invited.length}',
                    label: 'مدعوون',
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: _StatBox(
                    icon: Icons.check_circle_outline_rounded,
                    value:
                        '${_invited.where((f) => f['done'] == true).length}',
                    label: 'مكتملون',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: _StatBox(
                    icon: Icons.account_balance_wallet_outlined,
                    value: '$_totalEarned',
                    label: 'ريال ربحت',
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingL),

            // كيف يعمل
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E2E)
                    : AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
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
                  const Text(
                    'كيف يعمل البرنامج؟',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  _StepRow(
                    number: '١',
                    text: 'شارك رمز دعوتك مع صديق',
                    color: AppColors.primaryBlue,
                  ),
                  _StepRow(
                    number: '٢',
                    text:
                        'يُسجّل صديقك في YemenPay ويدخل رمزك',
                    color: AppColors.info,
                  ),
                  _StepRow(
                    number: '٣',
                    text: 'يُكمل صديقك أول معاملة',
                    color: AppColors.warning,
                  ),
                  _StepRow(
                    number: '٤',
                    text:
                        'تحصل أنت وصديقك على $_rewardPerFriend ريال لكل منكما!',
                    color: AppColors.success,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // قائمة المدعوين
            if (_invited.isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    'المدعوون',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_invited.length} أشخاص',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E1E2E)
                      : AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: _invited.asMap().entries.map((entry) {
                    final i = entry.key;
                    final friend = entry.value;
                    final isDone = friend['done'] as bool;
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDone
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.grey.withValues(alpha: 0.15),
                            child: Text(
                              (friend['name'] as String)[0],
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                color: isDone
                                    ? AppColors.success
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                          title: Text(
                            friend['name'] as String,
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            friend['status'] as String,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: isDone
                                  ? AppColors.success
                                  : AppColors.grey,
                            ),
                          ),
                          trailing: isDone
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '+${friend['reward']} ريال',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.hourglass_top_rounded,
                                  color: AppColors.grey, size: 20),
                        ),
                        if (i < _invited.length - 1)
                          const Divider(height: 1, indent: 72),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String number;
  final String text;
  final Color color;
  final bool isLast;

  const _StepRow({
    Key? key,
    required this.number,
    required this.text,
    required this.color,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 20,
                  color: color.withValues(alpha: 0.2),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
