import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

enum _Step { phone, otp, newPassword }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  _Step _step = _Step.phone;
  bool _isLoading = false;

  // خطوة رقم الهاتف
  final _phoneController = TextEditingController();
  final _phoneFk = GlobalKey<FormState>();

  // خطوة OTP
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 60;
  bool _canResend = false;

  // خطوة كلمة المرور الجديدة
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _passFk = GlobalKey<FormState>();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late AnimationController _slideCtrl;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut),
    );
    _slideCtrl.forward();
    _startResendTimer();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _phoneController.dispose();
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  void _startResendTimer() async {
    _resendSeconds = 60;
    _canResend = false;
    while (_resendSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _resendSeconds--);
    }
    if (mounted) setState(() => _canResend = true);
  }

  void _nextStep(_Step next) {
    _slideCtrl.reset();
    setState(() => _step = next);
    _slideCtrl.forward();
  }

  // --- الخطوة 1: التحقق من الهاتف ---
  Future<void> _submitPhone() async {
    if (!_phoneFk.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _nextStep(_Step.otp);
  }

  // --- الخطوة 2: التحقق من OTP ---
  String get _otpValue =>
      _otpControllers.map((c) => c.text).join();

  Future<void> _submitOtp() async {
    if (_otpValue.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل رمز التحقق المكون من 6 أرقام',
              style: TextStyle(fontFamily: 'Cairo')),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _nextStep(_Step.newPassword);
  }

  // --- الخطوة 3: كلمة المرور الجديدة ---
  Future<void> _submitNewPassword() async {
    if (!_passFk.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('تم بنجاح!',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const SizedBox(height: 8),
            const Text(
              'تم تغيير كلمة المرور بنجاح\nيمكنك تسجيل الدخول الآن',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 13),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('تسجيل الدخول',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: AnimatedBuilder(
          animation: _slideAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: child,
          ),
          child: Column(
            children: [
              // مؤشر الخطوات
              _StepsIndicator(current: _step),
              const SizedBox(height: AppSizes.paddingXL),

              // المحتوى
              if (_step == _Step.phone) _buildPhoneStep(),
              if (_step == _Step.otp) _buildOtpStep(),
              if (_step == _Step.newPassword) _buildPasswordStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      children: [
        _StepHeader(
          icon: Icons.phone_android_rounded,
          color: AppColors.primaryBlue,
          title: 'أدخل رقم هاتفك',
          subtitle: 'سنرسل رمز تحقق لاستعادة كلمة المرور',
        ),
        const SizedBox(height: AppSizes.paddingXL),
        Form(
          key: _phoneFk,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle:
                      TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '7X XXX XXXX',
                  hintStyle: TextStyle(fontFamily: 'Cairo'),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'أدخل رقم الهاتف';
                  if (v.length < 9) return 'رقم الهاتف غير صحيح';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.paddingXL),
              CustomButton(
                text: 'إرسال رمز التحقق',
                onPressed: _isLoading ? null : _submitPhone,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        _StepHeader(
          icon: Icons.sms_rounded,
          color: AppColors.warning,
          title: 'رمز التحقق',
          subtitle:
              'أدخل الرمز المرسل إلى\n+967 ${_phoneController.text}',
        ),
        const SizedBox(height: AppSizes.paddingXL),

        // حقول OTP
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 46,
                height: 56,
                child: TextFormField(
                  controller: _otpControllers[i],
                  focusNode: _otpFocus[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                      borderSide: const BorderSide(
                          color: AppColors.primaryBlue, width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) {
                      _otpFocus[i + 1].requestFocus();
                    }
                    if (v.isEmpty && i > 0) {
                      _otpFocus[i - 1].requestFocus();
                    }
                    setState(() {});
                  },
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: AppSizes.paddingL),

        // إعادة الإرسال
        _canResend
            ? TextButton(
                onPressed: () {
                  _startResendTimer();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إعادة إرسال الرمز',
                          style: TextStyle(fontFamily: 'Cairo')),
                    ),
                  );
                },
                child: const Text('إعادة إرسال الرمز',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primaryBlue)),
              )
            : Text(
                'إعادة الإرسال خلال $_resendSeconds ثانية',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 13),
              ),

        const SizedBox(height: AppSizes.paddingXL),

        CustomButton(
          text: 'تحقق',
          onPressed: _isLoading ? null : _submitOtp,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      children: [
        _StepHeader(
          icon: Icons.lock_reset_rounded,
          color: AppColors.success,
          title: 'كلمة المرور الجديدة',
          subtitle: 'أنشئ كلمة مرور قوية تحتوي\nعلى حروف كبيرة وصغيرة وأرقام',
        ),
        const SizedBox(height: AppSizes.paddingXL),
        Form(
          key: _passFk,
          child: Column(
            children: [
              TextFormField(
                controller: _newPassCtrl,
                obscureText: _obscureNew,
                maxLength: 8,
                style: const TextStyle(
                    fontFamily: 'Cairo', letterSpacing: 2, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  labelStyle: const TextStyle(
                      fontFamily: 'Cairo', color: AppColors.grey),
                  counterText: '',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                  if (v.length != 8) return 'يجب أن تكون 8 خانات';
                  if (!v.contains(RegExp(r'[A-Z]')))
                    return 'يجب أن تحتوي على حرف كبير';
                  if (!v.contains(RegExp(r'[0-9]')))
                    return 'يجب أن تحتوي على رقم';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.paddingM),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                maxLength: 8,
                style: const TextStyle(
                    fontFamily: 'Cairo', letterSpacing: 2, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  labelStyle: const TextStyle(
                      fontFamily: 'Cairo', color: AppColors.grey),
                  counterText: '',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v != _newPassCtrl.text)
                    return 'كلمتا المرور غير متطابقتين';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.paddingXL),
              CustomButton(
                text: 'حفظ كلمة المرور',
                onPressed: _isLoading ? null : _submitNewPassword,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepsIndicator extends StatelessWidget {
  final _Step current;

  const _StepsIndicator({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('هاتف', Icons.phone_android_rounded),
      ('تحقق', Icons.sms_rounded),
      ('كلمة المرور', Icons.lock_reset_rounded),
    ];

    final idx = _Step.values.indexOf(current);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIdx = i ~/ 2;
          final done = lineIdx < idx;
          return Expanded(
            child: Container(
              height: 2,
              color: done
                  ? AppColors.primaryBlue
                  : AppColors.lightGrey,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final done = stepIdx < idx;
        final active = stepIdx == idx;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: done || active
                    ? AppColors.primaryBlue
                    : AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                done ? Icons.check_rounded : steps[stepIdx].$2,
                color: done || active ? Colors.white : AppColors.grey,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIdx].$1,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color:
                    done || active ? AppColors.primaryBlue : AppColors.grey,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _StepHeader({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 38),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.grey,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
