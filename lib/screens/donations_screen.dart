import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _Charity {
  final String id;
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final double raised;
  final double goal;
  final int donors;

  const _Charity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.raised,
    required this.goal,
    required this.donors,
  });

  double get progress => (raised / goal).clamp(0.0, 1.0);
}

class _DonationsScreenState extends State<DonationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'إغاثة',
    'تعليم',
    'صحة',
    'أيتام',
    'مساجد',
  ];

  final List<_Charity> _charities = const [
    _Charity(
      id: 'c1',
      name: 'إغاثة الأسر المتضررة',
      description: 'دعم الأسر المتضررة من الأزمة الإنسانية في اليمن بتوفير المواد الغذائية والمستلزمات الأساسية',
      category: 'إغاثة',
      icon: Icons.volunteer_activism_rounded,
      color: Color(0xFFE53935),
      raised: 4850000,
      goal: 10000000,
      donors: 1243,
    ),
    _Charity(
      id: 'c2',
      name: 'كفالة الأيتام',
      description: 'كفالة الأطفال الأيتام وتوفير احتياجاتهم التعليمية والصحية والغذائية',
      category: 'أيتام',
      icon: Icons.child_care_rounded,
      color: Color(0xFF8E24AA),
      raised: 2300000,
      goal: 5000000,
      donors: 876,
    ),
    _Charity(
      id: 'c3',
      name: 'بناء مدارس الأرياف',
      description: 'بناء وإعادة تأهيل المدارس في المناطق الريفية لضمان حصول الأطفال على التعليم',
      category: 'تعليم',
      icon: Icons.school_rounded,
      color: Color(0xFF1565C0),
      raised: 1750000,
      goal: 3000000,
      donors: 542,
    ),
    _Charity(
      id: 'c4',
      name: 'دعم المستشفيات',
      description: 'توفير الأدوية والمعدات الطبية للمستشفيات والمراكز الصحية في المناطق المحتاجة',
      category: 'صحة',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFF00897B),
      raised: 3200000,
      goal: 6000000,
      donors: 989,
    ),
    _Charity(
      id: 'c5',
      name: 'إعمار المساجد',
      description: 'بناء وإعمار وصيانة المساجد في المناطق المختلفة',
      category: 'مساجد',
      icon: Icons.mosque_rounded,
      color: Color(0xFF388E3C),
      raised: 890000,
      goal: 2000000,
      donors: 321,
    ),
    _Charity(
      id: 'c6',
      name: 'منح الطلاب الجامعيين',
      description: 'تقديم منح دراسية للطلاب المتفوقين من الأسر المحتاجة للالتحاق بالجامعات',
      category: 'تعليم',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF0097A7),
      raised: 560000,
      goal: 1500000,
      donors: 198,
    ),
  ];

  double _amount = 0;
  final _amountController = TextEditingController();
  _Charity? _selectedCharity;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<_Charity> get _filtered {
    if (_selectedCategory == 'الكل') return _charities;
    return _charities.where((c) => c.category == _selectedCategory).toList();
  }

  String _formatNum(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)} م';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)} ألف';
    return n.toStringAsFixed(0);
  }

  void _showDonateSheet(_Charity charity) {
    _selectedCharity = charity;
    _amount = 0;
    _amountController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonateSheet(
        charity: charity,
        onDonate: (amount) {
          Navigator.pop(context);
          _processDoantaion(charity, amount);
        },
      ),
    );
  }

  void _processDoantaion(_Charity charity, double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      _showSuccessDialog(charity, amount);
    });
  }

  void _showSuccessDialog(_Charity charity, double amount) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge)),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: AppColors.success, size: 40),
              ),
              const SizedBox(height: AppSizes.paddingM),
              const Text('جزاك الله خيراً',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              Text(
                'تم تحويل ${amount.toStringAsFixed(0)} ريال\nإلى ${charity.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.grey, fontFamily: 'Cairo', height: 1.5),
              ),
              const SizedBox(height: AppSizes.paddingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('حسناً',
                      style: TextStyle(fontFamily: 'Cairo')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التبرعات والصدقات',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'قنوات التبرع'),
            Tab(text: 'تبرعاتي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CharitiesTab(
            categories: _categories,
            selected: _selectedCategory,
            filtered: _filtered,
            onCategoryTap: (c) => setState(() => _selectedCategory = c),
            onDonateTap: _showDonateSheet,
            formatNum: _formatNum,
          ),
          _MyDonationsTab(),
        ],
      ),
    );
  }
}

// ======= Tab 1: قنوات التبرع =======
class _CharitiesTab extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final List<_Charity> filtered;
  final void Function(String) onCategoryTap;
  final void Function(_Charity) onDonateTap;
  final String Function(double) formatNum;

  const _CharitiesTab({
    required this.categories,
    required this.selected,
    required this.filtered,
    required this.onCategoryTap,
    required this.onDonateTap,
    required this.formatNum,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // فلتر التصنيف
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: Row(
              children: categories.map((cat) {
                final isSelected = cat == selected;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(cat,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isSelected ? AppColors.white : AppColors.grey,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        )),
                    selected: isSelected,
                    onSelected: (_) => onCategoryTap(cat),
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
        // قائمة الجمعيات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _CharityCard(
              charity: filtered[i],
              onDonate: () => onDonateTap(filtered[i]),
              formatNum: formatNum,
            ),
          ),
        ),
      ],
    );
  }
}

class _CharityCard extends StatelessWidget {
  final _Charity charity;
  final VoidCallback onDonate;
  final String Function(double) formatNum;

  const _CharityCard({
    required this.charity,
    required this.onDonate,
    required this.formatNum,
  });

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
                colors: [charity.color, charity.color.withValues(alpha: 0.7)],
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(charity.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charity.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          charity.category,
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
                Text(
                  '${charity.donors} متبرع',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          // جسم البطاقة
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charity.description,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.paddingM),
                // شريط التقدم
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تم جمع ${formatNum(charity.raised)} ريال',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  color: charity.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'الهدف: ${formatNum(charity.goal)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: charity.progress,
                              backgroundColor: charity.color.withValues(alpha: 0.15),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(charity.color),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onDonate,
                    icon: const Icon(Icons.favorite_rounded, size: 18),
                    label: const Text('تبرع الآن',
                        style: TextStyle(fontFamily: 'Cairo')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: charity.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
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

// ======= نافذة التبرع =======
class _DonateSheet extends StatefulWidget {
  final _Charity charity;
  final void Function(double) onDonate;

  const _DonateSheet({required this.charity, required this.onDonate});

  @override
  State<_DonateSheet> createState() => _DonateSheetState();
}

class _DonateSheetState extends State<_DonateSheet> {
  final _ctrl = TextEditingController();
  double _amount = 0;
  bool _isRecurring = false;
  String _recurringFreq = 'شهرياً';

  final List<double> _quickAmounts = [500, 1000, 2000, 5000, 10000, 20000];
  final List<String> _frequencies = ['أسبوعياً', 'شهرياً', 'سنوياً'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingL,
        left: AppSizes.paddingL,
        right: AppSizes.paddingL,
        top: AppSizes.paddingM,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            // العنوان
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.charity.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.charity.icon,
                      color: widget.charity.color, size: 24),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Text(
                    widget.charity.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
            // المبالغ السريعة
            const Text('اختر المبلغ',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            const SizedBox(height: AppSizes.paddingS),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAmounts.map((a) {
                final selected = _amount == a;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _amount = a;
                      _ctrl.text = a.toStringAsFixed(0);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? widget.charity.color
                          : widget.charity.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      border: Border.all(
                        color: widget.charity.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${a.toStringAsFixed(0)} ر',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : widget.charity.color,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.paddingM),
            // حقل المبلغ
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              onChanged: (v) =>
                  setState(() => _amount = double.tryParse(v) ?? 0),
              decoration: const InputDecoration(
                labelText: 'أو أدخل مبلغاً آخر',
                suffixText: 'ريال',
                labelStyle: TextStyle(fontFamily: 'Cairo'),
                suffixStyle: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            // تبرع متكرر
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.repeat_rounded,
                          color: AppColors.primaryBlue, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('تبرع متكرر',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600)),
                      ),
                      Switch(
                        value: _isRecurring,
                        onChanged: (v) => setState(() => _isRecurring = v),
                        activeColor: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                  if (_isRecurring) ...[
                    const SizedBox(height: AppSizes.paddingS),
                    Row(
                      children: _frequencies.map((f) {
                        final sel = f == _recurringFreq;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _recurringFreq = f),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                decoration: BoxDecoration(
                                  color: sel
                                      ? AppColors.primaryBlue
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: sel
                                        ? AppColors.primaryBlue
                                        : AppColors.lightGrey,
                                  ),
                                ),
                                child: Text(
                                  f,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: sel
                                        ? Colors.white
                                        : AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _amount > 0
                    ? () => widget.onDonate(_amount)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.charity.color,
                  disabledBackgroundColor: AppColors.lightGrey,
                ),
                child: Text(
                  _amount > 0
                      ? 'تبرع بـ ${_amount.toStringAsFixed(0)} ريال'
                      : 'أدخل المبلغ',
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======= Tab 2: تبرعاتي =======
class _MyDonationsTab extends StatelessWidget {
  final List<Map<String, dynamic>> _history = const [
    {
      'name': 'إغاثة الأسر المتضررة',
      'amount': 2000.0,
      'date': '15 مارس 2026',
      'icon': Icons.volunteer_activism_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'name': 'كفالة الأيتام',
      'amount': 1000.0,
      'date': '1 مارس 2026',
      'icon': Icons.child_care_rounded,
      'color': Color(0xFF8E24AA),
    },
    {
      'name': 'دعم المستشفيات',
      'amount': 5000.0,
      'date': '10 فبراير 2026',
      'icon': Icons.local_hospital_rounded,
      'color': Color(0xFF00897B),
    },
    {
      'name': 'بناء مدارس الأرياف',
      'amount': 3000.0,
      'date': '22 يناير 2026',
      'icon': Icons.school_rounded,
      'color': Color(0xFF1565C0),
    },
  ];

  _MyDonationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _history.fold<double>(
        0, (sum, e) => sum + (e['amount'] as double));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // إجمالي التبرعات
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withValues(alpha: 0.7)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: [
                const Icon(Icons.favorite_rounded,
                    color: Colors.white, size: 36),
                const SizedBox(height: 8),
                const Text(
                  'إجمالي تبرعاتي',
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${total.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_history.length} عمليات تبرع',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          // قائمة التبرعات
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: _history.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color:
                              (item['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData,
                            color: item['color'] as Color, size: 22),
                      ),
                      title: Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        item['date'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${(item['amount'] as double).toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (i < _history.length - 1)
                      const Divider(height: 1, indent: 60),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          // شهادة التبرع
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: AppColors.success, size: 28),
                const SizedBox(width: AppSizes.paddingM),
                const Expanded(
                  child: Text(
                    'أنت من أبرز المتبرعين هذا الشهر!\nشكراً لدعمك المستمر.',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.success,
                      fontSize: 13,
                      height: 1.5,
                    ),
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
