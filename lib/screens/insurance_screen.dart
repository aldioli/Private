import 'package:flutter/material.dart';
import '../utils/constants.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsurancePlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPremium;
  final double coverage;
  final List<String> features;
  final Color color;
  final IconData icon;
  final String category;

  const _InsurancePlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPremium,
    required this.coverage,
    required this.features,
    required this.color,
    required this.icon,
    required this.category,
  });
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'صحي',
    'حياة',
    'سفر',
    'سيارة',
    'ممتلكات',
  ];

  final List<_InsurancePlan> _plans = const [
    _InsurancePlan(
      id: 'i1',
      name: 'تأمين صحي شامل',
      description: 'تغطية طبية كاملة للفرد والعائلة مع شبكة مستشفيات واسعة',
      monthlyPremium: 15000,
      coverage: 5000000,
      features: [
        'تغطية المستشفيات والعيادات',
        'الأدوية والعمليات الجراحية',
        'طب الأسنان والنظارات',
        'إسعاف وطوارئ 24/7',
        'علاج الأمراض المزمنة',
      ],
      color: Color(0xFF1565C0),
      icon: Icons.medical_services_rounded,
      category: 'صحي',
    ),
    _InsurancePlan(
      id: 'i2',
      name: 'تأمين على الحياة',
      description: 'ضمان مستقبل أسرتك وتأمين الحماية المالية للمستقبل',
      monthlyPremium: 8000,
      coverage: 20000000,
      features: [
        'تغطية الوفاة بأي سبب',
        'تعويض العجز الكلي والجزئي',
        'مستحقات شهرية للعائلة',
        'إعفاء من الأقساط عند العجز',
        'قيمة استردادية بعد 5 سنوات',
      ],
      color: Color(0xFF1B5E20),
      icon: Icons.favorite_rounded,
      category: 'حياة',
    ),
    _InsurancePlan(
      id: 'i3',
      name: 'تأمين السفر الدولي',
      description: 'سافر بأمان واطمئنان مع تغطية شاملة خلال رحلاتك',
      monthlyPremium: 3500,
      coverage: 3000000,
      features: [
        'طوارئ طبية في الخارج',
        'إلغاء وتأخير الرحلات',
        'فقدان الأمتعة والوثائق',
        'مسؤولية مدنية شخصية',
        'إجلاء طبي دولي',
      ],
      color: Color(0xFF0097A7),
      icon: Icons.flight_rounded,
      category: 'سفر',
    ),
    _InsurancePlan(
      id: 'i4',
      name: 'تأمين السيارة الشامل',
      description: 'حماية كاملة لسيارتك من الحوادث والسرقة والأضرار',
      monthlyPremium: 12000,
      coverage: 8000000,
      features: [
        'أضرار الحوادث الشاملة',
        'سرقة المركبة',
        'كوارث طبيعية وحرائق',
        'مسؤولية الطرف الثالث',
        'سيارة بديلة مؤقتة',
      ],
      color: Color(0xFF8E24AA),
      icon: Icons.directions_car_rounded,
      category: 'سيارة',
    ),
    _InsurancePlan(
      id: 'i5',
      name: 'تأمين الممتلكات',
      description: 'حماية منزلك ومحتوياته من المخاطر المختلفة',
      monthlyPremium: 5000,
      coverage: 10000000,
      features: [
        'حريق وانفجار',
        'فيضان وكوارث طبيعية',
        'سرقة ونهب',
        'أضرار المياه والكهرباء',
        'مسؤولية المستأجر',
      ],
      color: Color(0xFFE53935),
      icon: Icons.home_rounded,
      category: 'ممتلكات',
    ),
  ];

  // تأمينات نشطة (مشتراة)
  final List<Map<String, dynamic>> _activePlans = const [
    {
      'name': 'تأمين صحي شامل',
      'policyNo': 'YP-INS-2025-0481',
      'startDate': '1 يناير 2026',
      'endDate': '31 ديسمبر 2026',
      'premium': 15000.0,
      'coverage': 5000000.0,
      'color': Color(0xFF1565C0),
      'icon': Icons.medical_services_rounded,
      'status': 'نشط',
    },
  ];

  List<_InsurancePlan> get _filtered {
    if (_selectedCategory == 'الكل') return _plans;
    return _plans.where((p) => p.category == _selectedCategory).toList();
  }

  void _showPlanSheet(_InsurancePlan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InsurancePlanSheet(plan: plan),
    );
  }

  void _showActivePlanDetails(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: (plan['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(plan['icon'] as IconData,
                      color: plan['color'] as Color, size: 24),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      Text(plan['policyNo'] as String,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
            _DetailRow('تاريخ الإصدار', plan['startDate'] as String),
            _DetailRow('تاريخ الانتهاء', plan['endDate'] as String),
            _DetailRow('القسط الشهري',
                '${(plan['premium'] as double).toStringAsFixed(0)} ريال'),
            _DetailRow('مبلغ التأمين',
                '${((plan['coverage'] as double) / 1000000).toStringAsFixed(0)} مليون ريال'),
            _DetailRow('الحالة', plan['status'] as String),
            const SizedBox(height: AppSizes.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.download_rounded),
                label: const Text('تحميل وثيقة التأمين',
                    style: TextStyle(fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التأمين',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // التأمينات النشطة
            if (_activePlans.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingM, AppSizes.paddingM, AppSizes.paddingM, 0),
                child: const Text(
                  'تأميناتي النشطة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              ..._activePlans.map((p) => _ActivePlanCard(
                    plan: p,
                    onTap: () => _showActivePlanDetails(p),
                  )),
            ],

            // فلتر التصنيف
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
              margin: const EdgeInsets.only(top: AppSizes.paddingM),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(cat,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.grey,
                            )),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primaryBlue,
                        checkmarkColor: AppColors.white,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.lightGrey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // خطط التأمين
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingM, AppSizes.paddingM, AppSizes.paddingM, 0),
              child: const Text(
                'خطط التأمين المتاحة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ..._filtered.map((p) => _PlanCard(
                  plan: p,
                  onTap: () => _showPlanSheet(p),
                )),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _ActivePlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onTap;

  const _ActivePlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSizes.paddingM, AppSizes.paddingS, AppSizes.paddingM, 0),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (plan['color'] as Color),
              (plan['color'] as Color).withValues(alpha: 0.7)
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(plan['icon'] as IconData,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      )),
                  Text('ينتهي: ${plan['endDate']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      )),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                plan['status'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _InsurancePlan plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSizes.paddingM, AppSizes.paddingM, AppSizes.paddingM, 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [plan.color, plan.color.withValues(alpha: 0.7)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSizes.borderRadiusLarge),
                topLeft: Radius.circular(AppSizes.borderRadiusLarge),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(plan.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          )),
                      Text(plan.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Cairo',
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan.monthlyPremium.toStringAsFixed(0)} ريال',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Text(
                      'شهرياً',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // جسم
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.description,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      height: 1.4,
                    )),
                const SizedBox(height: AppSizes.paddingS),
                Text(
                  'التغطية: ${(plan.coverage / 1000000).toStringAsFixed(0)} مليون ريال',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: plan.color,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: plan.features.take(3).map((f) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: plan.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(f,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: plan.color,
                        )),
                  )).toList(),
                ),
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.color,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                    child: const Text('اشترك الآن',
                        style: TextStyle(fontFamily: 'Cairo')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 14)),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

// ======= نافذة تفاصيل الخطة =======
class _InsurancePlanSheet extends StatefulWidget {
  final _InsurancePlan plan;
  const _InsurancePlanSheet({required this.plan});

  @override
  State<_InsurancePlanSheet> createState() => _InsurancePlanSheetState();
}

class _InsurancePlanSheetState extends State<_InsurancePlanSheet> {
  bool _subscribing = false;

  void _subscribe() {
    setState(() => _subscribing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الاشتراك بنجاح! ستصلك وثيقة التأمين قريباً.',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.plan;
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(AppSizes.paddingM),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.color, p.color.withValues(alpha: 0.7)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Row(
              children: [
                Icon(p.icon, color: Colors.white, size: 30),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          )),
                      Text('${p.monthlyPremium.toStringAsFixed(0)} ريال/شهر',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow('مبلغ التأمين',
                      '${(p.coverage / 1000000).toStringAsFixed(0)} مليون ريال'),
                  _DetailRow('القسط الشهري',
                      '${p.monthlyPremium.toStringAsFixed(0)} ريال'),
                  _DetailRow('القسط السنوي',
                      '${(p.monthlyPremium * 12).toStringAsFixed(0)} ريال'),
                  const Divider(height: 24),
                  const Text('ما يشمله التأمين',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                  const SizedBox(height: AppSizes.paddingS),
                  ...p.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: p.color, size: 20),
                            const SizedBox(width: 8),
                            Text(f,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      )),
                  const SizedBox(height: AppSizes.paddingL),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingL),
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _subscribing ? null : _subscribe,
                style: ElevatedButton.styleFrom(backgroundColor: p.color),
                child: _subscribing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('اشترك الآن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
