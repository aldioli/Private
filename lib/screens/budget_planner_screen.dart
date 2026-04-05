import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BudgetPlannerScreen extends StatefulWidget {
  const BudgetPlannerScreen({super.key});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetCategory {
  final String name;
  final IconData icon;
  final Color color;
  double budget;
  double spent;

  _BudgetCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.budget,
    required this.spent,
  });

  double get remaining => budget - spent;
  double get progress => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => spent > budget;
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double _totalBudget = 800000;

  final List<_BudgetCategory> _categories = [
    _BudgetCategory(
      name: 'المسكن والإيجار',
      icon: Icons.home_rounded,
      color: Color(0xFF1565C0),
      budget: 200000,
      spent: 200000,
    ),
    _BudgetCategory(
      name: 'الغذاء والمطاعم',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFE53935),
      budget: 150000,
      spent: 134500,
    ),
    _BudgetCategory(
      name: 'المواصلات',
      icon: Icons.directions_car_rounded,
      color: Color(0xFF8E24AA),
      budget: 80000,
      spent: 92000,
    ),
    _BudgetCategory(
      name: 'الفواتير والخدمات',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFFFFA000),
      budget: 100000,
      spent: 63000,
    ),
    _BudgetCategory(
      name: 'الترفيه',
      icon: Icons.movie_rounded,
      color: Color(0xFF0097A7),
      budget: 50000,
      spent: 38000,
    ),
    _BudgetCategory(
      name: 'التسوق',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFF43A047),
      budget: 100000,
      spent: 147000,
    ),
    _BudgetCategory(
      name: 'الصحة',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFF00897B),
      budget: 60000,
      spent: 22000,
    ),
    _BudgetCategory(
      name: 'التعليم',
      icon: Icons.school_rounded,
      color: Color(0xFF5E35B1),
      budget: 60000,
      spent: 60000,
    ),
  ];

  double get _totalSpent =>
      _categories.fold(0, (s, c) => s + c.spent);
  double get _totalRemaining => _totalBudget - _totalSpent;
  double get _overallProgress =>
      (_totalSpent / _totalBudget).clamp(0.0, 1.0);

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

  void _editCategory(_BudgetCategory cat) {
    final ctrl = TextEditingController(
        text: cat.budget.toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
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
              Text('تعديل ميزانية ${cat.name}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const SizedBox(height: AppSizes.paddingL),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الميزانية الشهرية',
                  suffixText: 'ريال',
                  labelStyle: TextStyle(fontFamily: 'Cairo'),
                  suffixStyle: TextStyle(fontFamily: 'Cairo'),
                ),
                style: const TextStyle(
                    fontFamily: 'Cairo', fontSize: 18),
                autofocus: true,
              ),
              const SizedBox(height: AppSizes.paddingL),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    final val = double.tryParse(ctrl.text);
                    if (val != null && val >= 0) {
                      setState(() {
                        cat.budget = val;
                        _totalBudget = _categories.fold(
                            0, (s, c) => s + c.budget);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ',
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
        title: const Text('مخطط الميزانية',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'اضغط على أي فئة لتعديل ميزانيتها',
                      style: TextStyle(fontFamily: 'Cairo')),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'الملخص'),
            Tab(text: 'التفاصيل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SummaryTab(
            totalBudget: _totalBudget,
            totalSpent: _totalSpent,
            totalRemaining: _totalRemaining,
            overallProgress: _overallProgress,
            categories: _categories,
            onEdit: _editCategory,
          ),
          _DetailsTab(
              categories: _categories, onEdit: _editCategory),
        ],
      ),
    );
  }
}

// ======= Tab 1: الملخص =======
class _SummaryTab extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double totalRemaining;
  final double overallProgress;
  final List<_BudgetCategory> categories;
  final void Function(_BudgetCategory) onEdit;

  const _SummaryTab({
    required this.totalBudget,
    required this.totalSpent,
    required this.totalRemaining,
    required this.overallProgress,
    required this.categories,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isOverBudget = totalSpent > totalBudget;
    final progressColor =
        overallProgress > 0.9 ? AppColors.error : AppColors.success;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // بطاقة الملخص الكبيرة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isOverBudget
                    ? [AppColors.error, const Color(0xFFB71C1C)]
                    : [AppColors.primaryBlue, const Color(0xFF1565C0)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: [
                const Text('ميزانية مارس 2026',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    )),
                const SizedBox(height: 8),
                Text(
                  '${totalBudget.toStringAsFixed(0)} ريال',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: overallProgress,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget ? Colors.orange : Colors.white,
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الصرف: ${totalSpent.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      isOverBudget
                          ? 'تجاوزت بـ ${(totalSpent - totalBudget).toStringAsFixed(0)}'
                          : 'متبقي: ${totalRemaining.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isOverBudget
                            ? Colors.orange
                            : Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // فئات ملخص
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: Column(
              children: categories.asMap().entries.map((entry) {
                final i = entry.key;
                final c = entry.value;
                final isLast = i == categories.length - 1;

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => onEdit(c),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM,
                            vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color:
                                        c.color.withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Icon(c.icon,
                                      color: c.color, size: 18),
                                ),
                                const SizedBox(
                                    width: AppSizes.paddingS),
                                Expanded(
                                  child: Text(c.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${c.spent.toStringAsFixed(0)} / ${c.budget.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: c.isOverBudget
                                            ? AppColors.error
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (c.isOverBudget)
                                      Text(
                                        '+${(c.spent - c.budget).toStringAsFixed(0)} تجاوز',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 10,
                                          color: AppColors.error,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: c.progress,
                                backgroundColor:
                                    c.color.withValues(alpha: 0.1),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  c.isOverBudget
                                      ? AppColors.error
                                      : c.color,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      const Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),
        ],
      ),
    );
  }
}

// ======= Tab 2: التفاصيل =======
class _DetailsTab extends StatelessWidget {
  final List<_BudgetCategory> categories;
  final void Function(_BudgetCategory) onEdit;

  const _DetailsTab({required this.categories, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // حساب نسبة كل فئة من الكل
    final totalBudget =
        categories.fold<double>(0, (s, c) => s + c.budget);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final c = categories[i];
        final pct = totalBudget > 0
            ? (c.budget / totalBudget) * 100
            : 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
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
                      gradient: LinearGradient(
                        colors: [c.color, c.color.withValues(alpha: 0.7)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(c.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        Text(
                            '${pct.toStringAsFixed(1)}% من الميزانية',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.grey,
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 20, color: AppColors.grey),
                    onPressed: () => onEdit(c),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  _BudgetStat('الميزانية',
                      '${c.budget.toStringAsFixed(0)} ريال',
                      AppColors.grey),
                  _BudgetStat('الصرف',
                      '${c.spent.toStringAsFixed(0)} ريال',
                      c.isOverBudget ? AppColors.error : c.color),
                  _BudgetStat(
                    c.isOverBudget ? 'التجاوز' : 'المتبقي',
                    '${c.remaining.abs().toStringAsFixed(0)} ريال',
                    c.isOverBudget ? AppColors.error : AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: c.progress,
                  backgroundColor: c.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    c.isOverBudget ? AppColors.error : c.color,
                  ),
                  minHeight: 8,
                ),
              ),
              if (c.isOverBudget)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.error, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'تجاوزت الميزانية بـ ${(c.spent - c.budget).toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BudgetStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center),
          Text(value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
