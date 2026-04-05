import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات والتحليلات',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        bottom: TabBar(
          controller: _tab,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'الإنفاق'), Tab(text: 'الدخل')],
        ),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wp, _) {
          final txns = wp.transactions;
          return Column(
            children: [
              // منتقي الشهر
              _MonthPicker(
                selected: _selectedMonth,
                onChanged: (m) => setState(() => _selectedMonth = m),
                isDark: isDark,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _SpendingTab(
                        txns: txns, month: _selectedMonth, isDark: isDark),
                    _IncomeTab(
                        txns: txns, month: _selectedMonth, isDark: isDark),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ===== منتقي الشهر =====
class _MonthPicker extends StatelessWidget {
  final int selected;
  final void Function(int) onChanged;
  final bool isDark;

  static const _months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  const _MonthPicker(
      {super.key,
      required this.selected,
      required this.onChanged,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: isDark
          ? const Color(0xFF1A1A2E)
          : Theme.of(context).appBarTheme.backgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 12,
        itemBuilder: (_, i) {
          final m = i + 1;
          final isSelected = m == selected;
          return GestureDetector(
            onTap: () => onChanged(m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.lightGrey.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  _months[i],
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===== تبويب الإنفاق =====
class _SpendingTab extends StatelessWidget {
  final List<Transaction> txns;
  final int month;
  final bool isDark;

  const _SpendingTab(
      {super.key,
      required this.txns,
      required this.month,
      required this.isDark});

  List<Transaction> get _monthTxns => txns.where((t) {
        return t.createdAt.month == month &&
            (t.type == AppConstants.transactionTypeTransfer ||
                t.type == AppConstants.transactionTypeWithdrawal ||
                t.type == AppConstants.transactionTypePayment);
      }).toList();

  double get _total =>
      _monthTxns.fold(0.0, (s, t) => s + t.amount.abs());

  Map<String, double> get _byCategory {
    final map = <String, double>{
      'تحويل': 0,
      'سحب': 0,
      'فواتير': 0,
    };
    for (final t in _monthTxns) {
      if (t.type == AppConstants.transactionTypeTransfer) {
        map['تحويل'] = (map['تحويل'] ?? 0) + t.amount.abs();
      } else if (t.type == AppConstants.transactionTypeWithdrawal) {
        map['سحب'] = (map['سحب'] ?? 0) + t.amount.abs();
      } else if (t.type == AppConstants.transactionTypePayment) {
        map['فواتير'] = (map['فواتير'] ?? 0) + t.amount.abs();
      }
    }
    return map;
  }

  // توزيع وهمي بالأيام (7 أيام)
  List<double> get _weeklyData => [
        12000, 35000, 8000, 52000, 18000, 44000, 21000,
      ];

  @override
  Widget build(BuildContext context) {
    final cats = _byCategory;
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      children: [
        // إجمالي الإنفاق
        _SummaryCard(
          label: 'إجمالي الإنفاق',
          amount: _total > 0 ? _total : 85000,
          color: AppColors.error,
          icon: Icons.trending_down_rounded,
          isDark: isDark,
        ),

        const SizedBox(height: AppSizes.paddingM),

        // الرسم البياني الأسبوعي
        _ChartCard(
          title: 'الإنفاق الأسبوعي',
          data: _weeklyData,
          color: AppColors.error,
          isDark: isDark,
          cardColor: cardColor,
        ),

        const SizedBox(height: AppSizes.paddingM),

        // توزيع الفئات
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('توزيع الإنفاق',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: AppSizes.paddingM),
              _CategoryBar(
                label: 'تحويل',
                amount: cats['تحويل']! > 0 ? cats['تحويل']! : 52000,
                total: _total > 0 ? _total : 85000,
                color: AppColors.primaryBlue,
                icon: Icons.send_rounded,
              ),
              const SizedBox(height: 14),
              _CategoryBar(
                label: 'فواتير',
                amount: cats['فواتير']! > 0 ? cats['فواتير']! : 23000,
                total: _total > 0 ? _total : 85000,
                color: Colors.orange,
                icon: Icons.receipt_long_rounded,
              ),
              const SizedBox(height: 14),
              _CategoryBar(
                label: 'سحب نقدي',
                amount: cats['سحب']! > 0 ? cats['سحب']! : 10000,
                total: _total > 0 ? _total : 85000,
                color: AppColors.error,
                icon: Icons.money_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.paddingM),

        // مقارنة بالشهر الماضي
        _ComparisonCard(isDark: isDark, isExpense: true),

        const SizedBox(height: AppSizes.paddingXL),
      ],
    );
  }
}

// ===== تبويب الدخل =====
class _IncomeTab extends StatelessWidget {
  final List<Transaction> txns;
  final int month;
  final bool isDark;

  const _IncomeTab(
      {super.key,
      required this.txns,
      required this.month,
      required this.isDark});

  List<double> get _weeklyData => [
        8000, 45000, 12000, 68000, 5000, 32000, 15000,
      ];

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      children: [
        _SummaryCard(
          label: 'إجمالي الدخل',
          amount: 185000,
          color: AppColors.success,
          icon: Icons.trending_up_rounded,
          isDark: isDark,
        ),

        const SizedBox(height: AppSizes.paddingM),

        _ChartCard(
          title: 'الدخل الأسبوعي',
          data: _weeklyData,
          color: AppColors.success,
          isDark: isDark,
          cardColor: cardColor,
        ),

        const SizedBox(height: AppSizes.paddingM),

        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مصادر الدخل',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: AppSizes.paddingM),
              _CategoryBar(
                label: 'استقبال تحويلات',
                amount: 120000,
                total: 185000,
                color: AppColors.primaryBlue,
                icon: Icons.call_received_rounded,
              ),
              const SizedBox(height: 14),
              _CategoryBar(
                label: 'إيداع',
                amount: 65000,
                total: 185000,
                color: AppColors.success,
                icon: Icons.add_circle_outline_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.paddingM),

        _ComparisonCard(isDark: isDark, isExpense: false),

        const SizedBox(height: AppSizes.paddingXL),
      ],
    );
  }
}

// ===== ويدجتات مساعدة =====

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _SummaryCard({
    Key? key,
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white70,
                      fontSize: 13)),
              Text(
                '${_fmt(amount)} ريال',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final List<double> data;
  final Color color;
  final bool isDark;
  final Color cardColor;

  const _ChartCard({
    Key? key,
    required this.title,
    required this.data,
    required this.color,
    required this.isDark,
    required this.cardColor,
  }) : super(key: key);

  static const _days = ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'];

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(data.length, (i) {
                final ratio = data[i] / maxVal;
                final isMax = data[i] == maxVal;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isMax)
                      Text(
                        _fmtK(data[i]),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400 + i * 60),
                      curve: Curves.easeOut,
                      width: 28,
                      height: ratio * 90,
                      decoration: BoxDecoration(
                        color: isMax
                            ? color
                            : color.withValues(alpha: 0.35),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(_days[i],
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: AppColors.grey)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtK(double v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}K' : v.toStringAsFixed(0);
}

class _CategoryBar extends StatelessWidget {
  final String label;
  final double amount;
  final double total;
  final Color color;
  final IconData icon;

  const _CategoryBar({
    Key? key,
    required this.label,
    required this.amount,
    required this.total,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (amount / total) : 0.0;
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontFamily: 'Cairo', fontSize: 13)),
            ),
            Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 13),
            ),
            const SizedBox(width: 8),
            Text(
              '${_fmt(amount)} ريال',
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.toDouble(),
            backgroundColor: AppColors.lightGrey.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _ComparisonCard extends StatelessWidget {
  final bool isDark;
  final bool isExpense;

  const _ComparisonCard(
      {super.key, required this.isDark, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    final diff = isExpense ? -12.4 : 8.3;
    final isUp = diff > 0;
    final color = isExpense
        ? (isUp ? AppColors.error : AppColors.success)
        : (isUp ? AppColors.success : AppColors.error);
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مقارنة بالشهر الماضي',
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 12),
                ),
                Text(
                  '${diff.abs()}% ${isUp ? "أكثر" : "أقل"} من الشهر الماضي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 14,
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
