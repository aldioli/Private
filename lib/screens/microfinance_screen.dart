import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MicrofinanceScreen extends StatefulWidget {
  const MicrofinanceScreen({super.key});

  @override
  State<MicrofinanceScreen> createState() => _MicrofinanceScreenState();
}

class _LoanProduct {
  final String id;
  final String name;
  final String description;
  final double minAmount;
  final double maxAmount;
  final int maxMonths;
  final double monthlyRate; // %
  final Color color;
  final IconData icon;
  final List<String> requirements;

  const _LoanProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.minAmount,
    required this.maxAmount,
    required this.maxMonths,
    required this.monthlyRate,
    required this.color,
    required this.icon,
    required this.requirements,
  });
}

class _MicrofinanceScreenState extends State<MicrofinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_LoanProduct> _products = const [
    _LoanProduct(
      id: 'l1',
      name: 'قرض شخصي سريع',
      description: 'قرض فوري لتغطية احتياجاتك اليومية والطارئة',
      minAmount: 50000,
      maxAmount: 500000,
      maxMonths: 12,
      monthlyRate: 1.5,
      color: Color(0xFF1565C0),
      icon: Icons.speed_rounded,
      requirements: ['بطاقة هوية سارية', 'كشف حساب 3 أشهر', 'عمل أو دخل ثابت'],
    ),
    _LoanProduct(
      id: 'l2',
      name: 'تمويل تجاري',
      description: 'دعم مشروعك وتوسيع نشاطك التجاري بتمويل مرن',
      minAmount: 200000,
      maxAmount: 5000000,
      maxMonths: 36,
      monthlyRate: 1.2,
      color: Color(0xFF388E3C),
      icon: Icons.store_rounded,
      requirements: [
        'سجل تجاري ساري',
        'كشف حساب 6 أشهر',
        'خطة عمل بسيطة',
        'ضمان أو كفيل',
      ],
    ),
    _LoanProduct(
      id: 'l3',
      name: 'تمويل تعليمي',
      description: 'استثمر في مستقبلك من خلال تمويل دراستك وأبنائك',
      minAmount: 100000,
      maxAmount: 1000000,
      maxMonths: 24,
      monthlyRate: 0.8,
      color: Color(0xFF8E24AA),
      icon: Icons.school_rounded,
      requirements: [
        'وثيقة قبول جامعي',
        'بطاقة هوية ولي الأمر',
        'كشف حساب',
      ],
    ),
    _LoanProduct(
      id: 'l4',
      name: 'قرض السكن',
      description: 'حقق حلم امتلاك منزلك مع شروط ميسرة وأقساط مريحة',
      minAmount: 1000000,
      maxAmount: 20000000,
      maxMonths: 120,
      monthlyRate: 0.9,
      color: Color(0xFFE53935),
      icon: Icons.home_rounded,
      requirements: [
        'بطاقة هوية',
        'عقد عمل أو وثيقة دخل',
        'رسم الأرض أو العقار',
        'كشف حساب 12 شهراً',
        'ضمانات عقارية',
      ],
    ),
  ];

  // قروض نشطة
  final List<Map<String, dynamic>> _activeLoans = const [
    {
      'name': 'قرض شخصي سريع',
      'amount': 300000.0,
      'paid': 150000.0,
      'monthlyInstallment': 27500.0,
      'nextDate': '1 أبريل 2026',
      'remainingMonths': 6,
      'color': Color(0xFF1565C0),
      'icon': Icons.speed_rounded,
    },
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

  void _showProductSheet(_LoanProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LoanApplicationSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التمويل والقروض',
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
            Tab(text: 'منتجات التمويل'),
            Tab(text: 'قروضي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProductsTab(
              products: _products, onApply: _showProductSheet),
          _MyLoansTab(activeLoans: _activeLoans),
        ],
      ),
    );
  }
}

// ======= Tab 1: منتجات =======
class _ProductsTab extends StatelessWidget {
  final List<_LoanProduct> products;
  final void Function(_LoanProduct) onApply;

  const _ProductsTab({required this.products, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // بانر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
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
                      child: const Icon(Icons.account_balance_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('حلول تمويلية مرنة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              )),
                          Text('أقساط ميسرة وإجراءات سريعة',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Cairo',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                Row(
                  children: [
                    _BannerStat('صرف فوري', 'خلال 24 ساعة'),
                    _BannerStat('نسبة فائدة', 'من 0.8% شهرياً'),
                    _BannerStat('بدون ضامن', 'لحد 500 ألف'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ...products.map((p) => _ProductCard(product: p, onApply: () => onApply(p))),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;
  const _BannerStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Cairo',
                fontSize: 11,
              ),
              textAlign: TextAlign.center),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _LoanProduct product;
  final VoidCallback onApply;

  const _ProductCard({required this.product, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final p = product;
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
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.color, p.color.withValues(alpha: 0.7)],
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
                  child: Icon(p.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          )),
                      Text(p.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _InfoChip(
                            'الحد الأقصى',
                            '${(p.maxAmount / 1000000).toStringAsFixed(p.maxAmount >= 1000000 ? 0 : 1)} م ريال',
                            p.color)),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                        child: _InfoChip(
                            'أقصى مدة',
                            '${p.maxMonths} شهر',
                            p.color)),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                        child: _InfoChip(
                            'الفائدة',
                            '${p.monthlyRate}% شهرياً',
                            p.color)),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingS),
                // المتطلبات
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: p.requirements.take(2).map((r) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: p.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(r,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: p.color,
                        )),
                  )).toList(),
                ),
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.color,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                    child: const Text('تقدم بطلب',
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _InfoChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center),
          Text(label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ======= Tab 2: قروضي =======
class _MyLoansTab extends StatelessWidget {
  final List<Map<String, dynamic>> activeLoans;
  const _MyLoansTab({required this.activeLoans});

  @override
  Widget build(BuildContext context) {
    if (activeLoans.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_outlined,
                size: 64, color: AppColors.lightGrey),
            SizedBox(height: 16),
            Text('لا توجد قروض نشطة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 16,
                )),
          ],
        ),
      );
    }

    final totalOwed = activeLoans.fold<double>(
        0, (s, l) => s + ((l['amount'] as double) - (l['paid'] as double)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // ملخص
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: [
                const Text('إجمالي المتبقي',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    )),
                const SizedBox(height: 8),
                Text(
                  '${totalOwed.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${activeLoans.length} قرض نشط',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                    )),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ...activeLoans.map((loan) => _LoanCard(loan: loan)),
        ],
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Map<String, dynamic> loan;
  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final amount = loan['amount'] as double;
    final paid = loan['paid'] as double;
    final progress = paid / amount;
    final color = loan['color'] as Color;

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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(loan['icon'] as IconData,
                    color: color, size: 24),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                    Text(
                        'القسط الشهري: ${(loan['monthlyInstallment'] as double).toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(amount - paid).toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.error,
                    ),
                  ),
                  const Text('متبقي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 11,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          // شريط التقدم
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تم سداد ${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${loan['remainingMonths']} أشهر متبقية',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('كشف القرض',
                      style:
                          TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                ),
              ),
              const SizedBox(width: AppSizes.paddingS),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم سداد القسط بنجاح!',
                            style: TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('سداد القسط',
                      style:
                          TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 14, color: AppColors.grey),
              const SizedBox(width: 4),
              Text('القسط القادم: ${loan['nextDate']}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.grey,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ======= نموذج طلب القرض =======
class _LoanApplicationSheet extends StatefulWidget {
  final _LoanProduct product;
  const _LoanApplicationSheet({required this.product});

  @override
  State<_LoanApplicationSheet> createState() =>
      _LoanApplicationSheetState();
}

class _LoanApplicationSheetState extends State<_LoanApplicationSheet> {
  double _loanAmount = 0;
  int _months = 12;
  bool _submitting = false;
  final _ctrl = TextEditingController();

  double get _monthlyInstallment {
    if (_loanAmount == 0) return 0;
    final r = widget.product.monthlyRate / 100;
    final n = _months;
    if (r == 0) return _loanAmount / n;
    return _loanAmount * r * (1 + r).toDouble() / ((1 + r).toInt() - 1);
  }

  double get _totalRepayment => _monthlyInstallment * _months;
  double get _totalInterest => _totalRepayment - _loanAmount;

  void _apply() {
    if (_loanAmount < widget.product.minAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'الحد الأدنى ${widget.product.minAmount.toStringAsFixed(0)} ريال',
              style: const TextStyle(fontFamily: 'Cairo')),
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
          content: Text('تم تقديم طلبك! سيتم مراجعته خلال 24 ساعة.',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
                Icon(p.icon, color: Colors.white, size: 28),
                const SizedBox(width: AppSizes.paddingM),
                Text(p.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    )),
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
                  // مبلغ القرض
                  const Text('مبلغ القرض المطلوب',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ctrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        setState(() => _loanAmount = double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      hintText:
                          '${p.minAmount.toStringAsFixed(0)} – ${p.maxAmount.toStringAsFixed(0)} ريال',
                      suffixText: 'ريال',
                      hintStyle: const TextStyle(fontFamily: 'Cairo'),
                      suffixStyle: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  // مدة القرض
                  const Text('مدة السداد',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [3, 6, 12, 18, 24, 36]
                        .where((m) => m <= p.maxMonths)
                        .map((m) {
                      final sel = m == _months;
                      return GestureDetector(
                        onTap: () => setState(() => _months = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? p.color : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? p.color : AppColors.lightGrey,
                            ),
                          ),
                          child: Text('$m شهر',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: sel ? Colors.white : AppColors.grey,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  // ملخص القرض
                  if (_loanAmount > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: p.color.withValues(alpha: 0.05),
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        border:
                            Border.all(color: p.color.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ملخص القرض',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                color: p.color,
                              )),
                          const SizedBox(height: AppSizes.paddingS),
                          _SummaryRow('القسط الشهري',
                              '${_monthlyInstallment.toStringAsFixed(0)} ريال'),
                          _SummaryRow('إجمالي السداد',
                              '${_totalRepayment.toStringAsFixed(0)} ريال'),
                          _SummaryRow('إجمالي الفائدة',
                              '${_totalInterest.toStringAsFixed(0)} ريال'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                  ],
                  // الوثائق المطلوبة
                  const Text('الوثائق المطلوبة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...p.requirements.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(Icons.radio_button_checked,
                                color: p.color, size: 16),
                            const SizedBox(width: 8),
                            Text(r,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: AppColors.grey,
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
                onPressed: _submitting ? null : _apply,
                style: ElevatedButton.styleFrom(backgroundColor: p.color),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('تقديم الطلب',
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.grey,
              )),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
