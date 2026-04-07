import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePin = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.paddingL),
                  
                  // الشعار
                  const LogoWidget(size: 80),
                  const SizedBox(height: AppSizes.paddingM),
                  
                  // عنوان
                  const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  
                  // بطاقة التسجيل
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
                        // الاسم الكامل
                        CustomTextField(
                          controller: _fullNameController,
                          labelText: 'الاسم الكامل',
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال الاسم الكامل';
                            }
                            if (value.length < 3) {
                              return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        
                        // رقم الهوية
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomTextField(
                            controller: _nationalIdController,
                            labelText: 'رقم الهوية الوطنية',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.badge,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رقم الهوية';
                              }
                              if (value.length < 6) {
                                return 'رقم الهوية غير صحيح';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),

                        // رقم الهاتف
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
                          hintText: 'حروف كبيرة + صغيرة + أرقام',
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
                            if (value.length < 8) {
                              return 'كلمة المرور يجب أن تكون 8 خانات على الأقل';
                            }
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'يجب أن تحتوي على حرف كبير (A-Z)';
                            }
                            if (!value.contains(RegExp(r'[a-z]'))) {
                              return 'يجب أن تحتوي على حرف صغير (a-z)';
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'يجب أن تحتوي على رقم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        
                        // الشروط والأحكام
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryBlue,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _acceptTerms = !_acceptTerms;
                                  });
                                },
                                child: const Text(
                                  'أوافق على الشروط والأحكام وسياسة الخصوصية',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingL),
                        
                        // زر التسجيل
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomButton(
                              text: 'إنشاء حساب',
                              onPressed: authProvider.isLoading || !_acceptTerms
                                  ? null
                                  : _handleRegister,
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
                        
                        // رابط تسجيل الدخول
                        const SizedBox(height: AppSizes.paddingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'سجل الدخول',
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
                  const SizedBox(height: AppSizes.paddingL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب الموافقة على الشروط والأحكام'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.register(
        fullName: _fullNameController.text,
        phoneNumber: '+967${_phoneController.text}',
        nationalId: _nationalIdController.text,
        pin: _pinController.text,
      );
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }
}
