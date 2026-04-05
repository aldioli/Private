import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';
import 'transaction_detail_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';
  final _searchCtrl = TextEditingController();
  String _sortBy = 'date_desc';

  static const _tabs = ['الكل', 'تحويل', 'إيداع', 'سحب'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Transaction> _filter(List<Transaction> all) {
    final typeFilter = ['', 'transfer', 'deposit', 'withdrawal'][_tabController.index];
    var list = all.where((t) {
      if (typeFilter.isNotEmpty && t.type != typeFilter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return (t.recipientName?.toLowerCase().contains(q) ?? false) ||
            (t.description?.toLowerCase().contains(q) ?? false) ||
            t.amount.toString().contains(q);
      }
      return true;
    }).toList();

    switch (_sortBy) {
      case 'date_asc':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'amount_desc':
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'amount_asc':
        list.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      default:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  Map<String, List<Transaction>> _group(List<Transaction> list) {
    final map = <String, List<Transaction>>{};
    for (final t in list) {
      final key = _dateKey(t.createdAt);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  String _dateKey(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'اليوم';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day) {
      return 'أمس';
    }
    return DateFormat('d MMMM yyyy').format(d);
  }

  void _showSortSheet() {
    final options = [
      ('date_desc', 'التاريخ: الأحدث أولاً', Icons.arrow_downward),
      ('date_asc', 'التاريخ: الأقدم أولاً', Icons.arrow_upward),
      ('amount_desc', 'المبلغ: الأكبر أولاً', Icons.arrow_downward),
      ('amount_asc', 'المبلغ: الأصغر أولاً', Icons.arrow_upward),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('ترتيب حسب',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            ...options.map((opt) => ListTile(
                  leading: Icon(opt.$3,
                      color: _sortBy == opt.$1
                          ? AppColors.primaryBlue
                          : AppColors.grey,
                      size: 20),
                  title: Text(opt.$2,
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: _sortBy == opt.$1
                              ? AppColors.primaryBlue
                              : AppColors.textPrimary,
                          fontWeight: _sortBy == opt.$1
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  trailing: _sortBy == opt.$1
                      ? const Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = opt.$1);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 16),
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
        title: const Text('المعاملات',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: _showSortSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن معاملة...',
                    hintStyle:
                        const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: AppColors.grey),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primaryBlue,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.grey,
                labelStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wp, _) {
          if (wp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filtered = _filter(wp.transactions);

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 72, color: AppColors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    _search.isNotEmpty
                        ? 'لا توجد نتائج لـ "$_search"'
                        : 'لا توجد معاملات',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: AppColors.grey),
                  ),
                ],
              ),
            );
          }

          final totalIn = filtered
              .where((t) => t.type == 'deposit')
              .fold(0.0, (s, t) => s + t.amount);
          final totalOut = filtered
              .where((t) => t.type == 'transfer' || t.type == 'withdrawal')
              .fold(0.0, (s, t) => s + t.amount);

          final grouped = _group(filtered);
          final dateKeys = grouped.keys.toList();

          return Column(
            children: [
              // Summary bar
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: _SummaryChip(
                            label: 'وارد',
                            amount: totalIn,
                            color: AppColors.success,
                            icon: Icons.arrow_downward)),
                    Container(
                        width: 1, height: 32, color: AppColors.lightGrey),
                    Expanded(
                        child: _SummaryChip(
                            label: 'صادر',
                            amount: totalOut,
                            color: AppColors.error,
                            icon: Icons.arrow_upward)),
                    Container(
                        width: 1, height: 32, color: AppColors.lightGrey),
                    Expanded(
                        child: _SummaryChip(
                            label: 'العدد',
                            amount: filtered.length.toDouble(),
                            color: AppColors.primaryBlue,
                            icon: Icons.receipt_outlined,
                            isCount: true)),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: dateKeys.length,
                  itemBuilder: (_, i) {
                    final key = dateKeys[i];
                    final txns = grouped[key]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(key,
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.grey)),
                              const SizedBox(width: 8),
                              const Expanded(
                                  child: Divider(
                                      color: AppColors.lightGrey, height: 1)),
                              const SizedBox(width: 8),
                              Text('${txns.length} معاملة',
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: AppColors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2)),
                            ],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: txns.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, indent: 60),
                            itemBuilder: (_, j) => _TxnTile(txn: txns[j]),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final bool isCount;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    this.isCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(label,
                style:
                    TextStyle(fontFamily: 'Cairo', fontSize: 12, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          isCount
              ? amount.toInt().toString()
              : '${amount.toStringAsFixed(0)} ر',
          style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color),
        ),
      ],
    );
  }
}

class _TxnTile extends StatelessWidget {
  final Transaction txn;
  const _TxnTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final isOut = txn.type == 'transfer' || txn.type == 'withdrawal';

    IconData icon;
    Color color;
    String title;

    switch (txn.type) {
      case 'deposit':
        icon = Icons.arrow_downward_rounded;
        color = AppColors.success;
        title = 'إيداع نقدي';
        break;
      case 'withdrawal':
        icon = Icons.arrow_upward_rounded;
        color = AppColors.warning;
        title = 'سحب نقدي';
        break;
      case 'transfer':
        icon = Icons.send_rounded;
        color = AppColors.primaryBlue;
        title = txn.recipientName != null
            ? 'تحويل إلى ${txn.recipientName}'
            : 'تحويل';
        break;
      default:
        icon = Icons.receipt_rounded;
        color = AppColors.grey;
        title = txn.description ?? 'معاملة';
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transaction: txn),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('h:mm a').format(txn.createdAt),
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isOut ? '-' : '+'}${txn.amount.toStringAsFixed(0)} ر',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isOut ? AppColors.error : AppColors.success),
                ),
                if (txn.isPending)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('معلقة',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: AppColors.warning)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, String title, Color color,
      IconData icon, bool isOut) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${isOut ? '-' : '+'}${txn.amount.toStringAsFixed(2)} ريال',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isOut ? AppColors.error : AppColors.success),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _DetailRow(
                label: 'الحالة',
                value: txn.isPending ? 'معلقة' : 'مكتملة',
                valueColor:
                    txn.isPending ? AppColors.warning : AppColors.success),
            _DetailRow(
                label: 'النوع',
                value: {
                      'deposit': 'إيداع',
                      'withdrawal': 'سحب',
                      'transfer': 'تحويل'
                    }[txn.type] ??
                    txn.type),
            if (txn.recipientName != null)
              _DetailRow(label: 'المستلم', value: txn.recipientName!),
            _DetailRow(
                label: 'التاريخ',
                value: DateFormat('d/M/yyyy — h:mm a').format(txn.createdAt)),
            if (txn.description != null && txn.description!.isNotEmpty)
              _DetailRow(label: 'الوصف', value: txn.description!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق',
                    style:
                        TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.grey)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
