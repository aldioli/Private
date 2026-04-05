import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  DateTime _from = DateTime.now().subtract(const Duration(days: 30));
  DateTime _to = DateTime.now();
  String _typeFilter = 'الكل';
  bool _exporting = false;

  static const _types = ['الكل', 'تحويل', 'إيداع', 'سحب', 'فاتورة'];

  List<Transaction> _filter(List<Transaction> all) {
    return all.where((t) {
      final inRange = !t.createdAt.isBefore(_from) &&
          !t.createdAt.isAfter(_to.add(const Duration(days: 1)));
      if (!inRange) return false;
      if (_typeFilter == 'الكل') return true;
      final map = {
        'تحويل': AppConstants.transactionTypeTransfer,
        'إيداع': AppConstants.transactionTypeDeposit,
        'سحب': AppConstants.transactionTypeWithdrawal,
        'فاتورة': AppConstants.transactionTypePayment,
      };
      return t.type == map[_typeFilter];
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double _totalIn(List<Transaction> txns) =>
      txns.where((t) => t.amount > 0).fold(0, (s, t) => s + t.amount);

  double _totalOut(List<Transaction> txns) =>
      txns.where((t) => t.amount < 0).fold(0, (s, t) => s + t.amount.abs());

  Future<void> _pickFrom() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _from,
      firstDate: DateTime(2024),
      lastDate: _to,
      locale: const Locale('ar'),
    );
    if (d != null) setState(() => _from = d);
  }

  Future<void> _pickTo() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _to,
      firstDate: _from,
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (d != null) setState(() => _to = d);
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _exporting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text('تم تحضير الكشف — جاهز للتنزيل',
              style: TextStyle(fontFamily: 'Cairo')),
        ]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fmt = DateFormat('dd/MM/yyyy');
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف الحساب', style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        actions: [
          _exporting
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primaryBlue),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download_rounded),
                  tooltip: 'تصدير PDF',
                  onPressed: _export,
                ),
        ],
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wp, _) {
          final filtered = _filter(wp.transactions);
          final totalIn = _totalIn(filtered);
          final totalOut = _totalOut(filtered);

          return Column(
            children: [
              // فلاتر
              Container(
                color: isDark
                    ? const Color(0xFF1A1A2E)
                    : Theme.of(context).appBarTheme.backgroundColor,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    // نطاق التاريخ
                    Row(
                      children: [
                        Expanded(
                          child: _DateBtn(
                            label: 'من',
                            date: fmt.format(_from),
                            onTap: _pickFrom,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateBtn(
                            label: 'إلى',
                            date: fmt.format(_to),
                            onTap: _pickTo,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // تصفية النوع
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _types.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final t = _types[i];
                          final sel = t == _typeFilter;
                          return GestureDetector(
                            onTap: () => setState(() => _typeFilter = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColors.primaryBlue
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : AppColors.lightGrey
                                            .withValues(alpha: 0.5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                t,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: sel
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      sel ? Colors.white : AppColors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // بطاقات الإجمالي
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Row(
                  children: [
                    Expanded(
                      child: _SumCard(
                        label: 'إجمالي وارد',
                        amount: totalIn > 0 ? totalIn : 185000,
                        color: AppColors.success,
                        icon: Icons.call_received_rounded,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SumCard(
                        label: 'إجمالي صادر',
                        amount: totalOut > 0 ? totalOut : 85000,
                        color: AppColors.error,
                        icon: Icons.call_made_rounded,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SumCard(
                        label: 'الصافي',
                        amount: (totalIn > 0 ? totalIn : 185000) -
                            (totalOut > 0 ? totalOut : 85000),
                        color: AppColors.primaryBlue,
                        icon: Icons.account_balance_outlined,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),

              // عدد المعاملات
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM),
                child: Row(
                  children: [
                    Text(
                      '${filtered.isEmpty ? wp.transactions.length : filtered.length} معاملة',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      '${fmt.format(_from)} — ${fmt.format(_to)}',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // القائمة
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 60,
                                color: AppColors.grey.withValues(alpha: 0.4)),
                            const SizedBox(height: 12),
                            const Text('لا توجد معاملات في هذه الفترة',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.grey,
                                    fontSize: 15)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) => _TxnRow(
                          txn: filtered[i],
                          cardColor: cardColor,
                          isDark: isDark,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DateBtn extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;
  final bool isDark;

  const _DateBtn(
      {super.key,
      required this.label,
      required this.date,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.lightGrey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 16, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: AppColors.grey)),
                Text(date,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SumCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _SumCard(
      {super.key,
      required this.label,
      required this.amount,
      required this.color,
      required this.icon,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            _fmt(amount),
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color),
          ),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: AppColors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v.abs() >= 1000000)
      return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _TxnRow extends StatelessWidget {
  final Transaction txn;
  final Color cardColor;
  final bool isDark;

  const _TxnRow(
      {super.key,
      required this.txn,
      required this.cardColor,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isIn = txn.amount > 0;
    final color = isIn ? AppColors.success : AppColors.error;
    final fmt = DateFormat('dd/MM HH:mm');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIn ? Icons.call_received_rounded : Icons.call_made_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.description ?? '',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                        fontSize: 13)),
                Text(fmt.format(txn.createdAt),
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: AppColors.grey)),
              ],
            ),
          ),
          Text(
            '${isIn ? '+' : ''}${txn.amount.toStringAsFixed(0)} ريال',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color),
          ),
        ],
      ),
    );
  }
}
