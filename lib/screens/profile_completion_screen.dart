import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

/// شاشة استكمال الملف الشخصي — wizard متعدد الخطوات بعد التسجيل
class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  final int _totalSteps = 4;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // Step 0: بيانات شخصية
  final _nameCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  String _gender = 'ذكر';
  String _city = 'صنعاء';

  // Step 1: عنوان السكن
  final _addressCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  String _governorate = 'صنعاء';

  // Step 2: معلومات مهنية
  final _jobCtrl = TextEditingController();
  final _employerCtrl = TextEditingController();
  String _incomeRange = 'أقل من 100,000';

  // Step 3: اهتمامات
  final Set<String> _selectedInterests = {};

  final List<String> _cities = [
    'صنعاء', 'عدن', 'تعز', 'حضرموت', 'الحديدة',
    'إب', 'المكلا', 'ذمار', 'عمران', 'البيضاء',
  ];

  final List<String> _incomeRanges = [
    'أقل من 100,000',
    '100,000 – 300,000',
    '300,000 – 700,000',
    '700,000 – 1,500,000',
    'أكثر من 1,500,000',
  ];

  final List<Map<String, dynamic>> _interests = [
    {'label': 'التسوق', 'icon': Icons.shopping_bag_rounded, 'color': Color(0xFF1565C0)},
    {'label': 'السفر', 'icon': Icons.flight_rounded, 'color': Color(0xFF0097A7)},
    {'label': 'الاستثمار', 'icon': Icons.trending_up_rounded, 'color': Color(0xFF1B5E20)},
    {'label': 'الطعام', 'icon': Icons.restaurant_rounded, 'color': Color(0xFFE53935)},
    {'label': 'الترفيه', 'icon': Icons.movie_rounded, 'color': Color(0xFF8E24AA)},
    {'label': 'التعليم', 'icon': Icons.school_rounded, 'color': Color(0xFF00897B)},
    {'label': 'الصحة', 'icon': Icons.local_hospital_rounded, 'color': Color(0xFF388E3C)},
    {'label': 'التكنولوجيا', 'icon': Icons.devices_rounded, 'color': Color(0xFF1976D2)},
    {'label': 'الرياضة', 'icon': Icons.sports_rounded, 'color': Color(0xFFFFA000)},
    {'label': 'الأعمال', 'icon': Icons.business_rounded, 'color': Color(0xFF5E35B1)},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameCtrl.dispose();
    _birthCtrl.dispose();
    _addressCtrl.dispose();
    _streetCtrl.dispose();
    _jobCtrl.dispose();
    _employerCtrl.dispose();
    super.dispose();
  }

  void _next() async {
    await _fadeController.reverse();
    setState(() => _step++);
    _fadeController.forward();
  }

  void _back() async {
    await _fadeController.reverse();
    setState(() => _step--);
    _fadeController.forward();
  }

  void _finish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم استكمال ملفك الشخصي بنجاح! 🎉',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (route) => false);
  }

  double get _progress => (_step + 1) / _totalSteps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: _back,
              )
            : null,
        title: Text(
          'استكمال الملف الشخصي',
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: _finish,
            child: const Text('تخطي',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.lightGrey,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            minHeight: 6,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildPersonalInfo();
      case 1:
        return _buildAddress();
      case 2:
        return _buildProfessional();
      case 3:
        return _buildInterests();
      default:
        return const SizedBox.shrink();
    }
  }

  // ===== Step 0: بيانات شخصية =====
  Widget _buildPersonalInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            icon: Icons.person_rounded,
            title: 'بياناتك الشخصية',
            subtitle: 'الخطوة 1 من $_totalSteps',
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: AppSizes.paddingL),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'الاسم الكامل',
              prefixIcon: Icon(Icons.person_outline_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          const SizedBox(height: AppSizes.paddingM),
          TextField(
            controller: _birthCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'تاريخ الميلاد',
              prefixIcon: Icon(Icons.cake_rounded),
              hintText: 'اضغط للاختيار',
              labelStyle: TextStyle(fontFamily: 'Cairo'),
              hintStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1995),
                firstDate: DateTime(1950),
                lastDate: DateTime.now().subtract(
                    const Duration(days: 365 * 18)),
              );
              if (picked != null) {
                _birthCtrl.text =
                    '${picked.day}/${picked.month}/${picked.year}';
              }
            },
          ),
          const SizedBox(height: AppSizes.paddingM),
          const Text('الجنس',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: ['ذكر', 'أنثى'].map((g) {
              final sel = g == _gender;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _gender = g),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.primaryBlue
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(
                            AppSizes.borderRadius),
                        border: Border.all(
                          color: sel
                              ? AppColors.primaryBlue
                              : AppColors.lightGrey,
                        ),
                      ),
                      child: Text(
                        g,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingM),
          DropdownButtonFormField<String>(
            value: _city,
            decoration: const InputDecoration(
              labelText: 'المدينة',
              prefixIcon: Icon(Icons.location_city_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            items: _cities
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c,
                          style: const TextStyle(fontFamily: 'Cairo')),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _city = v!),
            style: const TextStyle(
                fontFamily: 'Cairo', color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.paddingXL),
          _NextButton(onTap: _next),
        ],
      ),
    );
  }

  // ===== Step 1: العنوان =====
  Widget _buildAddress() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            icon: Icons.home_rounded,
            title: 'عنوان السكن',
            subtitle: 'الخطوة 2 من $_totalSteps',
            color: const Color(0xFF388E3C),
          ),
          const SizedBox(height: AppSizes.paddingL),
          DropdownButtonFormField<String>(
            value: _governorate,
            decoration: const InputDecoration(
              labelText: 'المحافظة',
              prefixIcon: Icon(Icons.map_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            items: _cities
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c,
                          style: const TextStyle(fontFamily: 'Cairo')),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _governorate = v!),
            style: const TextStyle(
                fontFamily: 'Cairo', color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.paddingM),
          TextField(
            controller: _addressCtrl,
            decoration: const InputDecoration(
              labelText: 'الحي / المنطقة',
              prefixIcon: Icon(Icons.location_on_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          const SizedBox(height: AppSizes.paddingM),
          TextField(
            controller: _streetCtrl,
            decoration: const InputDecoration(
              labelText: 'الشارع / التفاصيل',
              prefixIcon: Icon(Icons.signpost_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
            maxLines: 2,
          ),
          const SizedBox(height: AppSizes.paddingXL),
          _NextButton(onTap: _next),
        ],
      ),
    );
  }

  // ===== Step 2: مهني =====
  Widget _buildProfessional() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            icon: Icons.work_rounded,
            title: 'المعلومات المهنية',
            subtitle: 'الخطوة 3 من $_totalSteps',
            color: const Color(0xFF8E24AA),
          ),
          const SizedBox(height: AppSizes.paddingL),
          TextField(
            controller: _jobCtrl,
            decoration: const InputDecoration(
              labelText: 'المسمى الوظيفي',
              prefixIcon: Icon(Icons.badge_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          const SizedBox(height: AppSizes.paddingM),
          TextField(
            controller: _employerCtrl,
            decoration: const InputDecoration(
              labelText: 'جهة العمل',
              prefixIcon: Icon(Icons.business_rounded),
              labelStyle: TextStyle(fontFamily: 'Cairo'),
            ),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          const SizedBox(height: AppSizes.paddingM),
          const Text('الدخل الشهري (ريال يمني)',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 8),
          ..._incomeRanges.map((r) {
            final sel = r == _incomeRange;
            return GestureDetector(
              onTap: () => setState(() => _incomeRange = r),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM, vertical: 12),
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.primaryBlue.withValues(alpha: 0.08)
                      : AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(
                    color: sel
                        ? AppColors.primaryBlue
                        : AppColors.lightGrey,
                    width: sel ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      sel
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: sel
                          ? AppColors.primaryBlue
                          : AppColors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(r,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: sel
                              ? AppColors.primaryBlue
                              : AppColors.textPrimary,
                          fontWeight: sel
                              ? FontWeight.w600
                              : FontWeight.normal,
                        )),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSizes.paddingL),
          _NextButton(onTap: _next),
        ],
      ),
    );
  }

  // ===== Step 3: اهتمامات =====
  Widget _buildInterests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            icon: Icons.favorite_rounded,
            title: 'اهتماماتك',
            subtitle: 'الخطوة 4 من $_totalSteps',
            color: const Color(0xFFE53935),
          ),
          const SizedBox(height: 8),
          const Text(
            'اختر 3 اهتمامات على الأقل لنخصص لك تجربة أفضل',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          Wrap(
            spacing: AppSizes.paddingS,
            runSpacing: AppSizes.paddingS,
            children: _interests.map((interest) {
              final label = interest['label'] as String;
              final icon = interest['icon'] as IconData;
              final color = interest['color'] as Color;
              final sel = _selectedInterests.contains(label);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (sel) {
                      _selectedInterests.remove(label);
                    } else {
                      _selectedInterests.add(label);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? color : AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: sel ? color : AppColors.lightGrey,
                      width: sel ? 2 : 1,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon,
                          color: sel ? Colors.white : color,
                          size: 18),
                      const SizedBox(width: 6),
                      Text(label,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : AppColors.textPrimary,
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingL),
          if (_selectedInterests.length >= 3) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadius),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ممتاز! اخترت ${_selectedInterests.length} اهتمامات',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
          ],
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: _selectedInterests.length >= 3 ? _finish : null,
              child: const Text('إنهاء الإعداد',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StepHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            Text(subtitle,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 13,
                )),
          ],
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        child: const Text('التالي',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}
