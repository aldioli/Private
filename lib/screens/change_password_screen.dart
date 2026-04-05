import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // متطلبات كلمة المرور
  bool get _hasLength => _newController.text.length == 8;
  bool get _hasLetter => _newController.text.contains(RegExp(r'[a-zA-Z]'));
  bool get _hasDigit => _newController.text.contains(RegExp(r'[0-9]'));
  bool get _hasUpper => _newController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _newController.text.contains(RegExp(r'[a-z]'));

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('تغيير كلمة المرور',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // أيقونة
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_reset_rounded,
                          color: AppColors.warning, size: 40),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أنشئ كلمة مرور قوية',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '8 خانات تحتوي على حروف كبيرة وصغيرة وأرقام',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),

              // بطاقة الحقول
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.white,
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
                  children: [
                    // كلمة المرور الحالية
                    _PasswordField(
                      controller: _currentController,
                      label: 'كلمة المرور الحالية',
                      obscure: _obscureCurrent,
                      onToggle: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'يرجى إدخال كلمة المرور الحالية';
                        if (v.length != 8) return 'كلمة المرور 8 خانات';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    const Divider(),
                    const SizedBox(height: AppSizes.paddingM),

                    // كلمة المرور الجديدة
                    _PasswordField(
                      controller: _newController,
                      label: 'كلمة المرور الجديدة',
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'يرجى إدخال كلمة المرور الجديدة';
                        if (v.length != 8) return 'يجب أن تكون 8 خانات';
                        if (!v.contains(RegExp(r'[a-zA-Z]')))
                          return 'يجب أن تحتوي على حروف';
                        if (!v.contains(RegExp(r'[0-9]')))
                          return 'يجب أن تحتوي على أرقام';
                        if (v == _currentController.text)
                          return 'يجب أن تختلف عن كلمة المرور الحالية';
                        return null;
                      },
                    ),

                    // مؤشر القوة
                    const SizedBox(height: 10),
                    _StrengthIndicator(
                      hasLength: _hasLength,
                      hasLetter: _hasLetter,
                      hasDigit: _hasDigit,
                      hasUpper: _hasUpper,
                      hasLower: _hasLower,
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // تأكيد كلمة المرور
                    _PasswordField(
                      controller: _confirmController,
                      label: 'تأكيد كلمة المرور الجديدة',
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'يرجى تأكيد كلمة المرور';
                        if (v != _newController.text)
                          return 'كلمتا المرور غير متطابقتين';
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              CustomButton(
                text: 'تغيير كلمة المرور',
                onPressed: _isLoading ? null : _handleChange,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _newController.text),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message, style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    } catch (_) {}
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
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 38),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم التغيير بنجاح!',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'يمكنك الآن استخدام كلمة المرور الجديدة',
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
                Navigator.pop(context);
              },
              child: const Text('حسناً',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== حقل كلمة المرور ==========
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _PasswordField({
    Key? key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: 8,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(
          fontFamily: 'Cairo', letterSpacing: 2, fontSize: 16),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
        counterText: '',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.grey,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide:
              const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      validator: validator,
    );
  }
}

// ========== مؤشر قوة كلمة المرور ==========
class _StrengthIndicator extends StatelessWidget {
  final bool hasLength;
  final bool hasLetter;
  final bool hasDigit;
  final bool hasUpper;
  final bool hasLower;

  const _StrengthIndicator({
    Key? key,
    required this.hasLength,
    required this.hasLetter,
    required this.hasDigit,
    required this.hasUpper,
    required this.hasLower,
  }) : super(key: key);

  int get _score =>
      (hasLength ? 1 : 0) +
      (hasLetter ? 1 : 0) +
      (hasDigit ? 1 : 0) +
      (hasUpper ? 1 : 0) +
      (hasLower ? 1 : 0);

  Color get _color {
    if (_score <= 1) return AppColors.error;
    if (_score <= 3) return AppColors.warning;
    return AppColors.success;
  }

  String get _label {
    if (_score <= 1) return 'ضعيفة';
    if (_score <= 3) return 'متوسطة';
    return 'قوية';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _score / 5,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: _color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _Req(label: '8 خانات', met: hasLength),
            _Req(label: 'حرف كبير', met: hasUpper),
            _Req(label: 'حرف صغير', met: hasLower),
            _Req(label: 'رقم', met: hasDigit),
          ],
        ),
      ],
    );
  }
}

class _Req extends StatelessWidget {
  final String label;
  final bool met;

  const _Req({super.key, required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 14,
          color: met ? AppColors.success : AppColors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: met ? AppColors.success : AppColors.grey,
          ),
        ),
      ],
    );
  }
}
