import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class AppSecurityScreen extends StatefulWidget {
  const AppSecurityScreen({super.key});

  @override
  State<AppSecurityScreen> createState() => _AppSecurityScreenState();
}

class _AppSecurityScreenState extends State<AppSecurityScreen>
    with SingleTickerProviderStateMixin {
  bool _pinEnabled = true;
  bool _biometricEnabled = false;
  bool _hideAmounts = false;
  bool _autoLock = true;
  String _autoLockDuration = '1 دقيقة';
  String _currentView = 'main'; // main | setup_pin | change_pin | verify_pin

  final List<String> _lockDurations = [
    'فوري',
    '1 دقيقة',
    '5 دقائق',
    '15 دقيقة',
    '30 دقيقة',
  ];

  // PIN setup state
  String _enteredPin = '';
  String _firstPin = '';
  String _pinStep = 'enter'; // enter | confirm
  String _pinTitle = 'أدخل رمز PIN الجديد';
  bool _pinError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onPinKey(String key) {
    if (_enteredPin.length >= 6) return;
    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin += key;
      _pinError = false;
    });

    if (_enteredPin.length == 6) {
      Future.delayed(const Duration(milliseconds: 200), _processPin);
    }
  }

  void _onPinDelete() {
    if (_enteredPin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _processPin() {
    if (_currentView == 'verify_pin') {
      // Simulate verification - mock PIN is 123456
      if (_enteredPin == '123456') {
        setState(() {
          _enteredPin = '';
          _pinStep = 'enter';
          _pinTitle = 'أدخل رمز PIN الجديد';
          _currentView = 'setup_pin';
        });
      } else {
        _showPinError('رمز PIN غير صحيح');
      }
      return;
    }

    if (_pinStep == 'enter') {
      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = '';
        _pinStep = 'confirm';
        _pinTitle = 'أعد إدخال رمز PIN';
      });
    } else {
      if (_enteredPin == _firstPin) {
        setState(() {
          _currentView = 'main';
          _enteredPin = '';
          _firstPin = '';
          _pinStep = 'enter';
          _pinTitle = 'أدخل رمز PIN الجديد';
          _pinEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم تعيين رمز PIN بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        _showPinError('رمزا PIN غير متطابقين، حاول مجدداً');
      }
    }
  }

  void _showPinError(String message) {
    setState(() {
      _pinError = true;
      _enteredPin = '';
    });
    _shakeController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openSetupPin({bool isChange = false}) {
    setState(() {
      _enteredPin = '';
      _firstPin = '';
      _pinStep = 'enter';
      _pinTitle = 'أدخل رمز PIN الجديد';
      _currentView = isChange ? 'verify_pin' : 'setup_pin';
      if (_currentView == 'verify_pin') {
        _pinTitle = 'أدخل رمز PIN الحالي';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _currentView == 'main' ? 'أمان التطبيق' : 'إعداد رمز PIN',
          style: const TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: _currentView != 'main'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _currentView = 'main';
                  _enteredPin = '';
                  _firstPin = '';
                  _pinStep = 'enter';
                }),
              )
            : null,
      ),
      body: _currentView == 'main' ? _buildMainView() : _buildPinView(),
    );
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security status banner
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _pinEnabled
                        ? Icons.shield_rounded
                        : Icons.shield_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pinEnabled ? 'الحساب محمي' : 'الحساب غير محمي',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _pinEnabled
                            ? 'رمز PIN مفعّل${_biometricEnabled ? ' + بصمة' : ''}'
                            : 'قم بتفعيل رمز PIN لحماية حسابك',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // PIN section
          _SectionHeader(title: 'قفل التطبيق'),
          _SettingCard(children: [
            _SettingToggle(
              icon: Icons.lock_outline,
              iconColor: AppColors.primaryBlue,
              title: 'قفل برمز PIN',
              subtitle: 'اطلب رمز PIN عند فتح التطبيق',
              value: _pinEnabled,
              onChanged: (val) {
                if (val) {
                  _openSetupPin();
                } else {
                  _showDisablePinDialog();
                }
              },
            ),
            if (_pinEnabled) ...[
              const Divider(height: 1),
              _SettingAction(
                icon: Icons.edit_outlined,
                iconColor: AppColors.primaryBlue,
                title: 'تغيير رمز PIN',
                subtitle: 'استبدال رمز PIN الحالي برمز جديد',
                onTap: () => _openSetupPin(isChange: true),
              ),
              const Divider(height: 1),
              _SettingToggle(
                icon: Icons.fingerprint,
                iconColor: const Color(0xFF388E3C),
                title: 'البصمة / Face ID',
                subtitle: 'استخدم بصمة الإصبع أو التعرف على الوجه',
                value: _biometricEnabled,
                onChanged: (val) => setState(() => _biometricEnabled = val),
              ),
            ],
          ]),
          const SizedBox(height: AppSizes.paddingM),

          // Auto-lock
          if (_pinEnabled) ...[
            _SectionHeader(title: 'القفل التلقائي'),
            _SettingCard(children: [
              _SettingToggle(
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFFE65100),
                title: 'قفل تلقائي',
                subtitle: 'قفل التطبيق بعد فترة من التعطل',
                value: _autoLock,
                onChanged: (val) => setState(() => _autoLock = val),
              ),
              if (_autoLock) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingS),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: AppColors.grey, size: 20),
                      const SizedBox(width: AppSizes.paddingM),
                      const Expanded(
                        child: Text(
                          'مدة التعطل قبل القفل',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _autoLockDuration,
                        underline: const SizedBox(),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primaryBlue,
                          fontSize: 14,
                        ),
                        items: _lockDurations
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _autoLockDuration = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ]),
            const SizedBox(height: AppSizes.paddingM),
          ],

          // Privacy
          _SectionHeader(title: 'الخصوصية'),
          _SettingCard(children: [
            _SettingToggle(
              icon: Icons.visibility_off_outlined,
              iconColor: const Color(0xFF8E24AA),
              title: 'إخفاء الأرصدة',
              subtitle: 'إخفاء الأرقام في الشاشة الرئيسية',
              value: _hideAmounts,
              onChanged: (val) => setState(() => _hideAmounts = val),
            ),
            const Divider(height: 1),
            _SettingAction(
              icon: Icons.history,
              iconColor: AppColors.grey,
              title: 'سجل تسجيل الدخول',
              subtitle: 'عرض جلسات الدخول الأخيرة',
              onTap: _showLoginHistory,
            ),
            const Divider(height: 1),
            _SettingAction(
              icon: Icons.devices_outlined,
              iconColor: AppColors.grey,
              title: 'الأجهزة المتصلة',
              subtitle: 'إدارة الأجهزة المرتبطة بحسابك',
              onTap: _showDevicesSheet,
            ),
          ]),
          const SizedBox(height: AppSizes.paddingM),

          // Danger zone
          _SectionHeader(title: 'إجراءات الأمان'),
          _SettingCard(children: [
            _SettingAction(
              icon: Icons.lock_reset,
              iconColor: AppColors.warning,
              title: 'إعادة تعيين كلمة المرور',
              subtitle: 'إرسال رابط إعادة التعيين عبر البريد',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            _SettingAction(
              icon: Icons.logout,
              iconColor: AppColors.error,
              title: 'تسجيل الخروج من كل الأجهزة',
              subtitle: 'إنهاء جميع الجلسات النشطة',
              onTap: _showLogoutAllDialog,
            ),
          ]),
          const SizedBox(height: AppSizes.paddingXL),
        ],
      ),
    );
  }

  Widget _buildPinView() {
    final isConfirmStep = _pinStep == 'confirm';
    final isVerifyStep = _currentView == 'verify_pin';

    return Column(
      children: [
        const SizedBox(height: AppSizes.paddingXL),

        // Lock icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isVerifyStep
                ? Icons.lock_outline
                : isConfirmStep
                    ? Icons.check_circle_outline
                    : Icons.lock_reset,
            size: 40,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),

        // Title
        Text(
          _pinTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isConfirmStep
              ? 'تأكيد رمز PIN الجديد'
              : isVerifyStep
                  ? 'للتحقق من هويتك'
                  : 'اختر رمزاً من 6 أرقام',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXL),

        // PIN dots
        AnimatedBuilder(
          animation: _shakeAnim,
          builder: (_, child) {
            final dx = _pinError
                ? 10 *
                    (0.5 - (_shakeAnim.value - 0.5).abs()) *
                    ((_shakeAnim.value * 10).floor().isEven ? 1 : -1)
                : 0.0;
            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final filled = index < _enteredPin.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _pinError
                      ? AppColors.error
                      : filled
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                  border: Border.all(
                    color: _pinError
                        ? AppColors.error
                        : filled
                            ? AppColors.primaryBlue
                            : AppColors.grey,
                    width: 2,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: AppSizes.paddingXL),

        // Keypad
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeyRow(['1', '2', '3']),
                const SizedBox(height: 16),
                _buildKeyRow(['4', '5', '6']),
                const SizedBox(height: 16),
                _buildKeyRow(['7', '8', '9']),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _KeyButton(label: '', onTap: null),
                    _KeyButton(label: '0', onTap: () => _onPinKey('0')),
                    _KeyButton(
                      icon: Icons.backspace_outlined,
                      onTap: _onPinDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) => _KeyButton(label: k, onTap: () => _onPinKey(k))).toList(),
    );
  }

  void _showDisablePinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تعطيل رمز PIN',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: const Text(
          'هل أنت متأكد من تعطيل رمز PIN؟ سيصبح تطبيقك غير محمي.',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pinEnabled = false;
                _biometricEnabled = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تعطيل',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLoginHistory() {
    final history = [
      {'device': 'هاتف Samsung Galaxy', 'time': 'اليوم، 10:24 ص', 'location': 'صنعاء، اليمن', 'current': true},
      {'device': 'هاتف Samsung Galaxy', 'time': 'أمس، 8:15 م', 'location': 'صنعاء، اليمن', 'current': false},
      {'device': 'متصفح Chrome / Windows', 'time': 'منذ 3 أيام', 'location': 'صنعاء، اليمن', 'current': false},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('سجل تسجيل الدخول',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...history.map((h) => ListTile(
                leading: Icon(
                  h['device'].toString().contains('متصفح')
                      ? Icons.computer
                      : Icons.phone_android,
                  color: h['current'] == true
                      ? AppColors.success
                      : AppColors.grey,
                ),
                title: Text(h['device'].toString(),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)),
                subtitle: Text('${h['time']} · ${h['location']}',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey)),
                trailing: h['current'] == true
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('الحالي',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppColors.success)),
                      )
                    : null,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDevicesSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('الأجهزة المتصلة',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.phone_android,
                color: AppColors.success),
            title: const Text('هاتف Samsung Galaxy',
                style: TextStyle(fontFamily: 'Cairo')),
            subtitle: const Text('هذا الجهاز',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.success)),
            trailing: const Icon(Icons.check_circle,
                color: AppColors.success, size: 20),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('تسجيل الخروج من جميع الأجهزة الأخرى',
                  style:
                      TextStyle(fontFamily: 'Cairo', color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLogoutAllDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تسجيل الخروج من كل الأجهزة',
            style:
                TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: const Text(
          'سيتم إنهاء جميع الجلسات النشطة على كافة الأجهزة. ستحتاج إلى تسجيل الدخول مجدداً.',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم تسجيل الخروج من جميع الأجهزة',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تأكيد',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
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
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
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

class _SettingAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingAction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM, vertical: AppSizes.paddingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  const _KeyButton({this.label, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (label != null && label!.isEmpty) {
      return const SizedBox(width: 72, height: 72);
    }
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(36),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 24, color: AppColors.textPrimary)
                  : Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
