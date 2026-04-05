import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  bool _isLoading = false;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _cityController = TextEditingController(text: 'صنعاء');
    _selectedGender = 'ذكر';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase.from('profiles').update({
          'full_name': _nameController.text.trim(),
        }).eq('id', userId);

        if (mounted) {
          await Provider.of<AuthProvider>(context, listen: false).loadUserData();
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تم تحديث الملف الشخصي بنجاح',
                style: TextStyle(fontFamily: 'Cairo')),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي',
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
              // صورة الملف الشخصي
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text[0].toUpperCase()
                              : 'Y',
                          style: const TextStyle(
                            fontSize: 42,
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
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('رفع الصورة قيد التطوير',
                                  style: TextStyle(fontFamily: 'Cairo')),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.accentYellow,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingXL),

              // الحقول
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'المعلومات الأساسية'),
                    const SizedBox(height: AppSizes.paddingM),

                    // الاسم الكامل
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontFamily: 'Cairo'),
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDec(
                        label: 'الاسم الكامل',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'يرجى إدخال الاسم';
                        if (v.trim().length < 3)
                          return 'الاسم قصير جداً';
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // رقم الهاتف (للقراءة فقط)
                    TextFormField(
                      initialValue: user?.phoneNumber ?? '+967 77X XXX XXXX',
                      readOnly: true,
                      style: const TextStyle(
                          fontFamily: 'Cairo', color: AppColors.grey),
                      decoration: _inputDec(
                        label: 'رقم الهاتف',
                        icon: Icons.phone_outlined,
                        hint: 'لا يمكن التعديل',
                        readOnly: true,
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // البريد الإلكتروني
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: 'Cairo'),
                      decoration: _inputDec(
                        label: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) {
                        if (v != null &&
                            v.isNotEmpty &&
                            !v.contains('@'))
                          return 'بريد إلكتروني غير صحيح';
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // المدينة
                    TextFormField(
                      controller: _cityController,
                      style: const TextStyle(fontFamily: 'Cairo'),
                      decoration: _inputDec(
                        label: 'المدينة',
                        icon: Icons.location_city_rounded,
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // الجنس
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      style: const TextStyle(
                          fontFamily: 'Cairo', color: AppColors.black),
                      decoration: _inputDec(
                        label: 'الجنس',
                        icon: Icons.wc_rounded,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'ذكر', child: Text('ذكر', style: TextStyle(fontFamily: 'Cairo'))),
                        DropdownMenuItem(value: 'أنثى', child: Text('أنثى', style: TextStyle(fontFamily: 'Cairo'))),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // معلومات الهوية
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'معلومات الهوية'),
                    const SizedBox(height: AppSizes.paddingM),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              color: AppColors.info, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'لتعديل بيانات الهوية تواصل مع الدعم الفني',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              CustomButton(
                text: 'حفظ التغييرات',
                onPressed: _isLoading ? null : _handleSave,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec({
    required String label,
    required IconData icon,
    String? hint,
    bool readOnly = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
      hintStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
      prefixIcon: Icon(icon, color: readOnly ? AppColors.grey : AppColors.primaryBlue),
      filled: true,
      fillColor: readOnly ? AppColors.lightGrey.withValues(alpha: 0.5) : AppColors.white,
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
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}
