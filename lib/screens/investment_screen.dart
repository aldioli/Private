import 'package:flutter/material.dart';
import '../utils/constants.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({super.key});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _Plan {
  final String id;
  final String name;
  final String description;
  final double minAmount;
  final double returnRate; // سنوي %
  final int durationMonths;
  final Color color;
  final IconData icon;
  final String riskLevel;
  final Color riskColor;

  const _Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.minAmount,
    required this.returnRate,
    required this.durationMonths,
    required this.color,
    required this.icon,
    required this.riskLevel,
    required this.riskColor,
  });
}

class _MyInvestment {
  final String planName;
  final double amount;
  final double currentValue;
  final String startDate;
  final int durationMonths;
  final Color color;
  final IconData icon;
  final double returnRate;

  const _MyInvestment({
    required this.planName,
    required this.amount,
    required this.currentValue,
    required this.startDate,
    required this.durationMonths,
    required this.color,
    required this.icon,
    required this.returnRate,
  });

  double get profit => currentValue - amount;
  double get profitPct => (profit / amount) * 100;
}

class _InvestmentScreenState extends State<InvestmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_Plan> _plans = const [
    _Plan(
      id: 'p1',
      name: 'حساب التوفير المعزز',
      description:
          'استثمار آمن بعائد ثابت. مناسب للمستثمرين المحافظين الذين يريدون حفظ رأس المال مع نمو مضمون.',
      minAmount: 50000,
      returnRate: 8.5,
      durationMonths: 6,
      color: Color(0xFF1565C0),
      icon: Icons.savings_rounded,
      riskLevel: 'منخفض',
      riskColor: Color(0xFF388E3C),
    ),
    _Plan(
      id: 'p2',
      name: 'باقة النمو الذهبية',
      description:
          'عائد أعلى مع مستوى مخاطرة متوسط. مثالية للمستثمرين الذين يبحثون عن نمو متوازن لرأس مالهم.',
      minAmount: 200000,
      returnRate: 14.0,
      durationMonths: 12,
      color: Color(0xFFFFA000),
      icon: Icons.trending_up_rounded,
      riskLevel: 'متوسط',
      riskColor: Color(0xFFFFA000),
    ),
    _Plan(
      id: 'p3',
      name: 'محفظة العائد الممتاز',
      description:
          'أعلى عائد متاح مع مستوى مخاطرة أعلى. للمستثمرين ذوي الخبرة الراغبين في تعظيم العوائد.',
      minAmount: 500000,
      returnRate: 22.0,
      durationMonths: 24,
      color: Color(0xFF8E24AA),
      icon: Icons.rocket_launch_rounded,
      riskLevel: 'مرتفع',
      riskColor: Color(0xFFE53935),
    ),
    _Plan(
      id: 'p4',
      name: 'استثمار ذهب',
      description:
          'استثمار في الذهب بعوائد مرتبطة بأسعار السوق الدولية. ملاذ آمن ضد التضخم.',
      minAmount: 100000,
      returnRate: 11.0,
      durationMonths: 12,
      color: Color(0xFFFFD600),
      icon: Icons.diamond_rounded,
      riskLevel: 'متوسط',
      riskColor: Color(0xFFFFA000),
    ),
  ];

  final List<_MyInvestment> _myInvestments = const [
    _MyInvestment(
      planName: 'حساب التوفير المعزز',
      amount: 100000,
      currentValue: 106500,
      startDate: '1 سبتمبر 2025',
      durationMonths: 6,
      color: Color(0xFF1565C0),
      icon: Icons.savings_rounded,
      returnRate: 8.5,
    ),
    _MyInvestment(
      planName: 'باقة النمو الذهبية',
      amount: 250000,
      currentValue: 278000,
      startDate: '15 أكتوبر 2025',
      durationMonths: 12,
      color: Color(0xFFFFA000),
      icon: Icons.trending_up_rounded,
      returnRate: 14.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPlanDetails(_Plan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlanDetailsSheet(plan: plan),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الاستثمار',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'خطط الاستثمار'),
            Tab(text: 'استثماراتي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PlansTab(plans: _plans, onTap: _showPlanDetails),
          _MyInvestmentsTab(investments: _myInvestments),
        ],
      ),
    );
  }
}

// ======= Tab 1: خطط الاستثمار =======
class _PlansTab extends StatelessWidget {
  final List<_Plan> plans;
  final void Function(_Plan) onTap;

  const _PlansTab({required this.plans, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // بانر تعريفي
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.bar_chart_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'استثمر أموالك بذكاء',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            'عوائد تصل إلى 22% سنوياً',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                const Text(
                  'اختر الخطة التي تناسب أهدافك المالية واستمتع بعوائد مجزية على استثماراتك.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ...plans.map((p) => _PlanCard(plan: p, onTap: () => onTap(p))),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
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
          // رأس البطاقة
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
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: plan.riskColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'مخاطرة ${plan.riskLevel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // تفاصيل الخطة
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Text(
                  plan.description,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'العائد السنوي',
                        value: '${plan.returnRate}%',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                      child: _StatBox(
                        label: 'المدة',
                        value: '${plan.durationMonths} شهر',
                        color: plan.color,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                      child: _StatBox(
                        label: 'الحد الأدنى',
                        value:
                            '${(plan.minAmount / 1000).toStringAsFixed(0)}K ر',
                        color: AppColors.grey,
                      ),
                    ),
                  ],
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
                    child: const Text('استثمر الآن',
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ======= BottomSheet تفاصيل الخطة + نموذج الاستثمار =======
class _PlanDetailsSheet extends StatefulWidget {
  final _Plan plan;
  const _PlanDetailsSheet({required this.plan});

  @override
  State<_PlanDetailsSheet> createState() => _PlanDetailsSheetState();
}

class _PlanDetailsSheetState extends State<_PlanDetailsSheet> {
  final _ctrl = TextEditingController();
  double _amount = 0;
  bool _submitting = false;

  double get _monthlyReturn =>
      _amount * (widget.plan.returnRate / 100) / 12;
  double get _totalReturn =>
      _amount * (widget.plan.returnRate / 100) *
      (widget.plan.durationMonths / 12);
  double get _totalAtEnd => _amount + _totalReturn;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _invest() {
    if (_amount < widget.plan.minAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الحد الأدنى للاستثمار ${widget.plan.minAmount.toStringAsFixed(0)} ريال',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تفعيل خطة الاستثمار بنجاح!',
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
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
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
                Icon(p.icon, color: Colors.white, size: 32),
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
                      Text('عائد ${p.returnRate}% سنوياً • ${p.durationMonths} شهر',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // حقل المبلغ
                  const Text('مبلغ الاستثمار',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ctrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        setState(() => _amount = double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      hintText:
                          'الحد الأدنى: ${p.minAmount.toStringAsFixed(0)} ريال',
                      suffixText: 'ريال',
                      hintStyle: const TextStyle(fontFamily: 'Cairo'),
                      suffixStyle: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // توقعات العائد
                  if (_amount >= p.minAmount) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.05),
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('توقعات العائد',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              )),
                          const SizedBox(height: AppSizes.paddingS),
                          _ReturnRow('العائد الشهري',
                              '${_monthlyReturn.toStringAsFixed(0)} ريال'),
                          _ReturnRow('إجمالي العائد',
                              '${_totalReturn.toStringAsFixed(0)} ريال'),
                          _ReturnRow('القيمة الإجمالية عند الانتهاء',
                              '${_totalAtEnd.toStringAsFixed(0)} ريال',
                              bold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                  ],

                  // شروط
                  const Text('الشروط والأحكام',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...[
                    'يمكن سحب الاستثمار بعد انتهاء المدة المحددة',
                    'في حال السحب المبكر يطبق خصم 2% من العائد',
                    'العوائد تحسب ويُعلن عنها شهرياً',
                    'الاستثمار مضمون حتى 5 مليون ريال',
                  ].map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: p.color, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(t,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    color: AppColors.grey,
                                    height: 1.4,
                                  )),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: AppSizes.paddingL),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.paddingM,
              right: AppSizes.paddingM,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  AppSizes.paddingL,
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _submitting ? null : _invest,
                style: ElevatedButton.styleFrom(backgroundColor: p.color),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('تأكيد الاستثمار',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _ReturnRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: bold ? AppColors.success : AppColors.grey,
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.w600,
                color: AppColors.success,
              )),
        ],
      ),
    );
  }
}

// ======= Tab 2: استثماراتي =======
class _MyInvestmentsTab extends StatelessWidget {
  final List<_MyInvestment> investments;

  const _MyInvestmentsTab({required this.investments});

  @override
  Widget build(BuildContext context) {
    final totalInvested =
        investments.fold<double>(0, (s, i) => s + i.amount);
    final totalCurrent =
        investments.fold<double>(0, (s, i) => s + i.currentValue);
    final totalProfit = totalCurrent - totalInvested;
    final totalPct = (totalProfit / totalInvested) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // ملخص المحفظة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: [
                const Text('إجمالي محفظتي الاستثمارية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    )),
                const SizedBox(height: 8),
                Text(
                  '${totalCurrent.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.trending_up_rounded,
                        color: Colors.white70, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '+${totalProfit.toStringAsFixed(0)} ريال (${totalPct.toStringAsFixed(1)}%)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: _PortfolioStat(
                        label: 'المستثمر',
                        value: '${(totalInvested / 1000).toStringAsFixed(0)}K',
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.white24),
                    Expanded(
                      child: _PortfolioStat(
                        label: 'الأرباح',
                        value: '+${(totalProfit / 1000).toStringAsFixed(1)}K',
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.white24),
                    Expanded(
                      child: _PortfolioStat(
                        label: 'استثمارات نشطة',
                        value: '${investments.length}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ...investments.map((inv) => _InvestmentCard(inv: inv)),
        ],
      ),
    );
  }
}

class _PortfolioStat extends StatelessWidget {
  final String label;
  final String value;
  const _PortfolioStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        Text(label,
            style: const TextStyle(
              color: Colors.white60,
              fontFamily: 'Cairo',
              fontSize: 12,
            )),
      ],
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  final _MyInvestment inv;
  const _InvestmentCard({required this.inv});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: inv.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(inv.icon, color: inv.color, size: 24),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(inv.planName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                    Text('منذ ${inv.startDate} • ${inv.durationMonths} شهر',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${inv.currentValue.toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '+${inv.profit.toStringAsFixed(0)} (${inv.profitPct.toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (inv.profitPct / inv.returnRate).clamp(0.0, 1.0),
              backgroundColor: inv.color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(inv.color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المبلغ المستثمر: ${inv.amount.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.grey,
                  )),
              Text('العائد: ${inv.returnRate}% سنوياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: inv.color,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
