import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo_widget.dart';
import '../widgets/beepay_loading.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePin = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueYellowGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الشعار
                    const LogoWidget(size: 120),
                    const SizedBox(height: AppSizes.paddingL),
                    
                    // عنوان التطبيق
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'محفظتك الرقمية في اليمن',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXL),
                    
                    // بطاقة تسجيل الدخول
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'تسجيل الدخول',
                            style: AppTextStyles.heading2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.paddingL),
                          
                          // حقل رقم الهاتف
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextField(
                              controller: _phoneController,
                              labelText: 'رقم الهاتف',
                              prefixText: '+967 ',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال رقم الهاتف';
                                }
                                if (value.length != AppConstants.phoneLength) {
                                  return 'رقم الهاتف يجب أن يكون ${AppConstants.phoneLength} أرقام';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          
                          // كلمة المرور
                          CustomTextField(
                            controller: _pinController,
                            labelText: 'كلمة المرور',
                            hintText: '8 خانات (حروف وأرقام)',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscurePin,
                            prefixIcon: Icons.lock,
                            maxLength: AppConstants.pinLength,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePin
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePin = !_obscurePin;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور';
                              }
                              if (value.length != AppConstants.pinLength) {
                                return 'كلمة المرور يجب أن تكون ${AppConstants.pinLength} خانات';
                              }
                              final hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
                              final hasDigit = value.contains(RegExp(r'[0-9]'));
                              if (!hasLetter || !hasDigit) {
                                return 'يجب أن تحتوي على حروف وأرقام معاً';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          
                          // رابط نسيت الرقم السري
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/forgot_password'),
                              child: const Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          
                          // زر تسجيل الدخول
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return CustomButton(
                                text: 'تسجيل الدخول',
                                onPressed: authProvider.isLoading ? null : _handleLogin,
                                isLoading: authProvider.isLoading,
                              );
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          
                          // رسالة الخطأ
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              if (authProvider.errorMessage != null) {
                                return Container(
                                  padding: const EdgeInsets.all(AppSizes.paddingM),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: AppColors.error,
                                      ),
                                      const SizedBox(width: AppSizes.paddingS),
                                      Expanded(
                                        child: Text(
                                          authProvider.errorMessage!,
                                          style: const TextStyle(
                                            color: AppColors.error,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          
                          // رابط التسجيل
                          const SizedBox(height: AppSizes.paddingM),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'سجل الآن',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // زر التجربة في الأسفل
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueYellowGradient,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingL, 0, AppSizes.paddingL, AppSizes.paddingM),
            child: GestureDetector(
              onTap: _handleDemoLogin,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline_rounded,
                        color: AppColors.primaryBlue, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'جرب التطبيق بدون حساب',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await BeepayTransitionOverlay.show(
        context: context,
        operation: () async {
          final success = await authProvider.login(
            '+967${_phoneController.text}',
            _pinController.text,
          );
          if (!success) {
            // خطأ مصادقة (كلمة مرور خاطئة) — يُغلق الـ overlay فوراً
            throw Exception(authProvider.errorMessage ?? 'login_failed');
          }
          await NotificationService.initialize();
        },
        onDone: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    }
  }

  Future<void> _handleDemoLogin() async {
    ApiService.enableDemoMode();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await BeepayTransitionOverlay.show(
      context: context,
      operation: () async => authProvider.loginAsGuest(),
      onDone: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}
