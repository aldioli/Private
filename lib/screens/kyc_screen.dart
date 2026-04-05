import 'package:flutter/material.dart';
import '../utils/constants.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0; // 0=اختيار نوع الهوية, 1=الوجه الأمامي, 2=الوجه الخلفي, 3=سيلفي, 4=مراجعة
  String? _idType;
  bool _frontUploaded = false;
  bool _backUploaded = false;
  bool _selfieUploaded = false;
  bool _submitting = false;

  late AnimationController _anim;
  late Animation<double> _fade;

  final _idTypes = [
    {'label': 'بطاقة الهوية الوطنية', 'icon': Icons.credit_card_rounded, 'color': AppColors.primaryBlue},
    {'label': 'جواز السفر', 'icon': Icons.book_rounded, 'color': AppColors.success},
    {'label': 'رخصة القيادة', 'icon': Icons.directions_car_rounded, 'color': AppColors.warning},
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _nextStep() async {
    await _anim.reverse();
    setState(() => _step++);
    _anim.forward();
  }

  Future<void> _simulateUpload(VoidCallback onDone) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(onDone);
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _step = 4;
    });
    _anim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('توثيق الهوية', style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        leading: _step > 0 && _step < 4
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () async {
                  await _anim.reverse();
                  setState(() => _step--);
                  _anim.forward();
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // شريط التقدم
          if (_step < 4) _StepsBar(step: _step),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: _buildStep(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isDark) {
    switch (_step) {
      case 0:
        return _buildIdTypeStep(isDark);
      case 1:
        return _buildUploadStep(
          isDark,
          title: 'صورة الوجه الأمامي',
          subtitle: 'التقط أو ارفع صورة واضحة للوجه الأمامي لـ "$_idType"',
          icon: Icons.document_scanner_rounded,
          isUploaded: _frontUploaded,
          color: AppColors.primaryBlue,
          onUpload: () => _simulateUpload(() => _frontUploaded = true),
          onNext: _nextStep,
        );
      case 2:
        return _buildUploadStep(
          isDark,
          title: 'صورة الوجه الخلفي',
          subtitle: 'التقط أو ارفع صورة واضحة للوجه الخلفي لـ "$_idType"',
          icon: Icons.flip_rounded,
          isUploaded: _backUploaded,
          color: const Color(0xFF6C63FF),
          onUpload: () => _simulateUpload(() => _backUploaded = true),
          onNext: _nextStep,
        );
      case 3:
        return _buildSelfieStep(isDark);
      case 4:
        return _buildSuccessStep(isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildIdTypeStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر نوع الهوية',
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'سيتم استخدام هذه الوثيقة للتحقق من هويتك وتفعيل حسابك الكامل.',
            style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ..._idTypes.map((type) {
            final selected = _idType == type['label'];
            final color = type['color'] as Color;
            return GestureDetector(
              onTap: () => setState(() => _idType = type['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: 0.1)
                      : (isDark ? const Color(0xFF1E1E2E) : AppColors.white),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                  border: Border.all(
                    color: selected ? color : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(type['icon'] as IconData, color: color, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        type['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selected ? color : null,
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle_rounded, color: color, size: 24),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _idType == null ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.lightGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              child: const Text('التالي',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadStep(
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUploaded,
    required Color color,
    required Future<void> Function() onUpload,
    required VoidCallback onNext,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.grey, fontSize: 14)),
          const SizedBox(height: 32),

          // منطقة الرفع
          GestureDetector(
            onTap: isUploaded ? null : () async { await onUpload(); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppColors.success.withValues(alpha: 0.08)
                    : (isDark
                        ? const Color(0xFF1E1E2E)
                        : AppColors.lightGrey.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                border: Border.all(
                  color: isUploaded ? AppColors.success : AppColors.lightGrey,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUploaded ? Icons.check_circle_rounded : icon,
                    size: 60,
                    color: isUploaded ? AppColors.success : color.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUploaded ? 'تم الرفع بنجاح ✓' : 'اضغط لاختيار صورة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isUploaded ? AppColors.success : AppColors.grey,
                    ),
                  ),
                  if (!isUploaded) ...[
                    const SizedBox(height: 4),
                    const Text('JPG أو PNG، بجودة عالية',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.grey)),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // تعليمات
          _TipCard(
            tips: const [
              'تأكد أن الصورة واضحة وغير ضبابية',
              'تجنب الانعكاسات والضوء الساطع',
              'يجب أن تظهر كل حواف الوثيقة',
            ],
            isDark: isDark,
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isUploaded ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.lightGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              child: const Text('التالي',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfieStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('صورة شخصية (سيلفي)',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'التقط صورة شخصية واضحة للتأكد من مطابقتها لصورة الهوية.',
            style: TextStyle(
                fontFamily: 'Cairo', color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 32),

          // إطار الوجه
          Center(
            child: GestureDetector(
              onTap: _selfieUploaded
                  ? null
                  : () => _simulateUpload(() => _selfieUploaded = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 220,
                height: 260,
                decoration: BoxDecoration(
                  color: _selfieUploaded
                      ? AppColors.success.withValues(alpha: 0.08)
                      : (isDark
                          ? const Color(0xFF1E1E2E)
                          : AppColors.lightGrey.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(
                    color: _selfieUploaded
                        ? AppColors.success
                        : AppColors.primaryBlue.withValues(alpha: 0.4),
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selfieUploaded
                          ? Icons.check_circle_rounded
                          : Icons.face_retouching_natural_rounded,
                      size: 80,
                      color: _selfieUploaded
                          ? AppColors.success
                          : AppColors.primaryBlue.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selfieUploaded ? 'تم ✓' : 'اضغط لالتقاط',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: _selfieUploaded
                            ? AppColors.success
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          _TipCard(
            tips: const [
              'انظر مباشرة إلى الكاميرا',
              'تأكد من وجود إضاءة كافية على وجهك',
              'أزل النظارات والقبعات إن أمكن',
            ],
            isDark: isDark,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selfieUploaded && !_submitting ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.lightGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('إرسال للمراجعة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(bool isDark) {
    return FadeTransition(
      opacity: _fade,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.verified_rounded,
                    color: Colors.white, size: 60),
              ),
              const SizedBox(height: 32),
              const Text('تم إرسال طلبك!',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'سيتم مراجعة بياناتك خلال 24-48 ساعة.\nسنرسل لك إشعاراً فور اكتمال التوثيق.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.grey, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        color: AppColors.warning, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('قيد المراجعة',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warning)),
                          Text('حسابك يعمل بصلاحيات محدودة حتى اكتمال التوثيق',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: AppColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                  child: const Text('العودة إلى الرئيسية',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepsBar extends StatelessWidget {
  final int step;
  const _StepsBar({super.key, required this.step});

  static const _labels = ['نوع الهوية', 'الأمامي', 'الخلفي', 'سيلفي'];
  static const _icons = [
    Icons.badge_rounded,
    Icons.image_rounded,
    Icons.flip_rounded,
    Icons.face_retouching_natural_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A2E)
          : AppColors.white,
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final idx = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: idx < step
                    ? AppColors.primaryBlue
                    : AppColors.lightGrey,
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < step;
          final active = idx == step;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? AppColors.success
                      : active
                          ? AppColors.primaryBlue
                          : AppColors.lightGrey,
                ),
                child: Icon(
                  done ? Icons.check_rounded : _icons[idx],
                  size: 18,
                  color: (done || active) ? Colors.white : AppColors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _labels[idx],
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: active ? AppColors.primaryBlue : AppColors.grey,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final List<String> tips;
  final bool isDark;
  const _TipCard({super.key, required this.tips, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_rounded,
                  color: AppColors.primaryBlue, size: 18),
              SizedBox(width: 8),
              Text('نصائح للحصول على نتيجة أفضل',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue)),
            ],
          ),
          const SizedBox(height: 10),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(tip,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: AppColors.grey)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
