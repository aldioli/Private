import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ScheduledPaymentsScreen extends StatefulWidget {
  const ScheduledPaymentsScreen({super.key});

  @override
  State<ScheduledPaymentsScreen> createState() =>
      _ScheduledPaymentsScreenState();
}

class _ScheduledPaymentsScreenState extends State<ScheduledPaymentsScreen> {
  final List<_ScheduledPayment> _payments = [
    _ScheduledPayment(
      id: '1',
      name: 'فاتورة الكهرباء',
      amount: 8500,
      frequency: 'شهرياً',
      nextDate: DateTime.now().add(const Duration(days: 5)),
      icon: Icons.bolt_rounded,
      color: const Color(0xFFFFB300),
      isActive: true,
      category: 'فواتير',
    ),
    _ScheduledPayment(
      id: '2',
      name: 'اشتراك الإنترنت',
      amount: 4000,
      frequency: 'شهرياً',
      nextDate: DateTime.now().add(const Duration(days: 12)),
      icon: Icons.wifi_rounded,
      color: const Color(0xFF7B1FA2),
      isActive: true,
      category: 'فواتير',
    ),
    _ScheduledPayment(
      id: '3',
      name: 'تحويل لوالدي',
      amount: 50000,
      frequency: 'أسبوعياً',
      nextDate: DateTime.now().add(const Duration(days: 2)),
      icon: Icons.family_restroom_rounded,
      color: AppColors.primaryBlue,
      isActive: true,
      category: 'تحويل',
    ),
    _ScheduledPayment(
      id: '4',
      name: 'شحن رصيد يمن موبايل',
      amount: 2000,
      frequency: 'أسبوعياً',
      nextDate: DateTime.now().add(const Duration(days: 4)),
      icon: Icons.phone_android_rounded,
      color: const Color(0xFF388E3C),
      isActive: false,
      category: 'شحن',
    ),
    _ScheduledPayment(
      id: '5',
      name: 'قسط السيارة',
      amount: 120000,
      frequency: 'شهرياً',
      nextDate: DateTime.now().add(const Duration(days: 20)),
      icon: Icons.directions_car_rounded,
      color: AppColors.error,
      isActive: true,
      category: 'أقساط',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active = _payments.where((p) => p.isActive).length;
    final totalMonthly = _payments
        .where((p) => p.isActive && p.frequency == 'شهرياً')
        .fold(0.0, (s, p) => s + p.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفعات المجدولة',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddSheet(context, isDark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        children: [
          // ملخص
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'دفعات نشطة',
                  value: '$active',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  label: 'شهرياً تقريباً',
                  value: '${(totalMonthly / 1000).toStringAsFixed(0)}K ر',
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.primaryBlue,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  label: 'أقرب دفعة',
                  value: '${_payments.where((p) => p.isActive).map((p) => p.nextDate.difference(DateTime.now()).inDays).reduce((a, b) => a < b ? a : b)} يوم',
                  icon: Icons.schedule_rounded,
                  color: AppColors.warning,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // الترتيب الزمني
          const Text('قادماً قريباً',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // البطاقات
          ..._sortedPayments().map((p) => _PaymentCard(
                payment: p,
                isDark: isDark,
                onToggle: () => setState(() {
                  final i = _payments.indexWhere((x) => x.id == p.id);
                  _payments[i] = p.copyWith(isActive: !p.isActive);
                }),
                onDelete: () => setState(() {
                  _payments.removeWhere((x) => x.id == p.id);
                }),
                onEdit: () => _showEditSheet(context, p, isDark),
              )),

          const SizedBox(height: 16),

          // دفعات موقوفة
          if (_payments.any((p) => !p.isActive)) ...[
            const Text('موقوفة مؤقتاً',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey)),
            const SizedBox(height: 10),
            ..._payments
                .where((p) => !p.isActive)
                .map((p) => _PaymentCard(
                      payment: p,
                      isDark: isDark,
                      onToggle: () => setState(() {
                        final i = _payments.indexWhere((x) => x.id == p.id);
                        _payments[i] = p.copyWith(isActive: !p.isActive);
                      }),
                      onDelete: () => setState(() {
                        _payments.removeWhere((x) => x.id == p.id);
                      }),
                      onEdit: () => _showEditSheet(context, p, isDark),
                    )),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context, isDark),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إضافة دفعة',
            style: TextStyle(
                fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<_ScheduledPayment> _sortedPayments() {
    return _payments
        .where((p) => p.isActive)
        .toList()
      ..sort((a, b) => a.nextDate.compareTo(b.nextDate));
  }

  void _showAddSheet(BuildContext context, bool isDark) {
    _showPaymentForm(context, isDark, null);
  }

  void _showEditSheet(
      BuildContext context, _ScheduledPayment payment, bool isDark) {
    _showPaymentForm(context, isDark, payment);
  }

  void _showPaymentForm(
      BuildContext context, bool isDark, _ScheduledPayment? existing) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final amountCtrl = TextEditingController(
        text: existing != null ? existing.amount.toStringAsFixed(0) : '');
    String freq = existing?.frequency ?? 'شهرياً';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.borderRadiusLarge)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existing == null ? 'إضافة دفعة مجدولة' : 'تعديل الدفعة',
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'اسم الدفعة',
                    labelStyle: const TextStyle(fontFamily: 'Cairo'),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'المبلغ (ريال)',
                    labelStyle: const TextStyle(fontFamily: 'Cairo'),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('التكرار:',
                    style: TextStyle(
                        fontFamily: 'Cairo', color: AppColors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['يومياً', 'أسبوعياً', 'شهرياً', 'سنوياً']
                      .map((f) => GestureDetector(
                            onTap: () => setS(() => freq = f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: freq == f
                                    ? AppColors.primaryBlue
                                    : AppColors.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(f,
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: freq == f
                                          ? Colors.white
                                          : AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty &&
                          amountCtrl.text.isNotEmpty) {
                        setState(() {
                          if (existing != null) {
                            final i = _payments
                                .indexWhere((x) => x.id == existing.id);
                            _payments[i] = existing.copyWith(
                              name: nameCtrl.text,
                              amount: double.tryParse(amountCtrl.text) ?? 0,
                              frequency: freq,
                            );
                          } else {
                            _payments.add(_ScheduledPayment(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              name: nameCtrl.text,
                              amount:
                                  double.tryParse(amountCtrl.text) ?? 0,
                              frequency: freq,
                              nextDate: DateTime.now()
                                  .add(const Duration(days: 30)),
                              icon: Icons.payment_rounded,
                              color: AppColors.primaryBlue,
                              isActive: true,
                              category: 'أخرى',
                            ));
                          }
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadius)),
                    ),
                    child: Text(
                      existing == null ? 'حفظ' : 'تحديث',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _SummaryTile({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 9,
                  color: AppColors.grey)),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final _ScheduledPayment payment;
  final bool isDark;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _PaymentCard({
    Key? key,
    required this.payment,
    required this.isDark,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysLeft =
        payment.nextDate.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3 && payment.isActive;

    return Dismissible(
      key: Key(payment.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius:
              BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onLongPress: onEdit,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: payment.isActive ? 1.0 : 0.55,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
              border: isUrgent
                  ? Border.all(
                      color: AppColors.warning.withValues(alpha: 0.6), width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                    blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: payment.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(payment.icon, color: payment.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(payment.name,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.repeat_rounded,
                              size: 12, color: AppColors.grey),
                          const SizedBox(width: 3),
                          Text(payment.frequency,
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: AppColors.grey)),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: isUrgent
                                ? AppColors.warning
                                : AppColors.grey,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isUrgent && daysLeft == 0
                                ? 'اليوم!'
                                : 'خلال $daysLeft يوم',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: isUrgent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isUrgent
                                    ? AppColors.warning
                                    : AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(payment.amount / 1000).toStringAsFixed(1)}K ر',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: payment.isActive
                              ? payment.color
                              : AppColors.grey),
                    ),
                    const SizedBox(height: 4),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: payment.isActive,
                        onChanged: (_) => onToggle(),
                        activeColor: AppColors.primaryBlue,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduledPayment {
  final String id, name, frequency, category;
  final double amount;
  final DateTime nextDate;
  final IconData icon;
  final Color color;
  final bool isActive;

  const _ScheduledPayment({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextDate,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.category,
  });

  _ScheduledPayment copyWith({
    String? name,
    double? amount,
    String? frequency,
    bool? isActive,
  }) {
    return _ScheduledPayment(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      nextDate: nextDate,
      icon: icon,
      color: color,
      isActive: isActive ?? this.isActive,
      category: category,
    );
  }
}
